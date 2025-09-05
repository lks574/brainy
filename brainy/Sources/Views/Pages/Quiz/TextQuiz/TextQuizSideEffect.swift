import Foundation
import ComposableArchitecture

struct TextQuizSideEffect: Equatable, Sendable {

  func getUserAnswer(selectedIndex: Int?, shortAnswer: String, question: QuizQuestionDTO?) -> String {
    guard let question = question else { return "" }

    switch question.mode {
    case .multipleChoice:
      guard let selectedIndex = selectedIndex,
            selectedIndex < question.options.count else { return "" }
      return question.options[selectedIndex]

    case .voice, .ai:
      return shortAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
    }
  }

  func checkAnswer(question: QuizQuestionDTO, selectedIndex: Int?, shortAnswer: String) -> Bool {
    switch question.mode {
    case .multipleChoice:
      guard let selectedIndex = selectedIndex,
            selectedIndex < question.options.count else { return false }
      return question.options[selectedIndex] == question.correctAnswer

    case .voice, .ai:
      let userAnswer = shortAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
      let correctAnswer = question.correctAnswer.lowercased()
      return userAnswer == correctAnswer
    }
  }
}
