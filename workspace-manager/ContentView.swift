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
    NavigationStack {
      VStack {
        WorkspaceGridView(workspaces: workspaces)  // Pass the workspaces to WorkspaceGridView
        Spacer()
        DonationView()
      }
      .padding()
      .sheet(isPresented: $isAddingWorkspace) {
        NewWorkspaceView(isPresented: $isAddingWorkspace)
      }
      .navigationTitle("Workspace Manager")
      .toolbar {
        ToolbarItem(placement: .automatic) {
          Button(action: {
            isAddingWorkspace = true
          }) {
            Label("Add Workspace", systemImage: "plus")
          }
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
