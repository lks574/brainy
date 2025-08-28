import ComposableArchitecture
import SwiftUI

enum TextQuizPage {
  struct RootView: View {
    var store: StoreOf<TextQuizReducer>

    var body: some View {
      ZStack {
        Color.brainyBackground
          .ignoresSafeArea()

        if store.isLoading {
          TextQuizPage.LoadingView()
        } else if let errorMessage = store.errorMessage {
          TextQuizPage.ErrorView(
            message: errorMessage,
            action: { viewAction in
              switch viewAction {
              case .back:
                store.send(.goToBack)
              case .retry:
                store.send(.tapRetry)
              }
            })
        } else if store.quizQuestions.isEmpty {
          TextQuizPage.EmptyView(
            modeName: store.quizMode.displayName,
            action: { viewAction in
              switch viewAction {
              case .back:
                store.send(.goToBack)
              }
            })
        } else {
          TextQuizPage.QuizContentView(
            currentQuestionIndex: store.currentQuestionIndex,
            totalCount: store.quizQuestions.count,
            timeRemaining: store.timeRemaining,
            progress: store.progress,
            modeName: store.quizMode.displayName,
            categoryName: store.quizCategory.displayName,
            question: store.currentQuestion?.question ?? "",
            selectedOptionIndex: store.selectedOptionIndex,
            options: store.currentQuestion?.options ?? [],
            hasAnswered: store.hasAnswered,
            isLastQuestion: store.isLastQuestion,
            action: { viewAction in
              switch viewAction {
              case .back:
                store.send(.goToBack)
              case .option(let index):
                store.send(.tapOption(index))
              case .submitAnswer:
                store.send(.tapSubmitAnswer)
              }
            })
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.brainyBackground)
      .navigationBarHidden(true)
      .task {
        store.send(.startStage)
      }
    }
  }
}

