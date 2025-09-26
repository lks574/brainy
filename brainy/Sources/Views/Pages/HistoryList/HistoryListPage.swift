import SwiftUI
import ComposableArchitecture

enum HistoryListPage {
  struct RootView: View {
    @Bindable var store: StoreOf<HistoryListReducer>

    var body: some View {
      VStack {
        // Filters
        VStack(spacing: 8) {
          // Category filter
          HStack {
            Text("카테고리")
              .font(.subheadline)
              .foregroundColor(.secondary)

            Spacer()

            Menu {
              Button("전체") { store.send(.binding(.set(\.selectedCategory, nil))) }
              ForEach(QuizCategory.allCases, id: \.self) { category in
                Button(category.displayName) { store.send(.binding(.set(\.selectedCategory, category))) }
              }
            } label: {
              HStack(spacing: 6) {
                Text(store.selectedCategory?.displayName ?? "전체")
                  .foregroundColor(.primary)
                Image(systemName: "chevron.up.chevron.down")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              .background(Color(.systemGray6))
              .cornerRadius(8)
            }
          }

          // Correct/Incorrect filter
          Picker("상태", selection: $store.selectedStatus) {
            Text("전체").tag(HistoryListReducer.StatusFilter.all)
            Text("정답").tag(HistoryListReducer.StatusFilter.correct)
            Text("오답").tag(HistoryListReducer.StatusFilter.incorrect)
          }
          .pickerStyle(.segmented)
        }
        .padding(.horizontal)
        .padding(.top, 8)

        if store.isLoading {
          ProgressView()
            .progressViewStyle(.circular)
        } else if store.results.isEmpty {
          Text("히스토리 데이터가 없습니다.")
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding()
        } else {
          // 필터링 결과 (리듀서 상태의 계산 프로퍼티 사용)
          let rowsCount: Int = {
            switch store.selectedStatus {
            case .all:
              return store.filteredByCategory.count
            case .correct:
              return store.correctResults.count
            case .incorrect:
              return store.incorrectResults.count
            }
          }()

          if rowsCount == 0 {
            VStack(spacing: 12) {
              Text("필터에 해당하는 히스토리가 없습니다.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
              Button("필터 초기화") {
                store.send(.binding(.set(\.selectedCategory, nil)))
                store.send(.binding(.set(\.selectedStatus, .all)))
              }

              Spacer()
            }
            .padding()
          } else {
            List {
              switch store.selectedStatus {
              case .all:
                if !store.correctResults.isEmpty {
                  Section(header: Text("정답")) {
                    ForEach(store.correctResults) { history in
                      HistoryRow(history: history)
                    }
                  }
                }
                if !store.incorrectResults.isEmpty {
                  Section(header: Text("오답")) {
                    ForEach(store.incorrectResults) { history in
                      HistoryRow(history: history)
                    }
                  }
                }
              case .correct:
                ForEach(store.correctResults) { history in
                  HistoryRow(history: history)
                }
              case .incorrect:
                ForEach(store.incorrectResults) { history in
                  HistoryRow(history: history)
                }
              }
            }
            .listStyle(.insetGrouped)
          }
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
  }
}

extension HistoryListPage {

  fileprivate struct HistoryRow: View {
    let history: QuizStageResultDTO

    var body: some View {
      VStack(alignment: .leading, spacing: 6) {
        Text(stageDisplayName(from: history.stageId))
          .font(.headline)

        HStack(spacing: 12) {
          Text("점수: \(history.score)")
          Text("정확도: \(history.accuracyPercentage)")
          if !history.starsDisplay.isEmpty { Text("별: \(history.starsDisplay)") }
        }
        .font(.subheadline)
        .foregroundColor(.secondary)

        Text(Self.dateFormatter.string(from: history.completedAt))
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding(.vertical, 6)
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
