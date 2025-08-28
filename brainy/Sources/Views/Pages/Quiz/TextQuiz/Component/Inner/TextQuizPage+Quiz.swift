import SwiftUI

extension TextQuizPage {

  struct QuizContentView: View {
    let currentQuestionIndex: Int
    let totalCount: Int
    let timeRemaining: Int
    let progress: Float
    let modeName: String
    let categoryName: String
    let question: String
    let selectedOptionIndex: Int?
    let options: [String]
    let hasAnswered: Bool
    let isLastQuestion: Bool
    let action: (Action) -> Void

    enum Action: Equatable, Sendable {
      case back
      case option(Int)
      case submitAnswer
    }

    var body: some View {
      VStack(spacing: 0) {
        TextQuizPage.HeaderView(
          currentQuestionIndex: currentQuestionIndex,
          totalCount: totalCount,
          timeRemaining: timeRemaining,
          progress: progress,
          tapBack: { action(.back)  })

        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 24) {
            TextQuizPage.QuestionView(
              modeName: modeName,
              categoryName: categoryName,
              question: question)

            TextQuizPage.MultipleChoiceView(
              selectedOptionIndex: selectedOptionIndex,
              options: options,
              tapOption: { action(.option($0)) })
          }
          .padding(.horizontal, 24)
          .padding(.bottom, 100)
        }

        Spacer()

        TextQuizPage.BottomActionView(
          hasAnswered: hasAnswered,
          isLastQuestion: isLastQuestion,
          tapSubmitAnswer: { action(.submitAnswer) })
      }
    }
  }

  private struct QuestionView: View {
    let modeName: String
    let categoryName: String
    let question: String

    var body: some View {
      BrainyCard(style: .quiz, shadow: .medium) {
        VStack(alignment: .leading, spacing: 16) {
          HStack {
            Text(modeName)
              .font(.brainyLabelMedium)
              .foregroundColor(.brainyPrimary)
              .padding(.horizontal, 12)
              .padding(.vertical, 6)
              .background(Color.brainyPrimary.opacity(0.1))
              .cornerRadius(16)

            Spacer()

            Text(categoryName)
              .font(.brainyLabelMedium)
              .foregroundColor(.brainyTextSecondary)
          }

          Text(question)
            .font(.brainyHeadlineMedium)
            .foregroundColor(.brainyText)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
    }
  }

  private struct MultipleChoiceView: View {
    let selectedOptionIndex: Int?
    let options: [String]
    let tapOption: (Int) -> Void

    var body: some View {
      VStack(spacing: 12) {
        ForEach(Array(options.enumerated()), id: \.offset) { index, option in
          BrainyQuizCard(
            isSelected: selectedOptionIndex == index,
            onTap: { tapOption(index) }
          ) {
            HStack {
              // Option letter (A, B, C, D)
              Text(String(Character(UnicodeScalar(65 + index)!)))
                .font(.brainyBodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.brainyPrimary)
                .frame(width: 24, height: 24)
                .background(Color.brainyPrimary.opacity(0.1))
                .cornerRadius(12)

              Text(option)
                .font(.brainyBodyLarge)
                .foregroundColor(.brainyText)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

              Spacer()
            }
          }
        }
      }
    }
  }

  private struct HeaderView: View {
    let currentQuestionIndex: Int
    let totalCount: Int
    let timeRemaining: Int
    let progress: Float
    let tapBack: () -> Void

    private var timerColor: Color {
      return switch timeRemaining {
      case 0..<30: .brainyError
      case 30..<60: .brainyWarning
      default: .brainyTextSecondary
      }
    }

    private func formatTime(_ seconds: Int) -> String {
      let minutes = seconds / 60
      let remainingSeconds = seconds % 60
      return String(format: "%d:%02d", minutes, remainingSeconds)
    }

    var body: some View {
      VStack(spacing: 16) {
        HStack {
          Button(action: tapBack) {
            Image(systemName: "xmark")
              .font(.system(size: 18, weight: .medium))
              .foregroundColor(.brainyText)
          }

          Spacer()

          Text("\(currentQuestionIndex + 1) / \(totalCount)")
            .font(.brainyBodyMedium)
            .foregroundColor(.brainyTextSecondary)

          Spacer()

          HStack(spacing: 4) {
            Image(systemName: "clock")
              .font(.system(size: 14))
              .foregroundColor(timerColor)

            Text(formatTime(timeRemaining))
              .font(.brainyBodyMedium)
              .foregroundColor(timerColor)
          }
        }
        .padding(.horizontal, 24)

        ProgressView(value: progress)
          .tint(.brainyPrimary)
          .scaleEffect(y: 2)
          .padding(.horizontal, 24)
      }
      .padding(.top, 16)
      .padding(.bottom, 24)
      .background(Color.brainyBackground)
    }
  }

  private struct BottomActionView: View {
    let hasAnswered: Bool
    let isLastQuestion: Bool
    let tapSubmitAnswer: () -> Void

    var body: some View {
      VStack(spacing: 16) {
        Divider()
          .background(Color.brainyTextSecondary.opacity(0.2))

        HStack(spacing: 16) {
          BrainyButton(
            "건너뛰기",
            style: .ghost,
            size: .medium
          ) {
            tapSubmitAnswer()
          }

          BrainyButton(
            isLastQuestion ? "완료" : "다음",
            style: .primary,
            size: .medium,
            isEnabled: hasAnswered
          ) {
            tapSubmitAnswer()
          }
        }
        .padding(.horizontal, 24)
      }
      .padding(.bottom, 34)
      .background(Color.brainyBackground)
    }
  }
}


#Preview {
  TextQuizPage.QuizContentView(
    currentQuestionIndex: 1,
    totalCount: 4,
    timeRemaining: 20,
    progress: 0.2,
    modeName: "modeName",
    categoryName: "categoryName",
    question: "question",
    selectedOptionIndex: 2,
    options: ["options1", "options2", "options3", "options4",],
    hasAnswered: true,
    isLastQuestion: false,
    action: { _ in })
}
