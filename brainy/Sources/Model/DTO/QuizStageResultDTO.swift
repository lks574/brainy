import Foundation

struct QuizStageResultDTO: Codable, Sendable, Equatable, Identifiable {
  let id: String
  let userId: String
  let stageId: String
  let score: Int
  let stars: Int
  let timeSpent: TimeInterval
  let isCleared: Bool
  let completedAt: Date
  let accuracy: Double
  let accuracyPercentage: String
  let starsDisplay: String
}

// MARK: - Mock Data
extension QuizStageResultDTO {
  static let mock = QuizStageResultDTO(
    id: "result-1",
    userId: "user-1",
    stageId: "general_stage_1",
    score: 8,
    stars: 2,
    timeSpent: 120.5,
    isCleared: true,
    completedAt: Date(),
    accuracy: 0.8,
    accuracyPercentage: "80%",
    starsDisplay: "⭐⭐"
  )
}

extension [QuizStageResultDTO] {
  static let mockList = [
    QuizStageResultDTO(
      id: "result-1",
      userId: "user-1",
      stageId: "general_stage_1",
      score: 8,
      stars: 2,
      timeSpent: 120.5,
      isCleared: true,
      completedAt: Date().addingTimeInterval(-86400),
      accuracy: 0.8,
      accuracyPercentage: "80%",
      starsDisplay: "⭐⭐"
    ),
    QuizStageResultDTO(
      id: "result-2",
      userId: "user-1",
      stageId: "general_stage_2",
      score: 9,
      stars: 3,
      timeSpent: 95.2,
      isCleared: true,
      completedAt: Date().addingTimeInterval(-43200),
      accuracy: 0.9,
      accuracyPercentage: "90%",
      starsDisplay: "⭐⭐⭐"
    ),
    QuizStageResultDTO(
      id: "result-3",
      userId: "user-1",
      stageId: "history_stage_1",
      score: 7,
      stars: 1,
      timeSpent: 150.8,
      isCleared: true,
      completedAt: Date(),
      accuracy: 0.7,
      accuracyPercentage: "70%",
      starsDisplay: "⭐"
    )
  ]
}
