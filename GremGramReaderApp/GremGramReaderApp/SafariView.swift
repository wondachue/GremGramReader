//
//  SafariView.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//


import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // no-op
    }
}
