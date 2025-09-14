//
//  Item.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//

import Foundation
import SwiftData

@Model
final class Book {
    var timestamp: Date
    var title: String
    var pages: [String] = []
    var language: String

    init(timestamp: Date, title: String, text: String, language: String) {
        self.timestamp = timestamp
        self.title = title
        self.pages = []
        self.language = language
    }
    
    var readingDirection: Locale.LanguageDirection {
        if ["ja", "zh", "ko"].contains(language) {
            return .rightToLeft
        }
        switch Locale.Language(identifier: language).lineLayoutDirection {
        case .rightToLeft:
            return .rightToLeft
        default:
            return .leftToRight
        }
    }
}
