//
//  BookList.swift
//  FetchedResultsListEditModeIssue
//
//  Created by Gene Bogdanovich on 29.03.22.
//

import SwiftUI
import CoreData

// MARK: - GenreManager

struct GenreManager: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.index), SortDescriptor(\.name)],
        animation: .default
    ) private var genres: FetchedResults<Genre>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(genres) { genre in
                    HStack {
                        Text(genre.name ?? "")
                        Spacer()
                        Text("index: \(genre.index)")
                            .foregroundColor(.secondary)
                    }
                }
                .onMove(perform: moveGenres)
            }
            .navigationTitle("Genres")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        let genre = Genre(context: viewContext)
                        genre.name = genreNames.randomElement()!
                        do {
                            try viewContext.save()
                        } catch {
                            viewContext.rollback()
                        }
                    }, label: { Label("Add", systemImage: "plus") })
                }
            }
        }
    }
    
    // The function to move items in a list backed by Core Data
    // Reference: https://stackoverflow.com/questions/59742218/swiftui-reorder-coredata-objects-in-list
    private func moveGenres(from source: IndexSet, to destination: Int) {
        var revisedItems: [Genre] = genres.map { $0 }
        revisedItems.move(fromOffsets: source, toOffset: destination)
        for reverseIndex in stride(from: revisedItems.count - 1, through: 0, by: -1) {
            revisedItems[reverseIndex].index = Int64(reverseIndex)
        }
    }
}

// MARK: - BookList

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.index), SortDescriptor(\.name)],
        animation: .default
    ) private var genres: FetchedResults<Genre>
    
    @State private var filter: Genre?
    @State private var isPresentingGenreManager = false
    
    var body: some View {
        NavigationView {
            Text("BookList")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Genres") {
                            isPresentingGenreManager = true
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Picker("Filtering options", selection: $filter) {
#warning("This is the code that is causing the issue.")
                                ForEach(genres) { genre in
                                    let tag = genre as Genre?
                                    Text(genre.name ?? "").tag(tag)
                                }
                                
                            }
                        } label: {
                            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
                .sheet(isPresented: $isPresentingGenreManager, onDismiss: {
                    try? viewContext.save()
                }) {
                    GenreManager()
                }
        }
    }
}

// MARK: - BookList_Previews

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList()
    }
}

// MARK: - Sample book genre names

let genreNames = [
    "Classics",
    "Comic Book",
    "Graphic Novel",
    "Detective",
    "Mystery",
    "Fantasy",
    "Historical",
    "Fiction",
    "Horror",
    "Romance",
    "Sci-Fi",
    "Stories",
    "Suspense",
    "Thrillers",
    "Cookbooks",
    "Biographies",
    "Autobiographies",
    "Essays",
    "History",
    "Memoir",
    "Poetry",
    "Self-Help",
    "True Crime"
]
