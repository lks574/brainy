import ComposableArchitecture
import Foundation

@DependencyClient
struct QuizClient {
  var loadInitialDataIfNeeded: @Sendable () async throws -> Void
  var deleteAllData: @Sendable () async throws -> Void

  var createQuestion: @Sendable (CreateQuizQuestionRequest) async throws -> QuizQuestionDTO
  var createStageResult: @Sendable (String, String, Int, TimeInterval) async throws -> QuizStageResultDTO

  var getCategoryStageStats: @Sendable (String, QuizCategory) async throws -> (completedStages: Int, totalStars: Int, unlockedStage: Int)
  var fetchStageResults: @Sendable (String) async throws -> [QuizStageResultDTO]

  var fetchStagesByCategory: @Sendable (QuizCategory) async throws -> [QuizStageDTO]
  var fetchQuestionsForStage: @Sendable (String) async throws -> [QuizQuestionDTO]
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
      },
      createStageResult: { userId, stageId, score, timeSpent in
        try repository.createStageResult(userId: userId, stageId: stageId, score: score, timeSpent: timeSpent)
      },
      getCategoryStageStats: { userId, category in
        try repository.getCategoryStageStats(userId: userId, category: category)
      },
      fetchStageResults: { userId in
        try repository.fetchStageResults(userId: userId)
      },
      fetchStagesByCategory: { category in
        try repository.fetchStagesByCategory(category)
      },
      fetchQuestionsForStage: { stageId in
        try repository.fetchQuestionsForStage(stageId: stageId)
      }
    )
  }()
}

extension QuizClient {
  static let testValue = QuizClient(
    loadInitialDataIfNeeded: {},
    deleteAllData: {},
    createQuestion: { _ in .mock },
    createStageResult: { _, _, _, _ in .mock },
    getCategoryStageStats: { _, _ in (completedStages: 5, totalStars: 12, unlockedStage: 6) },
    fetchStageResults: { _ in .mockList },
    fetchStagesByCategory: { _ in .mockList },
    fetchQuestionsForStage: { _ in .mockList }
  )

  static let previewValue = testValue
}

extension DependencyValues {
  var quizClient: QuizClient {
    get { self[QuizClient.self] }
    set { self[QuizClient.self] = newValue }
  }
}
