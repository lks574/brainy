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
              action: { viewAction in
                switch viewAction {
                case .changeFilter(let questionFilter):
                  store.send(.changeFilter(questionFilter))
                }
              }
            )

            CategorySection(
              selectedCategory: store.selectedCategory,
              categoryProgress: store.categoryProgress,
              action: { viewAction in
                switch viewAction {
                case .changeCategory(let quizCategory):
                  store.send(.changeCategory(quizCategory))
                }
              }
            )
          }
          .padding(.horizontal, 24)
        }
        BottomSection(
          canStartQuiz: canStartQuiz,
          action: { viewAction in
            switch viewAction {
            case .quizPlay:
              store.send(.goToQuizPlay)
            case .back:
              store.send(.goToBack)
            }
          }
        )
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
