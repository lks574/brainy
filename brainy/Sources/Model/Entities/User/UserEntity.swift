import Foundation
import SwiftData

@Model
final class UserEntity {
  @Attribute(.unique) var id: String
  var username: String
  var email: String?
  var profileImageURL: String?
  var createdAt: Date
  var updatedAt: Date

  // Stage 관련 통계
  var totalStagesCompleted: Int = 0
  var totalStars: Int = 0
  var currentStreak: Int = 0
  var bestStreak: Int = 0
  var favoriteCategory: String?

  // 관계
  @Relationship(deleteRule: .cascade) var stageResults: [QuizStageResultEntity] = []

  init(id: String, username: String, email: String? = nil, profileImageURL: String? = nil, favoriteCategory: QuizCategory? = nil) {
    self.id = id
    self.username = username
    self.email = email
    self.profileImageURL = profileImageURL
    self.createdAt = Date()
    self.updatedAt = Date()
    self.favoriteCategory = favoriteCategory?.rawValue
  }

  /// 전체 정확도 계산
  var overallAccuracy: Double {
    guard !stageResults.isEmpty else { return 0 }
    let totalScore = stageResults.reduce(0) { $0 + $1.score }
    let totalQuestions = stageResults.count * 10
    return Double(totalScore) / Double(totalQuestions)
  }

  /// 카테고리별 진행상황 계산
  func getCategoryProgress(for category: QuizCategory) -> (unlockedStage: Int, totalStars: Int, completedStages: Int) {
    let categoryResults = stageResults.filter { $0.stage?.categoryEnum == category }
    let completedStages = categoryResults.filter { $0.isCleared }.count
    let unlockedStage = completedStages + 1
    let totalStars = categoryResults.reduce(0) { $0 + $1.stars }

    return (unlockedStage: unlockedStage, totalStars: totalStars, completedStages: completedStages)
  }

  /// 사용자 통계 업데이트
  func updateStats() {
    totalStagesCompleted = stageResults.filter { $0.isCleared }.count
    totalStars = stageResults.reduce(0) { $0 + $1.stars }
    updateTimestamp()
  }

  /// 업데이트 시간 갱신
  func updateTimestamp() {
    self.updatedAt = Date()
  }
}
