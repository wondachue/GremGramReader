//
//  LibraryView.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @State private var showImporter = false

    @State private var theme: Theme = .paper
    
    let columns = [GridItem(.adaptive(minimum: 140), spacing: 16)]

    var body: some View {
        NavigationStack {
            ScrollView {
                if books.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image("book", label: Text(Library.Accessibility.bookImage))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .opacity(0.6)

                        Text(Library.EmptyState.title)
                            .font(.title2.bold())
                            .foregroundStyle(theme.textColor)

                        Text(Library.EmptyState.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .foregroundStyle(theme.textColor.opacity(0.7))
                    }
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(books) { book in
                            NavigationLink {
                                ReaderView(book: book)
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    Image(systemName: "book.closed.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(theme.accent)

                                    Text(book.title)
                                        .font(.headline)
                                        .foregroundStyle(theme.textColor)
                                        .lineLimit(2)

                                    Text(Library.Book.pages(book.pages.count))
                                        .font(.caption)
                                        .foregroundStyle(theme.textColor)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(theme.pageFill)
                                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: deleteBooks)
                    }
                    .padding()
                }
            }
            .navigationTitle(Text(Library.title))
            .toolbar {
                if !books.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                ToolbarItem {
                    Button(action: addBook) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .accessibility(label: Text(Library.Accessibility.addBook))
                }
            }
            .toolbarBackground(theme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(theme == .night ? .dark : .light, for: .navigationBar)
            .tint(theme.accent)
        }
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [.plainText],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                BookStore.shared.importTXT(urls: urls) { books in
                    DispatchQueue.main.async {
                        for book in books {
                            modelContext.insert(book)
                        }
                    }
                }
            case .failure(let error):
                print("Importer error: \(error)")
            }
        }
    }

    private func addBook() {
        showImporter = true
    }

    private func deleteBooks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(books[index])
            }
        }
    }
}

#Preview {
    LibraryView()
        .modelContainer(for: Book.self, inMemory: true)
}
