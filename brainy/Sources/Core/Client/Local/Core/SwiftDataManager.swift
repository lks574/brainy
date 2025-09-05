import Combine
import Foundation
import SwiftData

final class SwiftDataManager: ObservableObject {
  static let shared = SwiftDataManager()

  private let modelContainer: ModelContainer
  let modelContext: ModelContext

  private init() {
    do {
      let schema = Schema([
        UserEntity.self,
        QuizQuestionEntity.self,
        QuizStageEntity.self,
        QuizStageResultEntity.self
      ])

      let modelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false
      )

      self.modelContainer = try ModelContainer(
        for: schema,
        configurations: [modelConfiguration]
      )

      self.modelContext = ModelContext(modelContainer)
    } catch {
      fatalError("Failed to initialize SwiftData: \(error)")
    }
  }

  func save() throws {
    try modelContext.save()
  }
}
