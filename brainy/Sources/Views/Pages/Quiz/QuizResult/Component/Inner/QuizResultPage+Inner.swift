import SwiftUI

extension QuizResultPage {

  struct HeaderView: View {
    let congratulationMessage: String
    let stageDisplayName: String
    let action: (Action) -> Void

    enum Action: Equatable, Sendable {
      case tapClose
    }

    var body: some View {
      VStack(spacing: 16) {
        HStack {
          Spacer()

          Button(action: {
            action(.tapClose)
          }) {
            Image(systemName: "xmark")
              .font(.system(size: 18, weight: .medium))
              .foregroundColor(.brainyTextSecondary)
          }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)

        VStack(spacing: 12) {
          Text(congratulationMessage)
            .font(.brainyTitleLarge)
            .foregroundColor(.brainyText)

          Text(stageDisplayName)
            .font(.brainyHeadlineMedium)
            .foregroundColor(.brainyTextSecondary)
        }
        .padding(.bottom, 8)
      }
    }
  }

  struct ResultCardView: View {
    let isCleared: Bool
    let stageResult: QuizStageResultDTO

    var body: some View {
      BrainyCard(style: .default, shadow: .medium) {
        VStack(spacing: 24) {
          VStack(spacing: 8) {
            Image(systemName: isCleared ? "checkmark.circle.fill" : "xmark.circle.fill")
              .font(.system(size: 48))
              .foregroundColor(isCleared ? .brainySuccess : .brainyError)

            Text(isCleared ? "클리어!" : "아쉬워요")
              .font(.brainyHeadlineMedium)
              .foregroundColor(isCleared ? .brainySuccess : .brainyError)
          }

          HStack(spacing: .zero) {
            Spacer()
            VStack(spacing: 8) {
              HStack(alignment: .bottom, spacing: 4) {
                Text("\(stageResult.score)")
                  .font(.system(size: 56, weight: .bold))
                  .foregroundColor(.brainyPrimary)

                Text("/ 10")
                  .font(.brainyTitleMedium)
                  .foregroundColor(.brainyTextSecondary)
                  .padding(.bottom, 8)
              }

              Text("정답")
                .font(.brainyBodyLarge)
                .foregroundColor(.brainyText)
            }
            Spacer()
            if stageResult.stars > 0 {
              VStack(spacing: 8) {
                Text(stageResult.starsDisplay)
                  .font(.brainyTitleMedium)

                Text("획득한 별")
                  .font(.brainyBodyMedium)
                  .foregroundColor(.brainyTextSecondary)
              }
              Spacer()
            }
          }
        }
        .frame(maxWidth: .infinity)
        .padding(32)
      }

    }
  }

  struct StatisticsView: View {
    let isCleared: Bool
    let stageResult: QuizStageResultDTO

    var body: some View {
      VStack(spacing: 16) {
        // Accuracy
        StatisticRowView(
          icon: "target",
          title: "정확도",
          value: stageResult.accuracyPercentage,
          color: accuracyColor(stageResult.accuracy)
        )

        StatisticRowView(
          icon: "clock",
          title: "소요 시간",
          value: formattedTime(stageResult.timeSpent),
          color: .brainyTextSecondary
        )

        StatisticRowView(
          icon: isCleared ? "checkmark.circle.fill" : "xmark.circle.fill",
          title: "클리어 여부",
          value: isCleared ? "성공" : "실패",
          color: isCleared ? .brainySuccess : .brainyError
        )
      }
    }
  }

  struct ActionButtonsView: View {
    let action: (Action) -> Void

    enum Action: Equatable, Sendable {
      case tapRetryStage
      case tapOtherQuiz
      case tapHistory
    }
    var body: some View {
      VStack(spacing: 12) {
        HStack(spacing: 12) {
          BrainyButton("다시 도전", style: .primary) {
            action(.tapRetryStage)
          }

          BrainyButton("다른 퀴즈", style: .secondary) {
            action(.tapOtherQuiz)
          }
        }
        BrainyButton("히스토리 보기", style: .ghost) {
          action(.tapHistory)
        }
      }
    }
  }
}

extension QuizResultPage {

  fileprivate struct StatisticRowView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
      BrainyCard(style: .default, shadow: .small) {
        HStack(spacing: 16) {
          Image(systemName: icon)
            .font(.system(size: 20))
            .foregroundColor(color)
            .frame(width: 24)

          Text(title)
            .font(.brainyBodyLarge)
            .foregroundColor(.brainyText)

          Spacer()

          Text(value)
            .font(.brainyBodyLarge)
            .fontWeight(.medium)
            .foregroundColor(color)
        }
        .padding(16)
      }
    }
  }

  fileprivate static func accuracyColor(_ accuracy: Double) -> Color {
    if accuracy >= 0.9 {
      return .brainySuccess
    } else if accuracy >= 0.7 {
      return .brainyWarning
    } else {
      return .brainyError
    }
  }

  fileprivate static func formattedTime(_ timeSpent: TimeInterval) -> String {
    let minutes = Int(timeSpent) / 60
    let seconds = Int(timeSpent) % 60
    return String(format: "%d:%02d", minutes, seconds)
  }
}
