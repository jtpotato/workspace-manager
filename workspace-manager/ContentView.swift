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
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16)], spacing: 16) {
        ForEach(workspaces) { workspace in
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
          .background(Color.gray.opacity(0.2))
          .cornerRadius(8)
          .padding()
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

      Spacer()

      Link(destination: URL(string: "https://ko-fi.com/jtpotato")!) {
        VStack {
          Text(
            "This program is free to use but only possible through the support of users like you."
          )
          .foregroundColor(.primary)  // Use system default text color
          Text("If you find this useful, please consider donating by clicking here. 🩵")
            .foregroundColor(.primary)  // Use system default text color
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
        )
      }
      .padding(.bottom)
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

#Preview {
  ContentView()
}
