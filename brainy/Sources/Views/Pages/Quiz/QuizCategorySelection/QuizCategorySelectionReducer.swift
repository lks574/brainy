import SwiftUI
import ComposableArchitecture

@Reducer
struct QuizCategorySelectionReducer {

  @Dependency(\.navigation) var navigation
  @Dependency(\.quizClient) var quizClient

  let sideEffect = QuizCategorySelectionSideEffect()

  @ObservableState
  struct State: Equatable {
    let quizMode: QuizMode

    var selectedCategory: QuizCategory?
    var selectedQuestionFilter: QuestionFilter = .random
    var categoryProgress: [QuizCategory: CategoryProgress] = [:]

    var getCurrentUserID: String {
      // 실제 구현에서는 UserDefaults, Keychain 등에서 사용자 ID를 가져와야 함
      return UserDefaults.standard.string(forKey: "current_user_id") ?? "default_user"
    }
  }

  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case goToBack
    case goToQuizPlay
    case changeFilter(QuestionFilter)
    case changeCategory(QuizCategory)
    case loadCategoryProgress
    case categoryProgressLoaded([QuizCategory: CategoryProgress])
  }

  struct CategoryProgress: Equatable {
    let stageID: String?
    let totalStages: Int
    let completedStages: Int

    var progressPercentage: Double {
      guard totalStages > 0 else { return 0.0 }
      return Double(completedStages) / Double(totalStages)
    }
  }

  var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .goToBack:
        return .run { _ in
          await navigation.goToBack()
        }

      case .goToQuizPlay:
        guard
          let progress = state.categoryProgress[state.selectedCategory ?? .general],
          let stageID = progress.stageID
        else {
          print("Error: Stage 없음")
          return .none
        }
        return .run { [state] _ in
          await navigation.goToTextQuiz(.init(
            quizMode: state.quizMode,
            quizCategory: state.selectedCategory ?? .general,
            stageID: stageID))
        }

      case .changeFilter(let filter):
        state.selectedQuestionFilter = filter
        return .none

      case .changeCategory(let category):
        state.selectedCategory = category
        return .none

      case .loadCategoryProgress:
        return .run { [quizClient, userID = state.getCurrentUserID] send in
          let progress = await sideEffect.loadCategoryProgressData(userId: userID, quizClient: quizClient)
          await send(.categoryProgressLoaded(progress))
        }

      case .categoryProgressLoaded(let progress):
        state.categoryProgress = progress
        return .none
      }
    }
  }
}

extension [QuizCategory: QuizCategorySelectionReducer.CategoryProgress] {
  fileprivate static var mock: Self {
    [
      .general: .init(
        stageID: "stage-1",
        totalStages: 10,
        completedStages: 1
      ),
    ]
  }
}
