import ComposableArchitecture
import SwiftUI

@Reducer
struct QuizModeSelectionReducer {

  @Dependency(\.navigation) var navigation

  @ObservableState
  struct State: Equatable {
    var selectedQuizMode: QuizMode?
  }

  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case changeQuizMode(QuizMode)
    case goToProfile
    case goToHistoryList
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
        return .none

      case .goToProfile:
        return .none

      case .goToHistoryList:
        return .none
      }
    }
  }
}
