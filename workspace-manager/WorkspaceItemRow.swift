import SwiftUI

struct WorkspaceItemRow: View {
  var itemPath: String
  var workspace: Workspace

  var body: some View {
    HStack {
      Image(systemName: iconName(for: itemPath))
        .frame(width: 48, height: 48)
        .font(.system(size: 24))
      Text(displayName(for: itemPath))
    }
    .contextMenu {
      Button(role: .destructive) {
        if let index = workspace.items.firstIndex(of: itemPath) {
          workspace.items.remove(at: index)
        }
      } label: {
        Label("Remove", systemImage: "trash")
          .foregroundColor(.red)
      }

      Button {
        openItem(itemPath)
      } label: {
        Label("Open", systemImage: "arrow.up.forward.square")
      }
    }
  }

  private func iconName(for path: String) -> String {
    if path.hasPrefix("http") || path.hasPrefix("https") {
      return "globe"
    } else if path.hasSuffix(".app") {
      return "app.square"
    } else if FileManager.default.fileExists(atPath: path) {
      if FileManager.default.isDirectory(atPath: path) {
        return "folder"
      } else {
        return "doc"
      }
    }
    return "questionmark.square"
  }

  private func displayName(for path: String) -> String {
    if path.hasPrefix("http") || path.hasPrefix("https"),
      let url = URL(string: path)
    {
      return url.host ?? path
    } else {
      return (path as NSString).lastPathComponent
    }
  }

  private func openItem(_ path: String) {
    if path.hasPrefix("http") || path.hasPrefix("https"),
      let url = URL(string: path)
    {
      NSWorkspace.shared.open(url)
    } else {
      let url = URL(fileURLWithPath: path)
      NSWorkspace.shared.open(url)
    }
  }
}
