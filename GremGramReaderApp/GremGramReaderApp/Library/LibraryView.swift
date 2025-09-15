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
    
    var body: some View {
        NavigationSplitView {
            List {
                if books.isEmpty {
                    Image("book", label: Text(Library.Accessibility.bookImage))
                    Text(Library.EmptyState.title)
                        .font(.headline)
                    Text(Library.EmptyState.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(books) { book in
                        NavigationLink {
                            ReaderView(book: book)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(book.title).font(.headline)
                                Text(Library.Book.pages(book.pages.count))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteBooks)
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
                        Image(systemName: "plus")
                    }.accessibility(label: Text(Library.Accessibility.addBook))
                }
            }
        } detail: {
            Text(Library.selectABook)
        }.fileImporter(
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
