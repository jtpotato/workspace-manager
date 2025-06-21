import SwiftData

@Model
class Workspace {
  var name: String
  var items: [String]
  var emoji: String

  init(name: String, items: [String] = [], emoji: String = "") {
    self.name = name
    self.items = items
    self.emoji = emoji
  }
}
