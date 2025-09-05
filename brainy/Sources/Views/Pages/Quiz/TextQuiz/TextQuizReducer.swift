import ComposableArchitecture
import Foundation

@Reducer
struct TextQuizReducer {

  @Dependency(\.navigation) var navigation
  @Dependency(\.quizClient) var quizClient

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
  }

  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case goToBack

    case tapRetry
    case tapSubmitAnswer
    case tapOption(Int)

    case startStage
    case getStageQuestions

    case fetchStageQuestions([QuizQuestionDTO])
  }

  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .goToBack:
        return .run { _ in
          await navigation.goToBack()
        }

      case .tapRetry:
        return .none

      case .tapSubmitAnswer:
        return .run { _ in
          await navigation.goToQuizResult(.mock)
        }

      case .tapOption(let index):
        state.selectedOptionIndex = index
        return .none

      case .startStage:
        state.startTime = Date()
        return .send(.getStageQuestions)

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
        return .none
      }
    }
  }
}
