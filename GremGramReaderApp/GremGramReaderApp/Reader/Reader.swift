//
//  Reader.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/15/25.
//

import Foundation

enum Reader {
    static func pageCount(_ currentPage: Int, totalPages: Int) -> LocalizedStringResource {
        return LocalizedStringResource(
            "reader.pageCount",
            defaultValue: "Page \(currentPage) of \(totalPages)",
            comment: "Page count format string"
        )
    }
    
    enum Accessibility {
        static let continueButton: LocalizedStringResource = .init(
            "reader.continueButton",
            defaultValue: "Continue to next page",
            comment: "Button prompt to continue to next page"
        )
        
        static let previousButton: LocalizedStringResource = .init(
            "reader.previousButton",
            defaultValue: "Go back to previous page",
            comment: "Button prompt to go back a page"
        )
    }
    
}
