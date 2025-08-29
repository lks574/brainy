import ComposableArchitecture
import SwiftUI

enum QuizModeSelectionPage {

  struct RootView: View {
    @Bindable var store: StoreOf<QuizModeSelectionReducer>

    var body: some View {
      VStack(spacing: 32) {
        HeaderSection()

        QuizModeSection(
          selectedQuizMode: store.selectedQuizMode,
          action: { viewAction in
            switch viewAction {
            case .changeQuizMode(let quizMode):
              store.send(.changeQuizMode(quizMode))
            }
          }
        )

        Spacer()

        BottomNavigationSection(
          action: { viewAction in
            switch viewAction {
            case .tapHistoryList:
              store.send(.goToHistoryList)
            case .tapProfile:
              store.send(.goToProfile)
            }
          }
        )
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 32)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.brainyBackground)
      .navigationBarHidden(true)
    }
  }

}

struct QuizModeSelectionPage_Previews: PreviewProvider {

  static var previews: some View {
    QuizModeSelectionPage.RootView(
      store: .init(
        initialState: QuizModeSelectionReducer.State(),
        reducer: {
          QuizModeSelectionReducer()
        })
    )
  }
}
