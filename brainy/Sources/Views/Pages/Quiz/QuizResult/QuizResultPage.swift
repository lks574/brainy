import Foundation
import ComposableArchitecture
import SwiftUI

enum QuizResultPage {
  struct RootView: View {
    @Bindable var store: StoreOf<QuizResultReducer>

    var body: some View {
      VStack(spacing: 0) {
        HeaderView(
          congratulationMessage: store.congratulationMessage,
          stageDisplayName: store.stageDisplayName,
          action: { viewAction in
            switch viewAction {
            case .tapBack:
              store.send(.goToQuizCategorySelection)
            }
          }
        )

        ScrollView {
          VStack(spacing: 24) {
            ResultCardView(
              isCleared: store.isCleared,
              stageResult: store.stageResult)

            StatisticsView(
              isCleared: store.isCleared,
              stageResult: store.stageResult)

            ActionButtonsView(
              action: { viewAction in
                switch viewAction {
                case .tapRetryStage:
                  store.send(.retryStage)
                case .tapOtherQuiz:
                  store.send(.goToQuizCategorySelection)
                case .tapHistory:
                  store.send(.goToHistory)
                }
              }
            )
          }
          .padding(.horizontal, 24)
          .padding(.bottom, 32)
        }
      }
      .background(Color.brainyBackground)
      .navigationBarHidden(true)
    }
  }
}
