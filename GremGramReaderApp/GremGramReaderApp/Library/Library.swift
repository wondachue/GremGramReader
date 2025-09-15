//
//  Library.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/15/25.
//

import Foundation

enum Library {    
    static let title: LocalizedStringResource = .init(
        "library.title",
        defaultValue: "Library",
        comment: "Navigation title for the library screen"
    )
    
    static let selectABook: LocalizedStringResource = .init(
        "library.selectABook",
        defaultValue: "Select a book",
        comment: "Instruction for selecting a book from the library"
    )
    
    enum Accessibility {
        static let bookImage: LocalizedStringResource = .init(
            "library.accessibility.bookImage",
            defaultValue: "Image of a magical book",
            comment: "A11y label for book image",
        )
        
        static let addBook: LocalizedStringResource = .init(
            "library.accessibility.addBook",
            defaultValue: "Add a book",
            comment: "Toolbar button to import a .txt file"
        )
    }
    
    enum EmptyState {
        static let title: LocalizedStringResource = .init(
            "library.empty.title",
            defaultValue: "No books yet",
            comment: "Empty state title when the library has no books"
        )
        static let subtitle: LocalizedStringResource = .init(
            "library.empty.subtitle",
            defaultValue: "Import a .txt file to start reading.",
            comment: "Empty state subtitle prompt"
        )
    }
    
    enum Book {
        static func pages(_ numPages: Int) -> LocalizedStringResource {
            return .init(
                "library.book.pages",
                defaultValue: "\(numPages) pages",
                comment: "Number of pages in the book"
            )
        }
    }
}
