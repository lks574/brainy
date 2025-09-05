import Foundation
import SwiftData

@Model
final class QuizQuestionEntity {
  @Attribute(.unique) var id: String
  var question: String
  var correctAnswer: String
  var options: [String]
  var category: String
  var difficulty: String
  var mode: String
  var audioURL: String? // 음성모드인 경우
  var stageId: String? // 어떤 스테이지에 속하는지
  var orderInStage: Int? // 스테이지 내에서의 순서 (1-10)

  // 관계
  @Relationship var stage: QuizStageEntity?

  init(id: String, question: String, correctAnswer: String, category: QuizCategory, difficulty: QuizDifficulty, mode: QuizMode, options: [String], audioURL: String? = nil, stageId: String? = nil, orderInStage: Int? = nil) {
    self.id = id
    self.question = question
    self.correctAnswer = correctAnswer
    self.category = category.rawValue
    self.difficulty = difficulty.rawValue
    self.mode = mode.rawValue
    self.options = options
    self.audioURL = audioURL
    self.stageId = stageId
    self.orderInStage = orderInStage
  }

  /// 카테고리 enum 반환
  var categoryEnum: QuizCategory {
    return QuizCategory(rawValue: category) ?? .general
  }

  /// 난이도 enum 반환
  var difficultyEnum: QuizDifficulty {
    return QuizDifficulty(rawValue: difficulty) ?? .easy
  }

  /// 타입 enum 반환
  var modeEnum: QuizMode {
    return QuizMode(rawValue: mode) ?? .multipleChoice
  }
}
