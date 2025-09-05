import Foundation

struct QuizDataLoader {
  static func loadInitialQuizData() -> (stages: [CreateQuizStageRequest], questions: [CreateQuizQuestionRequest]) {
    guard let url = Bundle.main.url(forResource: "quiz_data", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
      print("Failed to load quiz_data.json")
      return (stages: [], questions: [])
    }

    do {
      let quizData = try JSONDecoder().decode(QuizDataResponse.self, from: data)

      let stages = quizData.stages.map { stage in
        CreateQuizStageRequest(
          id: stage.id,
          stageNumber: stage.stageNumber,
          category: QuizCategory(rawValue: stage.category) ?? .general,
          difficulty: QuizDifficulty(rawValue: stage.difficulty) ?? .easy,
          title: stage.title,
          requiredAccuracy: stage.requiredAccuracy,
          totalQuestions: stage.totalQuestions
        )
      }

      let questions = quizData.questions.map { question in
        CreateQuizQuestionRequest(
          id: question.id,
          question: question.question,
          correctAnswer: question.correctAnswer,
          category: QuizCategory(rawValue: question.category) ?? .general,
          difficulty: QuizDifficulty(rawValue: question.difficulty) ?? .easy,
          mode: QuizMode(rawValue: question.mode) ?? .multipleChoice,
          options: question.options,
          audioURL: question.audioURL,
          stageId: question.stageId,
          orderInStage: question.orderInStage
        )
      }
      print("stages", stages)
      print("questions", questions)
      return (stages: stages, questions: questions)
    } catch {
      print("Failed to decode quiz data: \(error)")
      return (stages: [], questions: [])
    }
  }
}

private struct QuizDataResponse: Codable {
  let datasetVersion: String
  let stages: [QuizStageResponse]
  let questions: [QuizQuestionResponse]
}

private struct QuizStageResponse: Codable, Identifiable {
  let id: String
  let stageNumber: Int
  let category: String
  let difficulty: String
  let title: String
  let requiredAccuracy: Double
  let totalQuestions: Int
}

private struct QuizQuestionResponse: Codable, Identifiable {
  let id: String
  let question: String
  let correctAnswer: String
  let options: [String]
  let category: String
  let difficulty: String
  let mode: String
  let audioURL: String?
  let stageId: String?
  let orderInStage: Int?
}
