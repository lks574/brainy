import ComposableArchitecture

@Reducer
struct AppFeature {

  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    var rootState = TextQuizReducer.State(quizMode: .multipleChoice, quizCategory: .drama, stageId: "123")
  }

  enum Action {
    case path(StackAction<Path.State, Path.Action>)
    case goToTextQuiz(QueryItem.TextQuiz)
    case goToBack
    case root(TextQuizReducer.Action)
  }

  @Reducer(state: .equatable)
  enum Path {
    case textQuiz(TextQuizReducer)
  }

  var body: some ReducerOf<Self> {

    Reduce { state, action in
      switch action {
      case .goToTextQuiz(let model):
        state.path.append(.textQuiz(.init(quizMode: model.quizMode, quizCategory: model.quizCategory, stageId: model.stageID)))
        return .none

      case .goToBack:
        if !state.path.isEmpty {
          state.path.removeLast()
        }
        return .none
      case .path, .root:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}
