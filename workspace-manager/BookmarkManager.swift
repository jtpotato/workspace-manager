import Foundation

class BookmarkManager {
  private let bookmarksKey = "bookmarks"
  private var resolvedCache: [String: URL] = [:]

  // Save a bookmark for a given URL
  func saveBookmark(for url: URL) {
    do {
      print("Saving bookmark for URL: \(url.absoluteString)")
      let bookmarkData = try url.bookmarkData(
        options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
      var bookmarks = loadBookmarks()
      bookmarks[url.absoluteString] = bookmarkData
      print("Updated bookmarks: \(bookmarks)")
      UserDefaults.standard.set(bookmarks, forKey: bookmarksKey)
    } catch {
      print("Failed to create bookmark: \(error.localizedDescription)")
    }
  }

  // Load all saved bookmarks
  func loadBookmarks() -> [String: Data] {
    let bookmarks = UserDefaults.standard.dictionary(forKey: bookmarksKey) as? [String: Data] ?? [:]
    print("Loaded bookmarks: \(bookmarks)")
    return bookmarks
  }

  // Resolve a bookmark to access the URL
  func resolveBookmark(for urlString: String) -> URL? {
    guard let bookmarkData = loadBookmarks()[urlString] else {
      print("No bookmark data found for URL: \(urlString)")
      return nil
    }
    do {
      var isStale = false
      let url = try URL(
        resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil,
        bookmarkDataIsStale: &isStale)
      if isStale {
        print("Bookmark is stale, recreating...")
        saveBookmark(for: url)
      }
      url.startAccessingSecurityScopedResource()
      print("Successfully resolved bookmark for URL: \(urlString)")
      return url
    } catch {
      print("Failed to resolve bookmark: \(error.localizedDescription)")
      return nil
    }
  }

  func resolveBookmark(for url: URL) -> URL? {
    return resolveBookmark(for: url.absoluteString)
  }

  // Stop accessing a security-scoped resource
  func stopAccessingBookmark(for url: URL) {
    url.stopAccessingSecurityScopedResource()
  }

  func accessFile(for urlString: String) -> URL? {
    if let cachedURL = resolvedCache[urlString] {
      return cachedURL
    }

    guard let bookmarkData = loadBookmarks()[urlString] else {
      print("No bookmark data found for URL: \(urlString)")
      return nil
    }

    do {
      var isStale = false
      let url = try URL(
        resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil,
        bookmarkDataIsStale: &isStale)
      if isStale {
        print("Bookmark is stale, recreating...")
        saveBookmark(for: url)
      }
      url.startAccessingSecurityScopedResource()
      resolvedCache[urlString] = url
      print("Successfully accessed file for URL: \(urlString)")
      return url
    } catch {
      print("Failed to access file: \(error.localizedDescription)")
      return nil
    }
  }

  func stopAccessingFile(for urlString: String) {
    if let cachedURL = resolvedCache[urlString] {
      cachedURL.stopAccessingSecurityScopedResource()
      resolvedCache.removeValue(forKey: urlString)
    }
  }
}
