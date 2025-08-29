import SwiftUI

extension QuizCategorySelectionPage {

  struct HeaderSection: View {
    var body: some View {
      VStack(spacing: 12) {
        Text("플레이 형식")
          .font(.brainyTitle)
          .foregroundColor(.brainyText)
      }
      .padding(.horizontal, 24)
      .padding(.top, 16)
    }
  }

  struct FilterSection: View {
    let selectedQuestionFilter: QuestionFilter
    let action: (Action) -> Void

    enum Action: Equatable, Sendable {
      case changeFilter(QuestionFilter)
    }

    var body: some View {
      VStack(alignment: .leading, spacing: 12) {
        VStack(spacing: 8) {
          FilterOption(
            title: "전체 무작위",
            description: "모든 문제에서 랜덤 선택",
            icon: "shuffle",
            filter: .random,
            isSelected: selectedQuestionFilter == .random
          ) {
            action(.changeFilter(.random))
          }

          FilterOption(
            title: "풀었던 것 제외",
            description: "이전에 풀지 않은 문제만",
            icon: "checkmark.circle.badge.xmark",
            filter: .excludeSolved,
            isSelected: selectedQuestionFilter == .excludeSolved
          ) {
            action(.changeFilter(.excludeSolved))
          }
        }
      }
    }
  }

  struct CategorySection: View {
    let selectedCategory: QuizCategory?
    let categoryProgress: [QuizCategory: QuizCategorySelectionReducer.CategoryProgress]

    let action: (Action) -> Void

    enum Action: Equatable, Sendable {
      case changeCategory(QuizCategory)
    }

    var body: some View {
      VStack(alignment: .leading, spacing: 12) {
        Text("카테고리")
          .font(.brainyHeadlineSmall)
          .foregroundColor(.brainyText)

        LazyVGrid(columns: [
          GridItem(.flexible()),
          GridItem(.flexible())
        ], spacing: 12) {
          ForEach(QuizCategory.allCases, id: \.self) { category in
            SelectionCategoryCard(
              category: category,
              isSelected: selectedCategory == category,
              progress: categoryProgress[category]
            ) {
              action(.changeCategory(category))
            }
          }
        }
      }
    }
  }

  struct BottomSection: View {
    let canStartQuiz: Bool
    let action: (Action) -> Void

    enum Action: Equatable, Sendable {
      case quizPlay
      case back
    }

    var body: some View {
      VStack(spacing: 16) {
        BrainyButton(
          "퀴즈 시작",
          style: .primary,
          size: .large,
          isEnabled: canStartQuiz
        ) {
          action(.quizPlay)
        }

        BrainyButton("뒤로 가기", style: .secondary, size: .medium) {
          action(.back)
        }
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 32)
    }
  }

}

extension QuizCategorySelectionPage {

