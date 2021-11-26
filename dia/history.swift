//
//  history.swift
//  dia
//
//  Created by Артем  on 31.08.2021.
//

import SwiftUI

struct history: View {
    @State private var multiSelection = Set<UUID>()
    @StateObject var hList = historyList()
    var body: some View {
        List() {
            ForEach(hList.histList, id: \.id){
                Text("\($0.name)")
            }.onDelete(perform: removeRows)
             .onMove(perform: move)
        }
        .task {
            await hList.FillHistoryList()
        }
        .navigationTitle("История записей")
        .toolbar {
            EditButton()
                .environment(\.locale, Locale.init(identifier: "ru"))
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        hList.histList.move(fromOffsets: source, toOffset: destination)
        }
    func removeRows(at offsets: IndexSet){
        hList.histList.remove(atOffsets: offsets)
    }
}

struct history_Previews: PreviewProvider {
    static var previews: some View {
        history()
    }
}
