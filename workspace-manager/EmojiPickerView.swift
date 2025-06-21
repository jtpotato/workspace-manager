import SwiftUI

struct EmojiPickerView: View {
  let emojis: [String] = [
    "✨", "🔥", "🌟", "💻", "📚", "🎨", "🚀", "🛠️", "📂", "📝", "🎉", "📖", "🖌️", "🧩", "🎯", "📅", "🧑‍💻", "🛡️", "🔧",
    "💡",
    "😀", "😎", "🤔", "🥳", "😇", "🤩", "😢", "😡", "😂", "😍",
  ]
  @Binding var selectedEmoji: String

  var body: some View {
    VStack {
      Text(selectedEmoji)
        .font(.largeTitle)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 5) {
          ForEach(emojis, id: \.self) { emoji in
            Text(emoji)
              .font(.title)
              .onTapGesture {
                selectedEmoji = emoji
              }
          }
        }
      }
      .padding()
    }
  }
}
