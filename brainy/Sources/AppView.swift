import SwiftUI
import ComposableArchitecture

struct AppView: View {

  @Bindable var store: StoreOf<AppFeature>

  var body: some View {
    NavigationStack(
      path: $store.scope(state: \.path, action: \.path),
      root: {
        VStack(spacing: 8) {
          Button(action: { store.send(.goToTextQuiz(.init(
            quizMode: .multipleChoice,
            quizCategory: .drama,
            stageID: "123123"))) })
          {
            Text("TextQuizPage 이동")
          }
        }
      },
      destination: { store in
        switch store.case {
        case .textQuiz(let store):
          TextQuizPage.RootView(store: store)
        }
      })
  }
}
