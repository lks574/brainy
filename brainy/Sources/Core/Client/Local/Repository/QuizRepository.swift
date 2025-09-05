import Foundation
import SwiftData

final class QuizRepository {
  private let dataManager: SwiftDataManager
  private var modelContext: ModelContext { dataManager.modelContext }

  init(dataManager: SwiftDataManager = .shared) {
    self.dataManager = dataManager
  }

  func loadInitialDataIfNeeded() throws {
    let stageDescriptor = FetchDescriptor<QuizStageEntity>()
    let existingStages = try modelContext.fetch(stageDescriptor)

    guard existingStages.isEmpty else {
      print("Quiz stages already exist, skipping initial data load")
      return
    }

    print("Loading initial quiz data...")
    let (stages, questions) = QuizDataLoader.loadInitialQuizData()

    try createStagesFromJSON(stages)
    try createQuestionsFromJSON(questions)

    try dataManager.save()
    print("Successfully loaded initial quiz data: \(stages.count) stages, \(questions.count) questions")
  }

  func deleteAllData() throws {
    let stageDescriptor = FetchDescriptor<QuizStageEntity>()
    let stages = try modelContext.fetch(stageDescriptor)
    stages.forEach { modelContext.delete($0) }

    let questionDescriptor = FetchDescriptor<QuizQuestionEntity>()
    let questions = try modelContext.fetch(questionDescriptor)
    questions.forEach { modelContext.delete($0) }

    let resultDescriptor = FetchDescriptor<QuizStageResultEntity>()
    let results = try modelContext.fetch(resultDescriptor)
    results.forEach { modelContext.delete($0) }

    try dataManager.save()
    print("모든 데이터 삭제 완료")
  }
}

// MARK: - Creat

extension QuizRepository {
  func createQuestion(_ req: CreateQuizQuestionRequest) throws -> QuizQuestionDTO {
    let question = QuizQuestionEntity(
      id: req.id.isEmpty ? UUID().uuidString : req.id,
      question: req.question,
      correctAnswer: req.correctAnswer,
      category: req.category,
      difficulty: req.difficulty,
      mode: req.mode,
      options: req.options,
      audioURL: req.audioURL,
      stageId: req.stageId,
      orderInStage: req.orderInStage
    )
    modelContext.insert(question)
    try dataManager.save()
    return QuizQuestionDTO(from: question)
  }
}

// MARK: - Get

extension QuizRepository {
  func getCategoryStageStats(userId: String, category: QuizCategory) throws -> (completedStages: Int, totalStars: Int, unlockedStage: Int) {
    // Get all stages for this category
    let stages = try fetchStagesByCategory(category)

    // Get user's results for this category
    let results = try fetchStageResults(userId: userId)
    let categoryResults = results.filter { result in
      stages.contains { $0.id == result.stageId }
    }

    let completedStages = categoryResults.filter { $0.isCleared }.count
    let totalStars = categoryResults.reduce(0) { $0 + $1.stars }
    let unlockedStage = completedStages + 1

    return (completedStages, totalStars, unlockedStage)
  }
}

// MARK: - Fetch

extension QuizRepository {
  func fetchStagesByCategory(_ category: QuizCategory) throws -> [QuizStageDTO] {
    let predicate = #Predicate<QuizStageEntity> { stage in
      stage.category == category.rawValue
    }
    let descriptor = FetchDescriptor<QuizStageEntity>(
      predicate: predicate,
      sortBy: [SortDescriptor(\.stageNumber)]
    )

    let stages = try modelContext.fetch(descriptor)
    return stages.map { QuizStageDTO(from: $0) }
  }
}

extension QuizRepository {
  private func createStagesFromJSON(_ stages: [CreateQuizStageRequest]) throws {
    for stageRequest in stages {
      let stage = QuizStageEntity(
        id: stageRequest.id,
        stageNumber: stageRequest.stageNumber,
        category: stageRequest.category,
        difficulty: stageRequest.difficulty,
        title: stageRequest.title
      )
      stage.requiredAccuracy = stageRequest.requiredAccuracy
      stage.totalQuestions = stageRequest.totalQuestions

      modelContext.insert(stage)
    }
  }

  private func createQuestionsFromJSON(_ questions: [CreateQuizQuestionRequest]) throws {
    for questionRequest in questions {
      let question = QuizQuestionEntity(
        id: questionRequest.id,
        question: questionRequest.question,
        correctAnswer: questionRequest.correctAnswer,
        category: questionRequest.category,
        difficulty: questionRequest.difficulty,
        mode: questionRequest.mode,
        options: questionRequest.options,
        audioURL: questionRequest.audioURL,
        stageId: questionRequest.stageId,
        orderInStage: questionRequest.orderInStage
      )
      modelContext.insert(question)
    }
  }

  private func fetchStageResults(userId: String? = nil, stageId: String? = nil, limit: Int? = nil) throws -> [QuizStageResultDTO] {
    var predicate: Predicate<QuizStageResultEntity>?

    if let userId = userId, let stageId = stageId {
      predicate = #Predicate<QuizStageResultEntity> { result in
        result.userId == userId && result.stageId == stageId
      }
    } else if let userId = userId {
      predicate = #Predicate<QuizStageResultEntity> { result in
        result.userId == userId
      }
    } else if let stageId = stageId {
      predicate = #Predicate<QuizStageResultEntity> { result in
        result.stageId == stageId
      }
    }

    var descriptor = FetchDescriptor<QuizStageResultEntity>(
      predicate: predicate,
      sortBy: [SortDescriptor(\.completedAt, order: .reverse)]
    )

    if let limit = limit {
      descriptor.fetchLimit = limit
    }

    let results = try modelContext.fetch(descriptor)
    return results.map { QuizStageResultDTO(from: $0) }
  }
}
