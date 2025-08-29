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
      goToBack: { [store] in
        await store.send(.goToBack)
      }
    )
  }
}
