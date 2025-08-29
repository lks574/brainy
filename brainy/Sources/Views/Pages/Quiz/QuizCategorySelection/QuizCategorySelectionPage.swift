import ComposableArchitecture
import SwiftUI

enum QuizCategorySelectionPage {

  struct RootView: View {
    @Bindable var store: StoreOf<QuizCategorySelectionReducer>

    private var canStartQuiz: Bool {
      guard let selectedCategory = store.selectedCategory else { return false }

      if let progress = store.categoryProgress[selectedCategory] {
        return progress.totalStages > 0
      }

      return false
    }

    var body: some View {
      VStack(spacing: 24) {
        HeaderSection()

        ScrollView {
          VStack(spacing: 20) {
            FilterSection(
              selectedQuestionFilter: store.selectedQuestionFilter,
              action: { _ in })

            CategorySection(
              selectedCategory: store.selectedCategory,
              categoryProgress: store.categoryProgress,
              action: { _ in })
          }
          .padding(.horizontal, 24)
        }
        BottomSection(
          canStartQuiz: canStartQuiz,
          action: { _ in })
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.brainyBackground)
      .navigationBarHidden(true)
      .onAppear {
        store.send(.loadCategoryProgress)
      }
    }
  }
}

struct QuizCategorySelectionPage_Previews: PreviewProvider {

  static var previews: some View {
    QuizCategorySelectionPage.RootView(
      store: .init(
        initialState: QuizCategorySelectionReducer.State(
          quizMode: .multipleChoice),
        reducer: {
          QuizCategorySelectionReducer()
        }
      )
    )
  }
}
