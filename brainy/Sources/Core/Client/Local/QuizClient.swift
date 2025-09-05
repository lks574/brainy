import ComposableArchitecture
import Foundation

@DependencyClient
struct QuizClient {
  var loadInitialDataIfNeeded: @Sendable () async throws -> Void
  var deleteAllData: @Sendable () async throws -> Void

  var createQuestion: @Sendable (CreateQuizQuestionRequest) async throws -> QuizQuestionDTO
}

extension QuizClient: DependencyKey {
  static let liveValue: QuizClient = {
    let repository = QuizRepository()
    return QuizClient(
      loadInitialDataIfNeeded: {
        try repository.loadInitialDataIfNeeded()
      },
      deleteAllData: {
        try repository.deleteAllData()
      },
      createQuestion: { req in
        try repository.createQuestion(req)
      }
    )
  }()
}

extension QuizClient {
  static let testValue = QuizClient(
    loadInitialDataIfNeeded: {},
    deleteAllData: {},
    createQuestion: { _ in .mock }
  )

  static let previewValue = testValue
}

extension DependencyValues {
  var quizClient: QuizClient {
    get { self[QuizClient.self] }
    set { self[QuizClient.self] = newValue }
  }
}
