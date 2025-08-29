import SwiftUI
import ComposableArchitecture

@main
struct BrainyApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(
        store: Store(initialState: AppFeature.State()) {
          AppFeature()
        }
      )
    }
  }
}
