//
//  workspace_managerApp.swift
//  workspace-manager
//
//  Created by Joel Tan on 21/6/2025.
//

import SwiftData
import SwiftUI

@main
struct workspace_managerApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .modelContainer(for: Workspace.self)
    }
  }
}
