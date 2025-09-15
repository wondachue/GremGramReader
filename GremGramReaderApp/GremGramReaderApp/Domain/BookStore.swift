//
//  BookStore.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//


import Foundation
import UniformTypeIdentifiers

final class BookStore {
    static let shared = BookStore()
    private init() {}

    func importTXT(urls: [URL], completion: @escaping ([Book]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var imported: [Book] = []

            for url in urls {
                var accessed = false
                if url.startAccessingSecurityScopedResource() { accessed = true }
                defer { if accessed { url.stopAccessingSecurityScopedResource() } }

                do {
                    let data = try Data(contentsOf: url)

                    guard let text = Self.decodeText(data) else {
                        print("Import: unreadable text for \(url.lastPathComponent)")
                        continue
                    }

                    let lang = LangDetect.dominantCode(for: text) // e.g., "en", "ja", "ga", "und"
                    let title = url.deletingPathExtension().lastPathComponent

                    let book = Book(timestamp: Date(), title: title, text: text, language: lang)

                    imported.append(book)
                } catch {
                    print("Import failed for \(url.lastPathComponent): \(error)")
                }
            }

            completion(imported)
        }
    }

    // MARK: - Helpers

    private static func decodeText(_ data: Data) -> String? {
        // Use encodings that exist in Foundation on Apple platforms (avoid custom CFString extensions).
        let encodings: [String.Encoding] = [
            .utf8,
            .utf16, .utf16LittleEndian, .utf16BigEndian,
            .utf32,
            .shiftJIS,       // common for Japanese txt
            .iso2022JP,      // also common for Japanese mail/news
            .japaneseEUC,    // EUC-JP
            .windowsCP1252,  // western fallback
            .isoLatin1,
            .macOSRoman
        ]

        for enc in encodings {
            if let s = String(data: data, encoding: enc) {
                return s
            }
        }
        return nil
    }

    static func paginate(text: String, targetChars: Int) -> [String] {
        guard targetChars > 0 else { return [text] }

        var pages: [String] = []
        var current = ""
        current.reserveCapacity(targetChars + 128)

        // Try to keep paragraph boundaries when possible
        let lines = text.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)

        for rawLine in lines {
            // Preserve original line breaks
            let line = String(rawLine) + "\n"

            if current.count + line.count > targetChars, !current.isEmpty {
                pages.append(current.trimmingCharacters(in: .whitespacesAndNewlines))
                current.removeAll(keepingCapacity: true)
            }

            if line.count >= targetChars {
                // Split very long lines into chunks
                var idx = line.startIndex
                while idx < line.endIndex {
                    let next = line.index(idx, offsetBy: min(targetChars, line.distance(from: idx, to: line.endIndex)), limitedBy: line.endIndex) ?? line.endIndex
                    pages.append(String(line[idx..<next]))
                    idx = next
                }
            } else {
                current.append(line)
            }
        }

        if !current.isEmpty {
            pages.append(current.trimmingCharacters(in: .whitespacesAndNewlines))
        }

        return pages.isEmpty ? [text] : pages
    }
}


