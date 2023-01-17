import SwiftUI

enum Field: Hashable {
    case catSearch
    case inCatSearch
}

struct addFoodButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var foodItems: [foodToSave]
    @State public var addScreen: Bool = false
    @State public var selectedFoodTemp: String = ""
    @State public var selectedFoodTempRating: Int = 0
    @State public var selectedFoodCategoryTemp: String = ""
    @State public var gram: String = ""
    @State public var table_id: Int = 0
    @State private var selectedFood: String = ""
    @State private var selectedFoodCategoryItem: String = ""
    @State private var searchByWordView: Bool = true
    @State private var searchByWordCategoryView: Bool = true
    @State public var successedSave: Bool = false
    @StateObject private var items = Food()
    var body: some View {
        if #available(iOS 16, *){
            NavigationStack {
                ZStack {
                    VStack(spacing: .zero) {
                        VStack(spacing: .zero) {
                            Divider()
                            HStack {
                                TextField(text: $selectedFood, label: {Text("Поиск по слову")}).disableAutocorrection(true)
                                Image(systemName: "xmark").foregroundColor(Color(red: 0/255, green: 150/255, blue: 255/255))
                                    .onTapGesture {
                                        selectedFood = ""
                                    }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12.5)
                            Divider()
                        }
                        if searchByWordView {
                            ScrollView {
                                VStack(spacing: .zero) {
                                    ForEach(items.CatObj, id: \.id){dish in
                                        VStack(spacing: .zero) {
                                            NavigationLink(value: dish, label: {
                                                Text("\(dish.name)").frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).font(.system(size: 20)).multilineTextAlignment(.leading).foregroundColor(.black).padding(.horizontal).padding(.vertical, 12.5)
                                            })
                                            .buttonStyle(ButtonAndLink())
                                            Divider()
                                        }
                                    }
                                }
                            }
                            .ignoresSafeArea(.keyboard)
                            .navigationDestination(for: CategoryList.self, destination: {dish in
                                foodCategoryItemView(category: "\(dish.name)", foodItems: $foodItems)
                            })
                        } else {
                            ScrollView {
                                LazyVStack(spacing: .zero) {
                                    ForEach(items.FoodObj.sorted(by: {$0.rating > $1.rating}), id: \.id) {dish in
                                        VStack(spacing: .zero) {
                                            foodButton(dish: dish, selectedFoodTemp: $selectedFoodTemp, table_id: $table_id, addScreen: $addScreen, successedSave: $successedSave)
                                                .contextMenu {
                                                    VStack{
                                                        Button(action: {
                                                            items.handleRatingChange(i: items.FoodObj.firstIndex(where: {$0.id == dish.id})!, array_index: 1)
                                                            changeRating(_id: dish.table_id, _rating: dish.rating)
                                                            items.FoodID = UUID()
                                                        }, label: {
                                                            HStack {
                                                                Text(dish.rating == 0 ? "Добавить в избранное" : "Удалить из избранного").font(.system(size: 18.5))
                                                                Image(systemName: dish.rating == 0 ? "star" : "star.fill")
                                                            }
                                                        }).foregroundColor(Color.blue)
                                                        Button(role: .destructive, action: {
                                                            items.handleDeleting(i: items.FoodObj.firstIndex(where: {$0.id == dish.id})!, array_index: 1)
                                                            deleteFood(_id: dish.table_id)
                                                            items.FoodID = UUID()
                                                        }, label: {
                                                            HStack{
                                                                Text("Удалить из базы данных")
                                                                Image(systemName: "trash.fill")
                                                            }
                                                        })
                                                    }
                                                }
                                            Divider()
                                        }
                                    }
                                }
                            }
                            .id(items.FoodID)
                            .ignoresSafeArea(.keyboard)
                        }
                    }
                    if addScreen {
                        addSreenView(addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodTemp, table_id: $table_id, foodItems: $foodItems, successedSave: $successedSave)
                    }
                    if successedSave {
                        savedNotice()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Добавить блюдо")
                .interactiveDismissDisabled()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Закрыть")
                        }
                    })
                    ToolbarItemGroup(placement: .keyboard, content: {
                        Spacer()
                        Button(action: {
                            UIApplication.shared.dismissedKeyboard()
                        }, label: {
                            Text("Готово").foregroundColor(Color(red: 0/255, green: 150/255, blue: 255/255))
                        })
                    })
                }
                .task {
                    items.FillFoodCategoryList()
                }
                .onChange(of: selectedFood, perform: {selectedFood in
                    if !selectedFood.isEmpty {
                        searchByWordView = false
                        Task {
                            await items.GetFoodItemsByName(_name: selectedFood)
                        }
                    } else {
                        searchByWordView = true
                        items.FillFoodCategoryList()
                        Task {
                            items.FoodObj = []
                        }
                    }
                })
                .onChange(of: successedSave, perform: {save in
                    if save {
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                            successedSave = false
                        })
                    }
                })
                .onAppear(perform: {
                    successedSave = false
                    UIApplication.shared.dismissedKeyboard()
                })
            }
            .environmentObject(items)
        }
        else {
            NavigationView {
                ZStack {
                    VStack(spacing: .zero) {
                        VStack(spacing: .zero) {
                            Divider()
                            HStack {
                                TextField(text: $selectedFood, label: {Text("Поиск по слову")}).disableAutocorrection(true)
                                Image(systemName: "xmark").foregroundColor(Color(red: 0/255, green: 150/255, blue: 255/255))
                                    .onTapGesture {
                                        selectedFood = ""
                                    }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12.5)
                            Divider()
                        }
                        if searchByWordView {
                            ScrollView {
                                VStack(spacing: .zero) {
                                    ForEach(items.CatObj, id: \.id){dish in
                                        VStack(spacing: .zero) {
                                            NavigationLink{foodCategoryItemView(category: "\(dish.name)", foodItems: $foodItems)} label: {
                                                Text("\(dish.name)").frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).font(.system(size: 20)).multilineTextAlignment(.leading).foregroundColor(.black).padding(.horizontal).padding(.vertical, 12.5)
                                            }
                                            .buttonStyle(ButtonAndLink())
                                            Divider()
                                        }
                                    }
                                }
                            }
                            .ignoresSafeArea(.keyboard)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: .zero) {
                                    ForEach(items.FoodObj.sorted(by: {$0.rating > $1.rating}), id: \.id) {dish in
                                        VStack(spacing: .zero) {
                                            foodButton(dish: dish, selectedFoodTemp: $selectedFoodTemp, table_id: $table_id, addScreen: $addScreen, successedSave: $successedSave)
                                                .contextMenu {
                                                    VStack{
                                                        Button(action: {
                                                            items.handleRatingChange(i: items.FoodObj.firstIndex(where: {$0.id == dish.id})!, array_index: 1)
                                                            changeRating(_id: dish.table_id, _rating: dish.rating)
                                                            items.FoodID = UUID()
                                                        }, label: {
                                                            HStack {
                                                                Text(dish.rating == 0 ? "Добавить в избранное" : "Удалить из избранного").font(.system(size: 18.5))
                                                                Image(systemName: dish.rating == 0 ? "star" : "star.fill")
                                                            }
                                                        }).foregroundColor(Color.blue)
                                                        Button(role: .destructive, action: {
                                                            items.handleDeleting(i: items.FoodObj.firstIndex(where: {$0.id == dish.id})!, array_index: 1)
                                                            deleteFood(_id: dish.table_id)
                                                            items.FoodID = UUID()
                                                        }, label: {
                                                            HStack{
                                                                Text("Удалить из базы данных")
                                                                Image(systemName: "trash.fill")
                                                            }
                                                        })
                                                    }
                                                }
                                            Divider()
                                        }
                                    }
                                }
                            }
                            .id(items.FoodID)
                            .ignoresSafeArea(.keyboard)
                        }
                    }
                    if addScreen {
                        addSreenView(addScreen: $addScreen, gram: $gram, selectedFood: $selectedFoodTemp, table_id: $table_id, foodItems: $foodItems, successedSave: $successedSave)
                    }
                    if successedSave {
                        savedNotice()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Добавить блюдо")
                .interactiveDismissDisabled()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Закрыть")
                        }
                    })
                    ToolbarItemGroup(placement: .keyboard, content: {
                        Spacer()
                        Button(action: {
                            UIApplication.shared.dismissedKeyboard()
                        }, label: {
                            Text("Готово").foregroundColor(Color(red: 0/255, green: 150/255, blue: 255/255))
                        })
                    })
                }
                .task {
                    items.FillFoodCategoryList()
                }
                .onChange(of: selectedFood, perform: {selectedFood in
                    if !selectedFood.isEmpty {
                        searchByWordView = false
                        Task {
                            await items.GetFoodItemsByName(_name: selectedFood)
                        }
                    } else {
                        searchByWordView = true
                        items.FillFoodCategoryList()
                        Task {
                            items.FoodObj = []
                        }
                    }
                })
                .onChange(of: successedSave, perform: {save in
                    if save {
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
                            successedSave = false
                        })
                    }
                })
                .onAppear(perform: {
                    successedSave = false
                })
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(items)
        }
    }
}

