enum QueryItem {
  struct TextQuiz: Sendable, Equatable {
    let quizMode: QuizMode
    let quizCategory: QuizCategory
    let stageID: String
  }
}
