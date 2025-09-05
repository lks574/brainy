import Foundation

struct QuizStageDTO: Codable, Sendable, Equatable, Identifiable {
  let id: String
  let stageNumber: Int
  let category: QuizCategory
  let difficulty: QuizDifficulty
  let title: String
  let requiredAccuracy: Double
  let totalQuestions: Int
  let createdAt: Date
}

extension QuizStageDTO {
  init(from entity: QuizStageEntity) {
    self.id = entity.id
    self.stageNumber = entity.stageNumber
    self.category = entity.categoryEnum
    self.difficulty = entity.difficultyEnum
    self.title = entity.title
    self.requiredAccuracy = entity.requiredAccuracy
    self.totalQuestions = entity.totalQuestions
    self.createdAt = entity.createdAt
  }
}

// MARK: - Mock Data
extension QuizStageDTO {
  static let mock = QuizStageDTO(
    id: "general_stage_1",
    stageNumber: 1,
    category: .general,
    difficulty: .easy,
    title: "일반상식 1단계",
    requiredAccuracy: 0.7,
    totalQuestions: 10,
    createdAt: Date()
  )
}

extension [QuizStageDTO] {
  static let mockList = [
    QuizStageDTO(
      id: "general_stage_1",
      stageNumber: 1,
      category: .general,
      difficulty: .easy,
      title: "일반상식 1단계",
      requiredAccuracy: 0.7,
      totalQuestions: 10,
      createdAt: Date()
    ),
    QuizStageDTO(
      id: "general_stage_2",
      stageNumber: 2,
      category: .general,
      difficulty: .easy,
      title: "일반상식 2단계",
      requiredAccuracy: 0.7,
      totalQuestions: 10,
      createdAt: Date()
    ),
    QuizStageDTO(
      id: "general_stage_3",
      stageNumber: 3,
      category: .general,
      difficulty: .easy,
      title: "일반상식 3단계",
      requiredAccuracy: 0.7,
      totalQuestions: 10,
      createdAt: Date()
    )
  ]
}
