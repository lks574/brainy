import Foundation
import ComposableArchitecture

struct QuizCategorySelectionSideEffect: Equatable, Sendable {

  func loadCategoryProgressData(userId: String, quizClient: QuizClient) async -> [QuizCategory: QuizCategorySelectionReducer.CategoryProgress] {
    var progress: [QuizCategory: QuizCategorySelectionReducer.CategoryProgress] = [:]

    for category in QuizCategory.allCases {
      do {
        // QuizClient를 통해 카테고리별 통계 가져오기
        let stats = try await quizClient.getCategoryStageStats(userId, category)
        let stages = try await quizClient.fetchStagesByCategory(category)
        var stageID: String? {
          guard
            stats.completedStages + 1 != stages.count,
            stages.count != 0
          else {
            return nil
          }
          return stages[stats.completedStages].id
        }

        progress[category] = QuizCategorySelectionReducer.CategoryProgress(
          stageID: stageID,
          totalStages: stages.count,
          completedStages: stats.completedStages
        )
      } catch {
        print("Error loading progress for category \(category): \(error)")
      }
    }

    return progress
  }
}
