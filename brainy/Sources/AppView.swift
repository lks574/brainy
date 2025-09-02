import SwiftUI
import ComposableArchitecture

struct AppView: View {

  @Bindable var store: StoreOf<AppReducer>

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

          Button(action: { store.send(.goToQuizModeSelection) })
          {
            Text("QuizModeSelectionPage 이동")
          }

          Button(action: { store.send(.goToQuizCategorySelection(.multipleChoice)) })
          {
            Text("QuizCategorySelectionPage 이동")
          }

          Button(action: { store.send(.goToQuizResult(.mock)) })
          {
            Text("QuizResultPage 이동")
          }
        }
      },
      destination: { store in
        switch store.case {
        case .textQuiz(let store):
          TextQuizPage.RootView(store: store)
        case .quizModeSelection(let store):
          QuizModeSelectionPage.RootView(store: store)
        case .quizCategorySelection(let store):
          QuizCategorySelectionPage.RootView(store: store)
        case .quizResult(let store):
          QuizResultPage.RootView(store: store)
        }
      })
  }
}
