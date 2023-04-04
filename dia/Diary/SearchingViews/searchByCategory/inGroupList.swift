//
//  categoryRow.swift
//  ДиаКомпаньон Beta
//
//  Created by Артём Исаков on 11.01.2023.
//

import SwiftUI

struct inGroupList: View {
    @Environment(\.isSearching) private var isSearching
    @EnvironmentObject var collection: foodCollections
    @State private var showPopover: Bool = false
    @State private var showSuccesNotify: Bool = false
    @State var category: String
    var body: some View {
        GeometryReader {geometry in
            ZStack {
                List {
                    Section {
                        ForEach($collection.listOfPinnedFoodInGroups, id: \.id) { $dish in
                            Button {
                                collection.selectedItem = dish
                                withAnimation {
                                    showPopover.toggle()
                                    showSuccesNotify = false
                                }
                            } label: {
                                listRow(food_name: dish.name, food_prot: dish.prot, food_fat: dish.fat, food_carbo: dish.carbo, food_kkal: dish.kkal, food_gi: dish.gi, width: geometry.size.width, index: $dish.index)
                            }
                            .tint(Color("listButtonColor"))
                            .swipeActions(edge: .trailing){
                                Button {
                                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                        withAnimation {
                                            collection.pinRowInGroups(item_id: dish.id, case_id: 3)
                                            collection.removeRowInGroups(item_id: dish.id, case_id: 3)
                                        }
                                    })
                                } label: {
                                    Label("", systemImage: "star.slash")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    Section {
                        ForEach($collection.listOfFoodInGroups, id: \.id) { $dish in
                            Button {
                                collection.selectedItem = dish
                                withAnimation {
                                    showPopover.toggle()
                                    showSuccesNotify = false
                                }
                            } label: {
                                listRow(food_name: dish.name, food_prot: dish.prot, food_fat: dish.fat, food_carbo: dish.carbo, food_kkal: dish.kkal, food_gi: dish.gi, width: geometry.size.width, index: $dish.index)
                            }
                            .tint(Color("listButtonColor"))
                            .swipeActions(edge: .trailing) {
                                Button {
                                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                        withAnimation {
                                            collection.pinRowInGroups(item_id: dish.id, case_id: 2)
                                            collection.removeRowInGroups(item_id: dish.id, case_id: 2)
                                        }
                                    })
                                } label: {
                                    Label("", systemImage: "star")
                                }
                                .tint(.blue)
                            }
                            .onAppear {
                                if collection.isSearching {
                                    collection.appendListInGroups(item_id: dish.id)
                                }
                            }
                        }
                    } header: {
                        listHeader().font(.body)
                    } footer: {
                        if collection.showListToolbar {
                            Text("База данных  - проприетарная собственность ФГБУ НМИЦ им. В.А. Алмазова").frame(minWidth: 0, maxWidth: .infinity).multilineTextAlignment(.center)
                        }
                    }
                }
                .listStyle(.grouped)
                .padding(.top, -35)
                VStack {
                    if showSuccesNotify {
                        VStack {
                            Spacer()
                            succesNotify()
                        }
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle(category)
            .sheet(isPresented: $showPopover, content: {addGramButton(gram: "100,0", editing: false, isShowingSheet: $showPopover, showSuccesNotify: $showSuccesNotify).dynamicTypeSize(.xLarge)})
            .onChange(of: isSearching, perform: {newValue in
                if !newValue {
                    Task {
                        await collection.assetList()
                    }
                }
            })
            .onChange(of: showSuccesNotify, perform: {newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                        withAnimation {
                            showSuccesNotify = false
                        }
                    })
                }
            })
            .task {
                collection.groupToSearch = category
                await collection.assetList()
            }
        }
    }
}

struct categoryList_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {g in
            inGroupList(category: "Алкогольные напитки")
                .environmentObject(foodCollections())
        }
    }
}
