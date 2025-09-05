import Foundation
import SwiftData

@Model
final class QuizStageEntity {
  @Attribute(.unique) var id: String
  var stageNumber: Int
  var category: String
  var difficulty: String
  var title: String
  var requiredAccuracy: Double = 0.7  // 70% 클리어 기준
  var totalQuestions: Int = 10
  var createdAt: Date

  // 관계
  @Relationship(deleteRule: .cascade) var stageResults: [QuizStageResultEntity] = []
  @Relationship(deleteRule: .cascade) var questions: [QuizQuestionEntity] = []

  init(id: String, stageNumber: Int, category: QuizCategory, difficulty: QuizDifficulty, title: String) {
    self.id = id
    self.stageNumber = stageNumber
    self.category = category.rawValue
    self.difficulty = difficulty.rawValue
    self.title = title
    self.createdAt = Date()
  }

  /// 카테고리 enum 반환
  var categoryEnum: QuizCategory {
    return QuizCategory(rawValue: category) ?? .general
  }

  /// 난이도 enum 반환
  var difficultyEnum: QuizDifficulty {
    return QuizDifficulty(rawValue: difficulty) ?? .easy
  }

  /// 스테이지 완료 여부 확인 (특정 사용자)
  func isCompleted(by userId: String) -> Bool {
    return stageResults.contains { $0.userId == userId && $0.isCleared }
  }

  /// 스테이지 최고 기록 (특정 사용자)
  func bestResult(for userId: String) -> QuizStageResultEntity? {
    return stageResults
      .filter { $0.userId == userId }
      .max { $0.score < $1.score }
  }

  /// 카테고리별 총 스테이지 수 계산 (정적 메서드)
  static func getTotalStagesCount(for category: QuizCategory, in context: ModelContext) -> Int {
    let descriptor = FetchDescriptor<QuizStageEntity>(
      predicate: #Predicate { stage in
        stage.category == category.rawValue
      }
    )

    do {
      let stages = try context.fetch(descriptor)
      return stages.count
    } catch {
      print("Error fetching total stages for category \(category): \(error)")
      return 0
    }
  }

  /// 카테고리별 완료된 스테이지 수 계산 (정적 메서드)
  static func getCompletedStagesCount(for category: QuizCategory, userId: String, in context: ModelContext) -> Int {
    let descriptor = FetchDescriptor<QuizStageEntity>(
      predicate: #Predicate { stage in
        stage.category == category.rawValue
      }
    )

    do {
      let stages = try context.fetch(descriptor)
      return stages.filter { $0.isCompleted(by: userId) }.count
    } catch {
      print("Error fetching completed stages for category \(category): \(error)")
      return 0
    }
  }
}
