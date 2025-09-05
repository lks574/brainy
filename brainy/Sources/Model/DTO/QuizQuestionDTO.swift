import Foundation

struct QuizQuestionDTO: Codable, Sendable, Equatable, Identifiable {
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
}

extension QuizQuestionDTO {
  init(from entity: QuizQuestionEntity) {
    self.id = entity.id
    self.question = entity.question
    self.correctAnswer = entity.correctAnswer
    self.options = entity.options
    self.category = entity.categoryEnum
    self.difficulty = entity.difficultyEnum
    self.mode = entity.modeEnum
    self.audioURL = entity.audioURL
    self.stageId = entity.stageId
    self.orderInStage = entity.orderInStage
  }
}

// MARK: - Mock Data
extension QuizQuestionDTO {
  static let mock = QuizQuestionDTO(
    id: "question-1",
    question: "대한민국의 수도는 어디인가요?",
    correctAnswer: "서울",
    options: ["서울", "부산", "대구", "인천"],
    category: .general,
    difficulty: .easy,
    mode: .multipleChoice,
    audioURL: nil,
    stageId: "general_stage_1",
    orderInStage: 1
  )
}

extension [QuizQuestionDTO] {
  static let mockList = [
    QuizQuestionDTO(
      id: "question-1",
      question: "대한민국의 수도는 어디인가요?",
      correctAnswer: "서울",
      options: ["서울", "부산", "대구", "인천"],
      category: .general,
      difficulty: .easy,
      mode: .multipleChoice,
      audioURL: nil,
      stageId: "general_stage_1",
      orderInStage: 1
    ),
    QuizQuestionDTO(
      id: "question-2",
      question: "세종대왕이 만든 문자는 무엇인가요?",
      correctAnswer: "한글",
      options: ["한글", "한자", "영어", "일본어"],
      category: .person,
      difficulty: .medium,
      mode: .multipleChoice,
      audioURL: nil,
      stageId: "person_stage_2",
      orderInStage: 3
    ),
    QuizQuestionDTO(
      id: "question-3",
      question: "BTS의 리더는 누구인가요?",
      correctAnswer: "RM",
      options: ["RM", "진", "슈가", "제이홉"],
      category: .music,
      difficulty: .easy,
      mode: .multipleChoice,
      audioURL: nil,
      stageId: "music_stage_1",
      orderInStage: 5
    )
  ]
}
