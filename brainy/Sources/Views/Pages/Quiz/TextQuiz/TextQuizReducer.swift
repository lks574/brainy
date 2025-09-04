import ComposableArchitecture

@Reducer
struct TextQuizReducer {

  @Dependency(\.navigation) var navigation

  @ObservableState
  struct State: Equatable {
    let quizMode: QuizMode
    let quizCategory: QuizCategory
    let stageId: String

    var isLoading: Bool = false
    var quizQuestions: [QuizQuestionDTO] = .mockList
    var currentQuestionIndex: Int = 0
    var timeRemaining: Int = 0
    var progress: Float = 0
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
        return .none
      }
    }
  }
}
