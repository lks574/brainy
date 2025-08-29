import SwiftUI
import ComposableArchitecture

@Reducer
struct QuizCategorySelectionReducer {
  @Dependency(\.navigation) var navigation

  @ObservableState
  struct State: Equatable {
    let quizMode: QuizMode

    var selectedCategory: QuizCategory?
    var selectedQuestionFilter: QuestionFilter = .random
    var categoryProgress: [QuizCategory: CategoryProgress] = [:]
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
        return .none

      case .changeFilter(let filter):
        state.selectedQuestionFilter = filter
        return .none

      case .changeCategory(let category):
        state.selectedCategory = category
        return .none

      case .loadCategoryProgress:
        return .none

      case .categoryProgressLoaded(let progress):
        state.categoryProgress = progress
        return .none
      }
    }
  }
}
