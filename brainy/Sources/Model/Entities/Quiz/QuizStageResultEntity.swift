import Foundation
import SwiftData

@Model
final class QuizStageResultEntity {
  @Attribute(.unique) var id: String
  var userId: String
  var stageId: String
  var score: Int                    // 맞춘 문제 수 (해당 스테이지의 총 문항 수 대비)
  var stars: Int                    // 별점 (0-3개)
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

    // 초기값: 정확도/별점/클리어 여부는 저장소에서 스테이지 정보 기반으로 계산하여 설정
    self.isCleared = false
    self.stars = 0
  }

  /// 정확도 계산
  var accuracy: Double {
    let total = stage?.totalQuestions ?? 10
    guard total > 0 else { return 0 }
    return Double(score) / Double(total)
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
