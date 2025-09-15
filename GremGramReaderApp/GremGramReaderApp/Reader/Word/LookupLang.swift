//
//  LookupLang.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//


import Foundation
import UIKit

enum LookupLang: String {
    case ja, ga, und, fr
}

struct DictionaryLookupService {
    static func target(for word: String, langCode: String?) -> URL? {
        let code = LookupLang(rawValue: (langCode ?? "").lowercased()) ?? .und
        let q = word.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? word

        switch code {
        case .ja:
            return URL(string: "https://jisho.org/search/\(q)")
        case .fr:
            return  URL(string: "https://www.larousse.fr/dictionnaires/french-english/\(q)")
        case .ga:
            // Two popular options—pick your favorite:
            // Foclóir:
            if let url = URL(string: "https://www.focloir.ie/en/search/ei/?q=\(q)") {
                return url
            }
            // Teanglann fallback:
            return URL(string: "https://www.teanglann.ie/en/fgb/\(q)")
        case .und:
            return URL(string: "https://www.google.com/search?q=\(q)+definition")
        }
    }
}
