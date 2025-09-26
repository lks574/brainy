import SwiftUI
import ComposableArchitecture

struct NavigationClient {
  var goToTextQuiz: @Sendable (QueryItem.TextQuiz) async -> Void
  var restartTextQuiz: @Sendable () async -> Void
  var goToQuizModeSelection: @Sendable () async -> Void
  var goToQuizCategorySelection: @Sendable (QuizMode) async -> Void
  var goToQuizResult: @Sendable (QuizStageResultDTO) async -> Void
  var goToCloseWithCategorySelection: @Sendable (QuizMode) async -> Void
  var goToClose: @Sendable () async -> Void
  var goToHistoryList: @Sendable () async -> Void
  var goToBack: @Sendable () async -> Void
}

extension NavigationClient: DependencyKey {
  static var liveValue = NavigationClient(
    goToTextQuiz: { _ in },
    restartTextQuiz: { },
    goToQuizModeSelection: { },
    goToQuizCategorySelection: { _ in },
    goToQuizResult: { _ in },
    goToCloseWithCategorySelection: { _ in },
    goToClose: { },
    goToHistoryList: { },
    goToBack: { }
  )

  static let testValue = NavigationClient(
    goToTextQuiz: { _ in },
    restartTextQuiz: { },
    goToQuizModeSelection: { },
    goToQuizCategorySelection: { _ in },
    goToQuizResult: { _ in },
    goToCloseWithCategorySelection: { _ in },
    goToClose: { },
    goToHistoryList: { },
    goToBack: { }
  )
}

extension DependencyValues {
  var navigation: NavigationClient {
    get { self[NavigationClient.self] }
    set { self[NavigationClient.self] = newValue }
  }
}

