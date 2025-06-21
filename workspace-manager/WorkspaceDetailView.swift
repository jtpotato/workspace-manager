import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct WorkspaceDetailView: View {
  @Environment(\.modelContext) private var modelContext
  var workspace: Workspace
  @State private var isTargeted = false

  var body: some View {
    VStack {
      workspaceItemsList
      addUrlButton
      openAllButton
      Spacer()
    }
    .navigationTitle("\(workspace.emoji) \(workspace.name)")
    .padding()
    .onDrop(of: [UTType.fileURL.identifier, UTType.url.identifier], isTargeted: $isTargeted) {
      providers in
      handleDrop(providers: providers)
    }
    .background(isTargeted ? Color.blue.opacity(0.15) : Color.clear)
    .animation(.easeInOut(duration: 0.2), value: isTargeted)
  }

  private var workspaceItemsList: some View {
    List {
      ForEach(workspace.items, id: \.self) { itemPath in
        WorkspaceItemRow(itemPath: itemPath, workspace: workspace)
      }
    }
    .scrollContentBackground(.hidden)
    .background(Color.clear)
  }

  private var addUrlButton: some View {
    HStack {
      Button(action: addUrlFromClipboard) {
        HStack {
          Image(systemName: "doc.on.clipboard")
          Text("Add URL from Clipboard")
        }
      }
    }
  }

  private var openAllButton: some View {
    Button(action: openAllItems) {
      Text("Open All")
        .font(.headline)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    .buttonStyle(PlainButtonStyle())
    .disabled(workspace.items.isEmpty)
  }

  private func addUrlFromClipboard() {
    if let clipboardContent = NSPasteboard.general.string(forType: .string),
      let url = URL(string: clipboardContent), url.scheme == "http" || url.scheme == "https"
    {
      if !workspace.items.contains(url.absoluteString) {
        workspace.items.append(url.absoluteString)
        print("Added URL from clipboard: \(url.absoluteString)")
      }
    } else {
      print("Invalid or unsupported URL in clipboard")
    }
  }

  private func openAllItems() {
    for item in workspace.items {
      openItem(item)
    }
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
            if !workspace.items.contains(url.path) {
              workspace.items.append(url.path)
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
            let urlString = url.absoluteString
            if !workspace.items.contains(urlString) {
              workspace.items.append(urlString)
              print("Added link: \(urlString)")
            }
          }
        }
      }
    }
    return didDrop
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

#Preview {
  WorkspaceDetailView(workspace: Workspace(name: "Example Workspace", emoji: "📁"))
}
