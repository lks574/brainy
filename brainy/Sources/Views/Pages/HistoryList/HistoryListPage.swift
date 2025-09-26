import SwiftUI
import ComposableArchitecture

enum HistoryListPage {
  struct RootView: View {
    @Bindable var store: StoreOf<HistoryListReducer>

    var body: some View {
      VStack {
        if store.isLoading {
          ProgressView()
            .progressViewStyle(.circular)
        } else if store.results.isEmpty {
          Text("히스토리 데이터가 없습니다.")
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding()
        } else {
          List(store.results) { result in
            VStack(alignment: .leading, spacing: 6) {
              Text(stageDisplayName(from: result.stageId))
                .font(.headline)

              HStack(spacing: 12) {
                Text("점수: \(result.score)")
                Text("정확도: \(result.accuracyPercentage)")
                if !result.starsDisplay.isEmpty { Text("별: \(result.starsDisplay)") }
              }
              .font(.subheadline)
              .foregroundColor(.secondary)

              Text(Self.dateFormatter.string(from: result.completedAt))
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.vertical, 6)
          }
          .listStyle(.plain)
        }
      }
      .navigationTitle("히스토리")
      .onAppear { store.send(.onAppear) }
    }

    private func stageDisplayName(from stageId: String) -> String {
      let comps = stageId.split(separator: "_")
      if comps.count >= 3, let stageNum = comps.last {
        let category = QuizCategory(rawValue: String(comps[0]))?.displayName ?? "카테고리"
        return "\(category) \(stageNum)단계"
      }
      return stageId
    }

    private static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .short
      return formatter
    }()
  }
}
