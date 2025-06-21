import AppKit
import SwiftData
import SwiftUI

struct NewWorkspaceView: View {
  @Environment(\.modelContext) private var modelContext
  @Binding var isPresented: Bool

  @State private var newWorkspaceName: String = ""
  @State private var selectedEmoji: String = "✨"

  var body: some View {
    VStack {
      Text("Add New Workspace")
        .font(.title)
        .padding()

      TextField("Workspace Name", text: $newWorkspaceName)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .onChange(of: newWorkspaceName) {
          extractEmojiFromName()
        }

      Text(selectedEmoji)
        .font(.largeTitle)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .onTapGesture {
          NSApplication.shared.orderFrontCharacterPalette(nil)
        }

      Button("Save") {
        let newWorkspace = Workspace(name: newWorkspaceName, emoji: selectedEmoji)
        modelContext.insert(newWorkspace)
        isPresented = false
      }
      .buttonStyle(.borderedProminent)
      .padding()
    }
    .padding()
  }

  private func extractEmojiFromName() {
    print("Extracting emoji")
    if let emojiRange = newWorkspaceName.range(
      of:
        "[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1FA70}-\u{1FAFF}\u{1F1E6}-\u{1F1FF}]",
      options: .regularExpression)
    {
      selectedEmoji = String(newWorkspaceName[emojiRange])
      newWorkspaceName.removeSubrange(emojiRange)
    }
  }
}

#Preview {
  NewWorkspaceView(isPresented: .constant(true))
}
