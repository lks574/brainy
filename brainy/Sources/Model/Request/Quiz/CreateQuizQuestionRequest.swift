import Foundation

struct CreateQuizQuestionRequest: Codable, Sendable, Equatable {
  let id: String
  let question: String
  let correctAnswer: String
  let options: [String]
  let category: QuizCategory
  let difficulty: QuizDifficulty
  let mode: QuizMode
  let audioURL: String?
  let stageId: String?
  let orderInStage: Int?

  init(
    id: String,
    question: String,
    correctAnswer: String,
    category: QuizCategory,
    difficulty: QuizDifficulty,
    mode: QuizMode,
    options: [String],
    audioURL: String? = nil,
    stageId: String? = nil,
    orderInStage: Int? = nil
  ) {
    self.id = id
    self.question = question
    self.correctAnswer = correctAnswer
    self.options = options
    self.category = category
    self.difficulty = difficulty
    self.mode = mode
    self.audioURL = audioURL
    self.stageId = stageId
    self.orderInStage = orderInStage
  }
}
