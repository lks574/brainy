import SwiftUI
import ComposableArchitecture

struct NavigationClient {
  var goToTextQuiz: @Sendable (QueryItem.TextQuiz) async -> Void
  var goToQuizModeSelection: @Sendable () async -> Void
  var goToBack: @Sendable () async -> Void
}

extension NavigationClient: DependencyKey {
  static var liveValue = NavigationClient(
    goToTextQuiz: { _ in },
    goToQuizModeSelection: { },
    goToBack: { }
  )

  static let testValue = NavigationClient(
    goToTextQuiz: { _ in },
    goToQuizModeSelection: { },
    goToBack: { }
  )
}

extension DependencyValues {
  var navigation: NavigationClient {
    get { self[NavigationClient.self] }
    set { self[NavigationClient.self] = newValue }
  }
}
