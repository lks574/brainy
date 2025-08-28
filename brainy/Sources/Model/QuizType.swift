import Foundation

enum QuizMode: String, Codable, CaseIterable, Sendable {
  case multipleChoice = "multipleChoice"
  case voice
  case ai

  var displayName: String {
    return switch self {
    case .multipleChoice: "객관식"
    case .voice: "음성모드"
    case .ai: "AI모드"
    }
  }
}

enum QuizCategory: String, Codable, CaseIterable, Sendable {
  case general = "general"
  case country = "country"
  case drama = "drama"
  case history = "history"
  case person = "person"
  case music = "music"
  case food = "food"
  case sports = "sports"
  case movie = "movie"

  var displayName: String {
    return switch self {
    case .general: "일반상식"
    case .country: "국가"
    case .drama: "드라마"
    case .history: "역사"
    case .person: "인물"
    case .music: "음악"
    case .food: "음식"
    case .sports: "스포츠"
    case .movie: "영화"
    }
  }
}

enum QuizDifficulty: String, Codable, CaseIterable, Sendable {
  case easy = "easy"
  case medium = "medium"
  case hard = "hard"
  case all = "all"

  var displayName: String {
    return switch self {
    case .easy: "쉬움"
    case .medium: "보통"
    case .hard: "어려움"
    case .all: "전체"
    }
  }
}