  fileprivate struct FilterOption: View {
    let title: String
    let description: String
    let icon: String
    let filter: QuestionFilter
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
      Button(action: action) {
        HStack(spacing: 12) {
          Image(systemName: icon)
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(iconColor)
            .frame(width: 24, height: 24)

          VStack(alignment: .leading, spacing: 2) {
            Text(title)
              .font(.brainyBodyLarge)
              .foregroundColor(titleColor)
              .frame(maxWidth: .infinity, alignment: .leading)

            Text(description)
              .font(.brainyBodySmall)
              .foregroundColor(.brainyTextSecondary)
              .frame(maxWidth: .infinity, alignment: .leading)
          }

          Spacer()

          Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(checkmarkColor)
        }
        .padding(16)
        .background(backgroundColor)
        .cornerRadius(12)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(borderColor, lineWidth: borderWidth)
        )
      }
      .buttonStyle(PlainButtonStyle())
    }

    private var iconColor: Color {
      isSelected ? .brainyPrimary : .brainyTextSecondary
    }

    private var titleColor: Color {
      isSelected ? .brainyPrimary : .brainyText
    }

    private var backgroundColor: Color {
      isSelected ? Color.brainyPrimary.opacity(0.05) : .brainyCardBackground
    }

    private var borderColor: Color {
      isSelected ? .brainyPrimary : Color.brainySecondary.opacity(0.2)
    }

    private var borderWidth: CGFloat {
      isSelected ? 2.0 : 1.0
    }

    private var checkmarkColor: Color {
      isSelected ? .brainyPrimary : .brainyTextSecondary
    }
  }

  fileprivate struct SelectionCategoryCard: View {
    let category: QuizCategory
    let isSelected: Bool
    let progress: QuizCategorySelectionReducer.CategoryProgress?
    let action: () -> Void

    var body: some View {
      Button(action: isEnabled ? action : {}) {
        VStack(spacing: 8) {
          Text(categoryIcon)
            .font(.system(size: 28))

          Text(category.displayName)
            .font(.brainyBodyLarge)
            .foregroundColor(titleColor)
            .multilineTextAlignment(.center)

          if let progress = progress, progress.totalStages > 0 {
            VStack(spacing: 4) {
              HStack(spacing: 4) {
                Text("\(progress.completedStages)/\(progress.totalStages)")
                  .font(.brainyBodySmall)
                  .foregroundColor(progressTextColor)
                  .fontWeight(.medium)

                Text("스테이지")
                  .font(.brainyBodySmall)
                  .foregroundColor(.brainyTextSecondary)
              }

              GeometryReader { geometry in
                ZStack(alignment: .leading) {
                  Rectangle()
                    .fill(Color.brainySecondary.opacity(0.2))
                    .frame(height: 4)
                    .cornerRadius(2)

                  Rectangle()
                    .fill(progressBarColor)
                    .frame(width: geometry.size.width * progress.progressPercentage, height: 4)
                    .cornerRadius(2)
                    .animation(.easeInOut(duration: 0.3), value: progress.progressPercentage)
                }
              }
              .frame(height: 4)

              Text("\(Int(progress.progressPercentage * 100))% 완료")
                .font(.brainyCaption)
                .foregroundColor(progressTextColor)
            }
          } else {
            if let progress = progress, progress.totalStages == 0 {
              Text("준비 중")
                .font(.brainyBodySmall)
                .foregroundColor(.brainyTextSecondary)
                .multilineTextAlignment(.center)
            } else {
              Text(categoryDescription)
                .font(.brainyBodySmall)
                .foregroundColor(.brainyTextSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            }
          }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .padding(16)
        .background(backgroundColor)
        .cornerRadius(16)
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(borderColor, lineWidth: borderWidth)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .opacity(isEnabled ? 1.0 : 0.6)
      }
      .buttonStyle(PlainButtonStyle())
      .disabled(!isEnabled)
    }

    private var categoryIcon: String {
      return switch category {
      case .general: "🧩"
      case .country: "🌍"
      case .drama: "🎭"
      case .history: "📜"
      case .person: "👤"
      case .music: "🎵"
      case .food: "🍽️"
      case .sports: "⚽"
      case .movie: "🎬"
      }
    }

    private var categoryDescription: String {
      return switch category {
      case .general: "일반상식 퀴즈"
      case .country: "세계 각국에 대한 퀴즈"
      case .drama: "유명 드라마 퀴즈"
      case .history: "세계 역사에 대한 퀴즈"
      case .person: "유명 인물에 대한 퀴즈"
      case .music: "음악과 가수 퀴즈"
      case .food: "세계 모든 음식 퀴즈"
      case .sports: "모든 스포츠 퀴즈"
      case .movie: "유명 영화 퀴즈"
      }
    }

    private var isEnabled: Bool {
      if let progress = progress {
        return progress.totalStages > 0
      }
      return true
    }

    private var titleColor: Color {
      if !isEnabled {
        return .brainyTextSecondary
      }
      return isSelected ? .brainyPrimary : .brainyText
    }

    private var backgroundColor: Color {
      if !isEnabled {
        return .brainyCardBackground.opacity(0.5)
      }
      return isSelected ? Color.brainyPrimary.opacity(0.05) : .brainyCardBackground
    }

    private var borderColor: Color {
      isSelected ? .brainyPrimary : Color.brainySecondary.opacity(0.2)
    }

    private var borderWidth: CGFloat {
      isSelected ? 2.0 : 1.0
    }

    private var progressBarColor: Color {
      guard let progress = progress else { return .brainyPrimary }

      if progress.progressPercentage >= 1.0 {
        return .brainySuccess
      } else if progress.progressPercentage >= 0.5 {
        return .brainyPrimary
      } else {
        return .brainyAccent
      }
    }

    private var progressTextColor: Color {
      guard let progress = progress else { return .brainyTextSecondary }

      if progress.progressPercentage >= 1.0 {
        return .brainySuccess
      } else {
        return .brainyText
      }
    }
  }

}
