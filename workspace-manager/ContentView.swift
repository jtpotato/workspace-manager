//
//  ContentView.swift
//  workspace-manager
//
//  Created by Joel Tan on 21/6/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var workspaces: [Workspace]

  @State private var isAddingWorkspace: Bool = false

  var body: some View {
    VStack {
      Text("Workspace Manager")
        .font(.largeTitle)
        .padding()

      Button("Add New Workspace") {
        isAddingWorkspace = true
      }
      .buttonStyle(.borderedProminent)
      .padding()

      LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16)], spacing: 16) {
        ForEach(workspaces) { workspace in
          VStack {
            Text(workspace.emoji)
              .font(.largeTitle)
            Text(workspace.name)
          }
          .frame(width: 120, height: 120)
          .padding()
          .background(Color.gray.opacity(0.2))
          .cornerRadius(8)
          .contextMenu {
            Button(role: .destructive) {
              modelContext.delete(workspace)
            } label: {
              Label("Delete", systemImage: "trash")
            }
          }
        }
      }
      .padding()
    }
    .padding()
    .sheet(isPresented: $isAddingWorkspace) {
      NewWorkspaceView(isPresented: $isAddingWorkspace)
    }
  }
}

#Preview {
  ContentView()
}
