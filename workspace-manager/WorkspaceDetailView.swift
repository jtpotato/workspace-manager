import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct WorkspaceDetailView: View {
  @Environment(\.modelContext) private var modelContext
  var workspace: Workspace
  @State private var isTargeted = false

  private let bookmarkManager = BookmarkManager()

  var body: some View {
    VStack {
      List {
        ForEach(workspace.items, id: \.self) { itemPath in
          HStack {
            Image(systemName: iconName(for: itemPath))
            Text(displayName(for: itemPath))
          }
          .contextMenu {
            Button(role: .destructive) {
              // Remove item from workspace
              if let index = workspace.items.firstIndex(of: itemPath) {
                workspace.items.remove(at: index)
              }
            } label: {
              Label("Remove", systemImage: "trash")
                .foregroundColor(.red)  // Danger red text
            }

            Button {
              // Open file or URL
              openItem(itemPath)
            } label: {
              Label("Open", systemImage: "arrow.up.forward.square")
            }
          }
        }
      }

      HStack {
        Button(action: {
          if let clipboardContent = NSPasteboard.general.string(forType: .string),
            let url = URL(string: clipboardContent), url.scheme == "http" || url.scheme == "https"
          {
            if !workspace.items.contains(url.absoluteString) {
              workspace.items.append(url.absoluteString)
              print("Added URL from clipboard: \(url.absoluteString)")
            }
          } else {
            print("Invalid or no URL in clipboard")
          }
        }) {
          HStack {
            Image(systemName: "doc.on.clipboard")
              .foregroundColor(.white)
            Text("Add URL from Clipboard")
              .font(.headline)
              .foregroundColor(.white)
          }
          .padding()
          .background(Color.green)
          .cornerRadius(8)
        }
        .padding()
      }

      Button(action: {
        // Open all items in workspace
        for item in workspace.items {
          openItem(item)
        }
      }) {
        Text("Open All")
          .font(.headline)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(8)
      }
      .padding()
      .disabled(workspace.items.isEmpty)

      Spacer()
    }
    .navigationTitle(workspace.name)
    .padding()
    .onDrop(of: [UTType.fileURL.identifier, UTType.url.identifier], isTargeted: $isTargeted) {
      providers in
      handleDrop(providers: providers)
    }
    .background(isTargeted ? Color.blue.opacity(0.15) : Color.clear)
    .animation(.easeInOut(duration: 0.2), value: isTargeted)
  }

  private func handleDrop(providers: [NSItemProvider]) -> Bool {
    var didDrop = false

    for provider in providers {
      if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
        didDrop = true
        provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) {
          item, error in
          guard error == nil else {
            print("Error loading item: \(error!.localizedDescription)")
            return
          }

          guard let data = item as? Data,
            let url = URL(dataRepresentation: data, relativeTo: nil)
          else {
            print("Could not create URL from data")
            return
          }

          DispatchQueue.main.async {
            // Add file path to workspace items
            if !workspace.items.contains(url.path) {
              workspace.items.append(url.path)
              bookmarkManager.saveBookmark(for: url)  // Save bookmark
              print("Added file: \(url.path)")
            }
          }
        }
      } else if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
        didDrop = true
        provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { item, error in
          guard error == nil else {
            print("Error loading URL: \(error!.localizedDescription)")
            return
          }

          guard let data = item as? Data,
            let url = URL(dataRepresentation: data, relativeTo: nil)
          else {
            print("Could not create URL from data")
            return
          }

          DispatchQueue.main.async {
            // Add URL string to workspace items
            let urlString = url.absoluteString
            if !workspace.items.contains(urlString) {
              workspace.items.append(urlString)
              bookmarkManager.saveBookmark(for: url)  // Save bookmark
              print("Added link: \(urlString)")
            }
          }
        }
      }
    }
    return didDrop
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
      if let accessedURL = bookmarkManager.accessFile(for: url.absoluteString) {
        NSWorkspace.shared.open(accessedURL)
        bookmarkManager.stopAccessingFile(for: url.absoluteString)  // Stop accessing
      } else {
        print("Failed to access file for \(path)")
      }
    }
  }
}

extension FileManager {
  func isDirectory(atPath path: String) -> Bool {
    var isDir: ObjCBool = false
    return fileExists(atPath: path, isDirectory: &isDir) && isDir.boolValue
  }
}

#Preview {
  WorkspaceDetailView(workspace: Workspace(name: "Example Workspace", emoji: "📁"))
}
