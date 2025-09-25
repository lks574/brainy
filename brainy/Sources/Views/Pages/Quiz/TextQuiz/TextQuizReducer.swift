import ComposableArchitecture
import Foundation

@Reducer
struct TextQuizReducer {

  @Dependency(\.navigation) var navigation
  @Dependency(\.quizClient) var quizClient
  @Dependency(\.continuousClock) var clock
  let sideEffect = TextQuizSideEffect()
  private let perQuestionDuration: Int = 15

  @ObservableState
  struct State: Equatable {
    let quizMode: QuizMode
    let quizCategory: QuizCategory
    let stageId: String

    var isLoading: Bool = false
    var quizQuestions: [QuizQuestionDTO] = []
    var currentQuestionIndex: Int = 0

    var timeRemaining: Int = 0
    var progress: Float = 0
    var score: Int = 0
    var userAnswers: [String] = [] // 사용자 답안 기록
    var startTime: Date = Date()   // 게임 시작 시간

    var selectedOptionIndex: Int?

    var errorMessage: String?
    var isLastQuestion: Bool = false

    var hasAnswered: Bool {
      currentQuestion != nil && selectedOptionIndex != nil
    }

    var currentQuestion: QuizQuestionDTO? {
      guard currentQuestionIndex < quizQuestions.count else { return nil }
      return quizQuestions[currentQuestionIndex]
    }

    var getCurrentUserID: String {
      // 실제 구현에서는 UserDefaults, Keychain 등에서 사용자 ID를 가져와야 함
      return UserDefaults.standard.string(forKey: "current_user_id") ?? "default_user"
    }
  }

  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case goToBack

    case tapRetry
    case tapSubmitAnswer
    case tapOption(Int)
    case tapSkip

    case startStage
    case completeStage

    case getStageQuestions
    case fetchStageQuestions([QuizQuestionDTO])
    case stageQuestionsLoadFailed(String)

    // Timer
    case startTimer(Int)
    case tick
    case stopTimer
    case timeUp
  }

  enum CancelID { case timer }

  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .goToBack:
        return .merge(
          .send(.stopTimer),
          .run { _ in
            await navigation.goToBack()
          }
        )

      case .tapRetry:
        return .merge(
          .send(.stopTimer),
          .send(.getStageQuestions)
        )

      case .tapSubmitAnswer:
        guard state.hasAnswered else { return .none }

        // 사용자 답안 기록
        let userAnswer = sideEffect.getUserAnswer(
          selectedIndex: state.selectedOptionIndex,
          shortAnswer: "",
          question: state.currentQuestion)
        state.userAnswers.append(userAnswer)

        // 정답 체크 및 점수 업데이트
        if let currentQuestion = state.currentQuestion {
          let isCorrect = sideEffect.checkAnswer(
            question: currentQuestion,
            selectedIndex: state.selectedOptionIndex,
            shortAnswer: ""
          )
          if isCorrect {
            state.score += 1
          }
        }

        if state.currentQuestionIndex < state.quizQuestions.count - 1 {
          state.currentQuestionIndex += 1
          state.selectedOptionIndex = nil

          // 진행률 업데이트
          state.progress = Float(state.currentQuestionIndex) / Float(state.quizQuestions.count)

          // 마지막 문제인지 확인
          state.isLastQuestion = state.currentQuestionIndex == state.quizQuestions.count - 1

          // 다음 문제 타이머 시작
          return .send(.startTimer(perQuestionDuration))
        } else {
          // 스테이지 완료
          return .merge(
            .send(.stopTimer),
            .send(.completeStage)
          )
        }

      case .timeUp:
        // 시간 종료: 무응답으로 기록하고 다음 문제로 이동 또는 완료
        let userAnswer = sideEffect.getUserAnswer(
          selectedIndex: nil,
          shortAnswer: "",
          question: state.currentQuestion
        )
        state.userAnswers.append(userAnswer)

        if state.currentQuestionIndex < state.quizQuestions.count - 1 {
          state.currentQuestionIndex += 1
          state.selectedOptionIndex = nil

          state.progress = Float(state.currentQuestionIndex) / Float(state.quizQuestions.count)
          state.isLastQuestion = state.currentQuestionIndex == state.quizQuestions.count - 1

          return .send(.startTimer(perQuestionDuration))
        } else {
          return .merge(
            .send(.stopTimer),
            .send(.completeStage)
          )
        }

      case .tapSkip:
        // 사용자 건너뛰기: 무응답으로 기록하고 다음 문제로 이동 또는 완료
        let userAnswer = sideEffect.getUserAnswer(
          selectedIndex: nil,
          shortAnswer: "",
          question: state.currentQuestion
        )
        state.userAnswers.append(userAnswer)

        if state.currentQuestionIndex < state.quizQuestions.count - 1 {
          state.currentQuestionIndex += 1
          state.selectedOptionIndex = nil

          state.progress = Float(state.currentQuestionIndex) / Float(state.quizQuestions.count)
          state.isLastQuestion = state.currentQuestionIndex == state.quizQuestions.count - 1

          return .send(.startTimer(perQuestionDuration))
        } else {
          return .merge(
            .send(.stopTimer),
            .send(.completeStage)
          )
        }

      case .tapOption(let index):
        state.selectedOptionIndex = index
        return .none

      case .startStage:
        state.startTime = Date()
        return .send(.getStageQuestions)

      case .completeStage:
        return .run { [state] send in
          do {
            let userId = state.getCurrentUserID
            let totalTime = Date().timeIntervalSince(state.startTime)

            let result = try await quizClient.createStageResult(
              userId,
              state.stageId,
              state.score,
              totalTime
            )
            await navigation.goToQuizResult(result)

          } catch {
            // 에러 처리
            print("Failed to save stage result: \(error)")
            await send(.stageQuestionsLoadFailed("결과 저장에 실패했습니다."))
          }
        }

      case .getStageQuestions:
        state.isLoading = true
        state.errorMessage = nil

        // 빈 stageId인 경우 에러 처리
        guard !state.stageId.isEmpty else {
          state.isLoading = false
          state.errorMessage = "해당 카테고리의 스테이지가 준비 중입니다."
          return .none
        }

        return .run { [stageId = state.stageId, quizClient] send in
          do {
            // 스테이지별 문제 로드
            let questions = try await quizClient.fetchQuestionsForStage(stageId)
            await send(.fetchStageQuestions(questions))
          } catch {
            await send(.stageQuestionsLoadFailed(error.localizedDescription))
          }
        }

      case .fetchStageQuestions(let questions):
        state.isLoading = false
        state.quizQuestions = questions
        state.progress = 0.0
        state.score = 0
        state.userAnswers = []
        state.currentQuestionIndex = 0
        state.isLastQuestion = questions.count == 1
        if questions.isEmpty {
          return .none
        } else {
          return .send(.startTimer(perQuestionDuration))
        }

      case .stageQuestionsLoadFailed(let errorMessage):
        state.isLoading = false
        state.errorMessage = errorMessage
        return .none

      case .startTimer(let seconds):
        state.timeRemaining = seconds
        return .run { [clock] send in
          for await _ in clock.timer(interval: .seconds(1)) {
            await send(.tick)
          }
        }
        .cancellable(id: CancelID.timer, cancelInFlight: true)

      case .tick:
        if state.timeRemaining > 0 {
          state.timeRemaining -= 1
          if state.timeRemaining == 0 {
            return .send(.timeUp)
          }
        }
        return .none

      case .stopTimer:
        return .cancel(id: CancelID.timer)
      }
    }
  }
}
