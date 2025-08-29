import SwiftUI

extension TextQuizPage {
  struct LoadingView: View {
    var body: some View {
      VStack(spacing: 24) {
        ProgressView()
          .scaleEffect(1.5)
          .tint(.brainyPrimary)

        Text("퀴즈를 준비하고 있습니다...")
          .font(.brainyBodyLarge)
          .foregroundColor(.brainyTextSecondary)
      }
    }
  }

  struct ErrorView: View {
    let message: String
    let action: (Action) -> Void

    enum Action: Sendable, Equatable {
      case retry
      case back
    }

    var body: some View {
      VStack(spacing: 24) {
        Image(systemName: "exclamationmark.triangle")
          .font(.system(size: 48))
          .foregroundColor(.brainyError)

        Text("오류가 발생했습니다")
          .font(.brainyHeadlineMedium)
          .foregroundColor(.brainyText)

        Text(message)
          .font(.brainyBodyLarge)
          .foregroundColor(.brainyTextSecondary)
          .multilineTextAlignment(.center)
          .padding(.horizontal)

        VStack(spacing: 12) {
          BrainyButton("다시 시도", style: .primary) {
            action(.retry)
          }

          BrainyButton("뒤로 가기", style: .secondary) {
            action(.back)
          }
        }
        .padding(.horizontal)
      }
      .padding()
    }
  }

  struct EmptyView: View {
    let modeName: String
    let action: (Action) -> Void

    enum Action: Sendable, Equatable {
      case back
    }

    var body: some View {
      VStack(spacing: 24) {
        Image(systemName: "questionmark.circle")
          .font(.system(size: 48))
          .foregroundColor(.brainyTextSecondary)

        Text("문제가 없습니다")
          .font(.brainyHeadlineMedium)
          .foregroundColor(.brainyText)

        Text("해당 카테고리에 \(modeName) 문제가 없습니다.")
          .font(.brainyBodyLarge)
          .foregroundColor(.brainyTextSecondary)
          .multilineTextAlignment(.center)

        BrainyButton("뒤로 가기", style: .primary) {
          action(.back)
        }
        .padding(.horizontal)
      }
      .padding()
    }
  }
}

#Preview {
  ScrollView(.vertical, showsIndicators: false) {
    TextQuizPage.LoadingView()
    TextQuizPage.ErrorView(message: "message", action: { _ in })
    TextQuizPage.EmptyView(modeName: "modeName", action: { _ in })
  }
}
