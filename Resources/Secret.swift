import Foundation

struct Secret: Decodable {
  private enum CodingKeys: String, CodingKey {
    case apiKey
  }
  let apiKey: String
}

extension Secret {
  static func loadFromPlist() -> Secret? {
    let decoder = PropertyListDecoder()
    guard
      let url = Bundle.main.url(forResource: "Secret", withExtension: "plist"),
      let data = try? Data(contentsOf: url),
      let secret = try? decoder.decode(Secret.self, from: data) else {
        return nil
    }
    return secret
  }
}
