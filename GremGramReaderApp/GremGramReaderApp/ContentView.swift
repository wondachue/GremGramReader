//
//  ContentView.swift
//  GremGramReaderApp
//
//  Created by Megan Dwyer on 9/14/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @State private var showImporter = false
    
    var body: some View {
        NavigationSplitView {
            List {
                if books.isEmpty {
                    Text("No items yet. Click the + to upload.")
                } else {
                    ForEach(books) { book in
                        NavigationLink {
                            ReaderView(book: book)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(book.title).font(.headline)
                                Text("\(book.pages.count) pages")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteBooks)
                }
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addBook) {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a Book")
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
    ContentView()
        .modelContainer(for: Book.self, inMemory: true)
}
