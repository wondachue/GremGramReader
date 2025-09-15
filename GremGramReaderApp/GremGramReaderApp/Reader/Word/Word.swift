//
//  Word.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/15/25.
//

import Foundation

enum Word {
    static func title(with word: String) -> LocalizedStringResource {
        return LocalizedStringResource(
            "word.title",
            defaultValue: "Look up \(word)",
            comment: "Title to word lookup popup"
        )
    }
    
    static let copy: LocalizedStringResource = .init(
        "word.copy",
        defaultValue: "Copy",
        comment: "Button prompt to copy a word"
    )
    
    static let speak: LocalizedStringResource = .init(
        "word.speak",
        defaultValue: "Speak",
        comment: "Button prompt to listen to a word aloud"
    )
    
    enum Lookup {
        static let dictionary: LocalizedStringResource = .init(
            "word.lookup.dictionary",
            defaultValue: "Lookup with Dictionary",
            comment: "Button prompt to look up a word with the dictionary"
        )
        
        static let web: LocalizedStringResource = .init(
            "word.lookup.web",
            defaultValue: "Lookup with Safari",
            comment: "Button prompt to look up a word with the safari"
        )
        
        static let error: LocalizedStringResource = .init(
            "word.lookup.error",
            defaultValue: "Invalid URL",
            comment: "Error text if lookup fails"
        )
    }
    
    
}
