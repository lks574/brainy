import ComposableArchitecture

@Reducer
struct AppReducer {

  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    @Presents var present: Present.State?
  }

  enum Action {
    case path(StackAction<Path.State, Path.Action>)
    case present(PresentationAction<Present.Action>)
    case goToTextQuiz(QueryItem.TextQuiz)
    case goToQuizModeSelection
    case goToQuizCategorySelection(QuizMode)
    case goToQuizResult(QuizStageResultDTO)

    case restartTextQuiz

    case goToCloseWithCategorySelection(QuizMode)

    case goToClose
    case goToBack
  }

  @Reducer(state: .equatable)
  enum Present {
    case quizResult(QuizResultReducer)
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

      case .goToQuizResult(let result):
        state.present = .quizResult(.init(stageResult: result))
        return .none

      case .restartTextQuiz:
        // Dismiss result first, then forward retry to the most recent TextQuiz on the stack
        state.present = nil
        if let idx = state.path.lastIndex(where: {
          if case .textQuiz = $0 { return true } else { return false }
        }) {
          let id = state.path.ids[idx]
          return .send(.path(.element(id: id, action: .textQuiz(.tapRetry))))
        }
        return .none

      case .goToCloseWithCategorySelection(let mode):
        state.present = nil
        state.path.popOrPush(.quizCategorySelection(.init(quizMode: mode)))
        return .none

      case .goToClose:
        state.present = nil
        return .none

      case .goToBack:
        if !state.path.isEmpty {
          state.path.removeLast()
        }
        return .none

      case .path, .present:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
    .ifLet(\.$present, action: \.present)
  }
}

extension StackState where Element == Path.State {
  fileprivate mutating func popOrPush(_ new: Element) {
    if let i = self.lastIndex(where: { $0.caseID == new.caseID }) {
      self.removeSubrange(index(after: i)..<endIndex)
    } else {
      self.append(new)
    }
  }
}

@CasePathable
@Reducer(state: .equatable)
enum Path {
  case textQuiz(TextQuizReducer)
  case quizModeSelection(QuizModeSelectionReducer)
  case quizCategorySelection(QuizCategorySelectionReducer)
}

extension Path.State {
  fileprivate var caseID: String {
    switch self {
      case .textQuiz: "textQuiz"
      case .quizModeSelection: "quizModeSelection"
      case .quizCategorySelection: "quizCategorySelection"
    }
  }
}
