import SwiftUI

struct WorkspaceGridView: View {
  @Environment(\.modelContext) private var modelContext
  var workspaces: [Workspace]  // Changed from @Query to a regular property

  var body: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16)], spacing: 16) {
      ForEach(workspaces) { workspace in
        NavigationLink(destination: WorkspaceDetailView(workspace: workspace)) {
          VStack {
            Spacer()
            Text(workspace.emoji)
              .font(.system(size: 50))
            Spacer()
            Text(workspace.name)
              .font(.caption)
              .padding(.bottom, 8)
          }
          .frame(width: 120, height: 120)
          .cornerRadius(8)  // Removed custom background
        }
        .contextMenu {
          Button(role: .destructive) {
            modelContext.delete(workspace)
          } label: {
            Label {
              Text("Delete")
                .foregroundColor(.red)  // Display delete in red text
            } icon: {
              Image(systemName: "trash")
            }
          }
        }
      }
    }
    .padding()
  }
}

#Preview {
  WorkspaceGridView(workspaces: [])
}
