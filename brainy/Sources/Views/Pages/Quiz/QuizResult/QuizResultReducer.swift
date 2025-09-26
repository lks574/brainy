import ComposableArchitecture
import SwiftUI

@Reducer
struct QuizResultReducer {
  @Dependency(\.navigation) var navigation

  @ObservableState
  struct State: Equatable {
    let stageResult: QuizStageResultDTO

    var category: QuizCategory {
      getCategoryFromStageId(stageResult.stageId)
    }

    var stageDisplayName: String {
      let components = stageResult.stageId.components(separatedBy: "_")
      if components.count >= 3,
         let stageNumber = components.last {
        return "\(category.displayName) \(stageNumber)단계"
      }
      return stageResult.stageId
    }

    var isCleared: Bool {
      stageResult.isCleared
    }

    var congratulationMessage: String {
      if isCleared {
        if stageResult.stars == 3 {
          return "완벽해요! 🌟"
        } else if stageResult.stars == 2 {
          return "훌륭해요! ⭐"
        } else {
          return "잘했어요! 👏"
        }
      } else {
        return "아쉬워요 😅"
      }
    }

    private func getCategoryFromStageId(_ stageId: String) -> QuizCategory {
      let components = stageId.components(separatedBy: "_")
      guard let categoryString = components.first,
            let category = QuizCategory(rawValue: categoryString) else {
        return .general
      }
      return category
    }
  }

  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case retryStage
    case goToClose
    case goToHistory
  }

  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .retryStage:
        return .run { _ in
          // Close the result sheet to reveal the existing TextQuiz underneath, then restart it
          await navigation.goToClose()
          await navigation.restartTextQuiz()
        }

      case .goToClose:
        return .run { _ in
          await navigation.goToCloseWithCategorySelection(.multipleChoice)
        }

      case .goToHistory:
        return .none
      }
    }
  }
}

