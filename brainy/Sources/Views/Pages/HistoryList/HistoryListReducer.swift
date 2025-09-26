import ComposableArchitecture
import Foundation

@Reducer
struct HistoryListReducer {
  enum StatusFilter: String, CaseIterable, Equatable, Sendable {
    case all
    case correct
    case incorrect

    var displayName: String {
      switch self {
      case .all: return "전체"
      case .correct: return "정답"
      case .incorrect: return "오답"
      }
    }
  }

  @Dependency(\.quizClient) var quizClient

  @ObservableState
  struct State: Equatable {
    var results: [QuizStageResultDTO] = []
    var isLoading: Bool = false
    var errorMessage: String?

    var selectedCategory: QuizCategory? = nil
    var selectedStatus: StatusFilter = .all

    // 스테이지 ID -> 카테고리 매핑 (실제 스테이지 데이터 기반)
    var stageCategoryById: [String: QuizCategory] = [:]

    // MARK: - Filtering
    /// 카테고리 기준 필터링 (nil 이면 전체)
    /// 우선 스테이지 매핑을 사용하고, 없으면 stageId 접두사 파싱으로 폴백
    var filteredByCategory: [QuizStageResultDTO] {
      guard let selectedCategory else { return results }
      return results.filter { result in
        if let mapped = stageCategoryById[result.stageId] {
          return mapped == selectedCategory
        } else {
          // Fallback: stageId에서 카테고리 파싱 (ex. "history_stage_1")
          if let first = result.stageId.split(separator: "_").first,
             let parsed = QuizCategory(rawValue: String(first)) {
            return parsed == selectedCategory
          }
          return false
        }
      }
    }

    /// 정답 히스토리
    var correctResults: [QuizStageResultDTO] {
      filteredByCategory.filter { $0.isCleared }
    }

    /// 오답 히스토리
    var incorrectResults: [QuizStageResultDTO] {
      filteredByCategory.filter { !$0.isCleared }
    }

    /// 상태(전체/정답/오답)까지 반영된 최종 필터링 결과
    var filteredResults: [QuizStageResultDTO] {
      switch selectedStatus {
      case .all:
        return filteredByCategory
      case .correct:
        return correctResults
      case .incorrect:
        return incorrectResults
      }
    }

    var getCurrentUserID: String {
      // 실제 구현에서는 UserDefaults, Keychain 등에서 사용자 ID를 가져와야 함
      return UserDefaults.standard.string(forKey: "current_user_id") ?? "default_user"
    }
  }

  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case onAppear
    case refresh
    case stageCategoryMapLoaded([String: QuizCategory])
    case fetchResultsResponse(Result<[QuizStageResultDTO], Error>)
  }

  var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .onAppear, .refresh:
        state.isLoading = true
        state.errorMessage = nil
        return .merge(
          .run { [quizClient, userId = state.getCurrentUserID] send in
            do {
              let results = try await quizClient.fetchStageResults(userId)
              await send(.fetchResultsResponse(.success(results)))
            } catch {
              await send(.fetchResultsResponse(.failure(error)))
            }
          },
          .run { [quizClient] send in
            var map: [String: QuizCategory] = [:]
            for category in QuizCategory.allCases {
              do {
                let stages = try await quizClient.fetchStagesByCategory(category)
                for stage in stages {
                  map[stage.id] = stage.category
                }
              } catch {
                // 카테고리별 로드 실패는 무시하고 가능한 범위에서 매핑 구성
              }
            }
            await send(.stageCategoryMapLoaded(map))
          }
        )

      case let .stageCategoryMapLoaded(map):
        state.stageCategoryById = map
        return .none

      case let .fetchResultsResponse(.success(results)):
        state.isLoading = false
        state.results = results
        state.errorMessage = nil
        return .none

      case let .fetchResultsResponse(.failure(error)):
        state.isLoading = false
        state.errorMessage = error.localizedDescription
        return .none
      }
    }
  }
}
