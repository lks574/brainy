import ComposableArchitecture
import SwiftUI

@Reducer
struct QuizModeSelectionReducer {

  @Dependency(\.navigation) var navigation
  @Dependency(\.quizClient) var quizClient

  @ObservableState
  struct State: Equatable {
    var selectedQuizMode: QuizMode?
  }

  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case changeQuizMode(QuizMode)
    case goToProfile
    case goToHistoryList

    case loadQuiz
  }

  var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .changeQuizMode(let quizMode):
        state.selectedQuizMode = quizMode
        guard quizMode == .multipleChoice else {
          return .none
        }
        return .run { _ in
          await navigation.goToQuizCategorySelection(quizMode)
        }

      case .goToProfile:
        return .none

      case .goToHistoryList:
        return .none

      case .loadQuiz:
        return .run { _ in
          try await quizClient.loadInitialDataIfNeeded()
        }
      }
    }
  }
}
