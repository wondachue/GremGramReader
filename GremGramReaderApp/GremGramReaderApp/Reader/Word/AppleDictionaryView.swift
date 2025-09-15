//
//  AppleDictionaryView.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//


import SwiftUI
import UIKit

struct AppleDictionaryView: UIViewControllerRepresentable {
    let term: String

    func makeUIViewController(context: Context) -> UIReferenceLibraryViewController {
        UIReferenceLibraryViewController(term: term)
    }
    func updateUIViewController(_ uiViewController: UIReferenceLibraryViewController, context: Context) {}
}
