import ComposableArchitecture

@Reducer
struct AppReducer {

  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
  }

  enum Action {
    case path(StackAction<Path.State, Path.Action>)
    case goToTextQuiz(QueryItem.TextQuiz)
    case goToQuizModeSelection
    case goToQuizCategorySelection(QuizMode)
    case goToBack
  }

  @Reducer(state: .equatable)
  enum Path {
    case textQuiz(TextQuizReducer)
    case quizModeSelection(QuizModeSelectionReducer)
    case quizCategorySelection(QuizCategorySelectionReducer)
  }

  var body: some ReducerOf<Self> {

    Reduce { state, action in
      switch action {
      case .goToTextQuiz(let model):
        state.path.append(.textQuiz(.init(quizMode: model.quizMode, quizCategory: model.quizCategory, stageId: model.stageID)))
        return .none

      case .goToQuizModeSelection:
        state.path.append(.quizModeSelection(
          .init())
        )
        return .none

      case .goToQuizCategorySelection(let mode):
        state.path.append(.quizCategorySelection(.init(quizMode: mode)))
        return .none

      case .goToBack:
        if !state.path.isEmpty {
          state.path.removeLast()
        }
        return .none

      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}
