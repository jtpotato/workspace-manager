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

      EmojiPickerView(selectedEmoji: $selectedEmoji)

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
}

#Preview {
  NewWorkspaceView(isPresented: .constant(true))
}
