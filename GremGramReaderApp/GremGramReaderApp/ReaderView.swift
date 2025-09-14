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
    @State private var pageIndex: Int = 0
    private var isRTL: Bool {
        book.readingDirection == .rightToLeft
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let lang = Locale.current.localizedString(forLanguageCode: book.language) {
                Text("Language: \(lang)")
            }
            Spacer()
            TabView(selection: $pageIndex) {
                ForEach(Array(book.pages.enumerated()), id: \.offset) { idx, page in
                    ScrollView {
                        Text(page)
                            .font(.system(.body, design: .serif))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                    }
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
                .disabled(isRTL ? pageIndex >= book.pages.count - 1 : pageIndex == 0)

                Spacer()

                Text("\(pageIndex + 1) / \(book.pages.count)")
                    .monospacedDigit()

                Spacer()

                Button(action: isRTL ? prevPage : nextPage) {
                    Image(systemName: "chevron.right")
                }
                .disabled(isRTL ? pageIndex == 0 : pageIndex >= book.pages.count - 1)
            }
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
