import SwiftUI

extension Font {
  static let brainyDisplayLarge = Font.system(size: 32, weight: .bold, design: .rounded)
  static let brainyDisplayMedium = Font.system(size: 28, weight: .bold, design: .rounded)
  static let brainyDisplaySmall = Font.system(size: 24, weight: .semibold, design: .rounded)

  static let brainyHeadline = Font.system(size: 20, weight: .semibold, design: .default)
  static let brainyHeadlineLarge = Font.system(size: 22, weight: .semibold, design: .default)
  static let brainyHeadlineMedium = Font.system(size: 20, weight: .semibold, design: .default)
  static let brainyHeadlineSmall = Font.system(size: 18, weight: .medium, design: .default)

  static let brainyTitle = Font.system(size: 24, weight: .bold, design: .rounded)
  static let brainyTitleLarge = Font.system(size: 20, weight: .medium, design: .default)
  static let brainyTitleMedium = Font.system(size: 18, weight: .medium, design: .default)
  static let brainyTitleSmall = Font.system(size: 16, weight: .medium, design: .default)

  static let brainyBody = Font.system(size: 16, weight: .regular, design: .default)
  static let brainyBodyLarge = Font.system(size: 16, weight: .regular, design: .default)
  static let brainyBodyMedium = Font.system(size: 14, weight: .regular, design: .default)
  static let brainyBodySmall = Font.system(size: 12, weight: .regular, design: .default)

  static let brainyLabelLarge = Font.system(size: 14, weight: .medium, design: .default)
  static let brainyLabelMedium = Font.system(size: 12, weight: .medium, design: .default)
  static let brainyLabelSmall = Font.system(size: 10, weight: .medium, design: .default)

  static let brainyCaption = Font.system(size: 12, weight: .regular, design: .default)

  static let brainyButton = Font.system(size: 16, weight: .medium, design: .default)

  static let brainyQuizQuestion = Font.system(size: 18, weight: .medium, design: .default)
  static let brainyQuizAnswer = Font.system(size: 16, weight: .regular, design: .default)
  static let brainyQuizScore = Font.system(size: 24, weight: .bold, design: .rounded)
}

public struct BrainyTextStyle: Sendable {
  let font: Font
  let color: Color
  let lineSpacing: CGFloat

  static let displayLarge = BrainyTextStyle(
    font: .brainyDisplayLarge,
    color: Color("BrainyText"),
    lineSpacing: 4
  )

  static let headlineLarge = BrainyTextStyle(
    font: .brainyHeadlineLarge,
    color: Color("BrainyText"),
    lineSpacing: 2
  )

  static let bodyLarge = BrainyTextStyle(
    font: .brainyBodyLarge,
    color: Color("BrainyText"),
    lineSpacing: 1
  )

  static let labelMedium = BrainyTextStyle(
    font: .brainyLabelMedium,
    color: Color("BrainyTextSecondary"),
    lineSpacing: 0
  )
}

// MARK: - Text Modifier
struct BrainyTextModifier: ViewModifier {
  let style: BrainyTextStyle

  func body(content: Content) -> some View {
    content
      .font(style.font)
      .foregroundColor(style.color)
      .lineSpacing(style.lineSpacing)
  }
}

extension View {
  func brainyTextStyle(_ style: BrainyTextStyle) -> some View {
    modifier(BrainyTextModifier(style: style))
  }
}

#Preview {
  ScrollView(.vertical, showsIndicators: false) {
    Text("brainyDisplayLarge")
      .font(.brainyDisplayLarge)
    Text("brainyDisplayMedium")
      .font(.brainyDisplayMedium)
    Text("brainyDisplaySmall")
      .font(.brainyDisplaySmall)

    Divider()

    Text("brainyHeadline")
      .font(.brainyHeadline)
    Text("brainyHeadlineLarge")
      .font(.brainyHeadlineLarge)
    Text("brainyHeadlineMedium")
      .font(.brainyHeadlineMedium)
    Text("brainyHeadlineSmall")
      .font(.brainyHeadlineSmall)

    Divider()

    Text("brainyTitle")
      .font(.brainyTitle)
    Text("brainyTitleLarge")
      .font(.brainyTitleLarge)
    Text("brainyTitleMedium")
      .font(.brainyTitleMedium)
    Text("brainyTitleSmall")
      .font(.brainyTitleSmall)

    Divider()

    Text("brainyBody")
      .font(.brainyBody)
    Text("brainyBodyLarge")
      .font(.brainyBodyLarge)
    Text("brainyBodyMedium")
      .font(.brainyBodyMedium)
    Text("brainyBodySmall")
      .font(.brainyBodySmall)

    Divider()

    Text("brainyLabelLarge")
      .font(.brainyLabelLarge)
    Text("brainyLabelMedium")
      .font(.brainyLabelMedium)
    Text("brainyLabelSmall")
      .font(.brainyLabelSmall)

    Divider()

    Text("brainyButton")
      .font(.brainyButton)

    Divider()

    Text("brainyQuizQuestion")
      .font(.brainyQuizQuestion)
    Text("brainyQuizAnswer")
      .font(.brainyQuizAnswer)
    Text("brainyQuizScore")
      .font(.brainyQuizScore)

    Divider()

    Text("displayLarge")
      .brainyTextStyle(.displayLarge)
    Text("headlineLarge")
      .brainyTextStyle(.headlineLarge)
    Text("bodyLarge")
      .brainyTextStyle(.bodyLarge)
    Text("labelMedium")
      .brainyTextStyle(.labelMedium)
  }
}
