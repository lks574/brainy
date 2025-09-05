import Foundation
import SwiftData

@Model
final class QuizStageResultEntity {
  @Attribute(.unique) var id: String
  var userId: String
  var stageId: String
  var score: Int                    // 맞춘 문제 수 (0-5)
  var stars: Int                    // 별점 (1-3개)
  var timeSpent: TimeInterval       // 소요 시간
  var isCleared: Bool               // 70% 이상 여부
  var completedAt: Date

  // 관계
  @Relationship var user: UserEntity?
  @Relationship var stage: QuizStageEntity?

  init(id: String, userId: String, stageId: String, score: Int, timeSpent: TimeInterval) {
    self.id = id
    self.userId = userId
    self.stageId = stageId
    self.score = score
    self.timeSpent = timeSpent
    self.completedAt = Date()

    // 정확도 계산
    let accuracy = Double(score) / 5
    self.isCleared = accuracy >= 0.6

    // 별점 계산
    if accuracy >= 0.9 {
      self.stars = 3
    } else if accuracy >= 0.7 {
      self.stars = 2
    } else if accuracy >= 0.6 {
      self.stars = 1
    } else {
      self.stars = 0
    }
  }

  /// 정확도 계산
  var accuracy: Double {
    return Double(score) / 5.0
  }

  /// 정확도 퍼센트 문자열
  var accuracyPercentage: String {
    return String(format: "%.0f%%", accuracy * 100)
  }

  /// 별점 문자열
  var starsDisplay: String {
    return String(repeating: "⭐", count: stars)
  }
}
