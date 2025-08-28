import ComposableArchitecture
import SwiftUI

@Reducer
struct TextQuizReducer {

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

  var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .goToBack:
        return .none

      case .tapRetry:
        return .none

      case .tapSubmitAnswer:
        return .none

      case .tapOption(let index):
        print("aaa index", index)
        return .none

      case .startStage:
        return .none
      }
    }
  }
}
