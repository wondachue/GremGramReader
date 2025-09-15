//
//  WordSheet.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//
import SwiftUI
import SafariServices

struct WordSheet: View {
    let word: String
    let languageCode: String?     

    @State private var safariURL: URL?
    @State private var showSafari = false
    @State private var showAppleDict = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(word).font(.title2).bold()

                HStack {
                    Button {
                        showAppleDict = true
                    } label: {
                        Text(Word.Lookup.dictionary)
                    }
                    Button {
                        showSafari = true
                    } label: {
                        Text(Word.Lookup.web)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        UIPasteboard.general.string = word
                    } label: {
                        Text(Word.copy)
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding()
            .navigationTitle(word)
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showSafari) {
            if let url = DictionaryLookupService.target(for: word, langCode: languageCode) {
                SafariView(url: url)
            } else {
                Text(Word.Lookup.error)
            }
        }
        .sheet(isPresented: $showAppleDict) {
            AppleDictionaryView(term: word)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

