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

        progress[category] = QuizCategorySelectionReducer.CategoryProgress(
          totalStages: stages.count,
          completedStages: stats.completedStages
        )
      } catch {
        print("Error loading progress for category \(category): \(error)")
        // 에러 발생 시 기본값 설정
        progress[category] = QuizCategorySelectionReducer.CategoryProgress(
          totalStages: 0,
          completedStages: 0
        )
      }
    }

    return progress
  }
}
