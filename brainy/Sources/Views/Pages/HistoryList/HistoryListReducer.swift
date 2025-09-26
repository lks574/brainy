import ComposableArchitecture
import Foundation

@Reducer
struct HistoryListReducer {
  @ObservableState
  struct State: Equatable {
    var results: [QuizStageResultDTO] = []
    var isLoading: Bool = false
    var errorMessage: String?
  }

  enum Action: BindableAction, Sendable {
    case binding(BindingAction<State>)
    case onAppear
    case refresh
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
        return .run { send in
          // Simulate async load with mock data
          await send(.fetchResultsResponse(.success([QuizStageResultDTO].mockList)))
        }

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
