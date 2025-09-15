//
//  ReaderView.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//

import SwiftUI
import SwiftData

struct ReaderView: View {
    @Bindable var book: Book
    @State private var selectedWord: String?
    @State private var showWordSheet = false
    @State private var pageIndex: Int = 0
    private var lastPage: Int {
        book.pages.count - 1
    }
    private var firstPage: Int {
        0
    }
    private var isRTL: Bool {
        book.readingDirection == .rightToLeft
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $pageIndex) {
                ForEach(Array(book.pages.enumerated()), id: \.offset) { idx, page in
                    SelectableTextView(
                        text: page,
                        onWordTap: { word in
                            selectedWord = word
                            showWordSheet = true
                        }
                    )
                    .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: isRTL ? nextPage : prevPage) {
                    Image(systemName: "chevron.left")
                }
                .disabled(isRTL ? pageIndex >= lastPage : pageIndex == firstPage)
                .accessibility(label: isRTL ? Text(Reader.Accessibility.continueButton) : Text(Reader.Accessibility.previousButton))
                Spacer()

                Text(Reader.pageCount(pageIndex, totalPages: book.pages.count))
                    .monospacedDigit()

                Spacer()

                Button(action: isRTL ? prevPage : nextPage) {
                    Image(systemName: "chevron.right")
                }
                .disabled(isRTL ? pageIndex == firstPage : pageIndex >= lastPage)
                .accessibility(label: isRTL ? Text(Reader.Accessibility.continueButton) : Text(Reader.Accessibility.previousButton))
            }
        }
        .padding()
        .sheet(isPresented: $showWordSheet) {
            WordSheet(word: selectedWord ?? "", languageCode: book.language)
        }
    }

    private func nextPage() {
        guard pageIndex < book.pages.count - 1 else { return }
        pageIndex += 1
    }

    private func prevPage() {
        guard pageIndex > 0 else { return }
        pageIndex -= 1
    }
}
