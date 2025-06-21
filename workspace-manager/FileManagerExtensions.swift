import Foundation

extension FileManager {
  func isDirectory(atPath path: String) -> Bool {
    var isDir: ObjCBool = false
    return fileExists(atPath: path, isDirectory: &isDir) && isDir.boolValue
  }
}
