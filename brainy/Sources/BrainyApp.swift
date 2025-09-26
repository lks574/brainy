import SwiftUI
import ComposableArchitecture

@main
struct BrainyApp: App {
  @State private var store: StoreOf<AppReducer>

  init() {
    let store = Store(initialState: AppReducer.State()) {
      AppReducer()
    }
    self._store = State(initialValue: store)
  }


  var body: some Scene {
    WindowGroup {
      AppView(store: store)
        .onAppear {
          setupNavigationDependency()
        }
    }
  }

  private func setupNavigationDependency() {
    NavigationClient.liveValue = NavigationClient(
      goToTextQuiz: { [store] item in
        await store.send(.goToTextQuiz(item))
      },
      restartTextQuiz: { [store] in
        await store.send(.restartTextQuiz)
      },
      goToQuizModeSelection: { [store] in
        await store.send(.goToQuizModeSelection)
      },
      goToQuizCategorySelection: { [store] mode in
        await store.send(.goToQuizCategorySelection(mode))
      },
      goToQuizResult: { [store] result in
        await store.send(.goToQuizResult(result))
      },
      goToCloseWithCategorySelection: { [store] mode in
        await store.send(.goToCloseWithCategorySelection(mode))
      },
      goToClose: { [store] in
        await store.send(.goToClose)
      },
      goToHistoryList: { [store] in
        await store.send(.goToHistoryList)
      },
      goToBack: { [store] in
        await store.send(.goToBack)
      }
    )
  }
}
