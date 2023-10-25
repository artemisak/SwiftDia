//
//  page3.swift
//  dia
//
//  Created by Артем  on 22.08.2021.
//

import SwiftUI

enum ftype: String, CaseIterable, Identifiable {
    case zavtrak = "Завтрак"
    case obed = "Обед"
    case uzin = "Ужин"
    case perekus = "Перекусы"
    var id: String { self.rawValue }
}

struct ftPicker: View {
    @Binding var ftpreviewIndex: ftype
    var body: some View {
        List {
            Picker(selection: $ftpreviewIndex, label: Text("Прием пищи").font(.caption)) {
                Text(LocalizedStringKey("Завтрак")).tag(ftype.zavtrak)
                Text(LocalizedStringKey("Обед")).tag(ftype.obed)
                Text(LocalizedStringKey("Ужин")).tag(ftype.uzin)
                Text(LocalizedStringKey("Перекусы")).tag(ftype.perekus)
            }.pickerStyle(.inline)
        }
    }
}

struct enterFood: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var routeManager: Router
    @EnvironmentObject var collection: foodCollections
    @State var enabled : Bool
    @State var sugar: String
    @State var date: Date
    @State var ftpreviewIndex: ftype
    @State var idForDelete: [Int]
    @State private var multiSelection = Set<UUID>()
    @State private var showEditView: Bool = false
    @State private var id0: Int = 0
    @State private var isEditing: Bool = false
    @State private var sugarlvl: LocalizedStringKey = "УГК не определен"
    @State private var isHidden: Bool = true
    @State private var isSheetShown: Bool = false
    @State private var scolor = Color("listButtonColor")
    @State private var recColor = Color.gray.opacity(0.2)
    @State private var fontColor = Color.black
    @State private var alertMessage: Bool = false
    @State private var permission: Bool = false
    @State private var correctness: Bool = false
    @State private var res: Double = 0.0
    @State private var errorMessage: String = ""
    @State private var isVisible: Bool = false
    @State private var isUnsavedChanges: Bool = false
    @State private var recCardID = UUID()
    @State private var recomendationCards = [recomendation]()
    @Binding var hasChanged: Bool
    var body: some View {
        List {
            if routeManager.version == 1 {
                Section {
                    Text(sugarlvl)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(fontColor)
                        .listRowBackground(recColor)
                    if isVisible {
                        VStack {
                            TabView(selection: $recCardID) {
                                ForEach(recomendationCards) { row in
                                    Text(row.text).font(.body).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).minimumScaleFactor(0.01)
                                }
                            }
                            .frame(height: 100)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            if recomendationCards.count > 1{
                                HStack(spacing: 2) {
                                    ForEach(recomendationCards) { row in
                                        Circle()
                                            .fill(row.id == recCardID ? Color.gray : Color.gray.opacity(0.5))
                                            .frame(width: 10, height: 10)
                                    }
                                }
                            }
                        }
                    }
                }.listRowSeparator(.hidden)
            }
            Section(header: Text("Общая информация").font(.caption)){
                NavigationLink(destination: ftPicker(ftpreviewIndex: $ftpreviewIndex), label: {
                    HStack {
                        Text("Прием пищи")
                        Spacer()
                        Text(LocalizedStringKey(ftpreviewIndex.rawValue))
                    }
                })
                VStack {
                    DatePicker(
                        "Дата",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
            if routeManager.version == 1 {
                Section(header: Text("Уровень глюкозы в крови").font(.caption)) {
                    Toggle(isOn: $enabled) {Text("Записать текущий УГК")}
                        .onChange(of: enabled){ _ in
                            if (!patientManager.provider.checkBMI() && enabled) {
                                alertMessage = true
                                enabled = false
                            }
                            sugar = ""
                            sugarlvl = "УГК не определен"
                        }
                        .alert(isPresented: $alertMessage) {
                            Alert(title: Text("Статус операции"), message: Text("Необходимо указать рост и вес \nдо беременности в карте пациента"), dismissButton: .default(Text("ОК")))
                        }
                    TextField("5,0 ммоль/л", text: $sugar)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .keyboardType(.decimalPad)
                        .disabled(enabled == false)
                        .foregroundColor(scolor)
                }
            }
            if collection.showFoodCollections {
                Section {
                    foodList(showEditView: $showEditView, id0: $id0)
                } header: {
                    Text("Список потребленных продуктов").font(.caption)
                } footer: {
                    Text("Смахните влево, чтобы удалить или отредактировать").font(.caption).frame(minWidth: 0, maxWidth: .infinity).multilineTextAlignment(.center)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Приемы пищи")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    if collection.whereToSave == .addedFoodItems {
                        saveInDB(workList: collection.addedFoodItems)
                        collection.addedFoodItems = []
                    } else {
                        saveInDB(workList: collection.editedFoodItems)
                        collection.editedFoodItems = []
                    }
                }) {
                    Text("Сохранить")
                }
                .alert(isPresented: $permission) {
                    Alert(title: Text("Статус операции"), message: Text(errorMessage), dismissButton: .default(Text("ОК")))
                }
            })
            ToolbarItemGroup(placement: .bottomBar, content: {
                Spacer()
                NavigationLink(destination: { enterPoint() }, label: {
                    Image(systemName: "square.and.pencil")
                }).foregroundColor(Color("AccentColor"))
            })
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button {
                    switch collection.whereToSave {
                    case .addedFoodItems:
                        if collection.addedFoodItems.isEmpty {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isUnsavedChanges = true
                        }
                    case .editingFoodItems:
                        if collection.editedFoodItems.isEmpty {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            isUnsavedChanges = true
                        }
                    default:
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    HStack {
                        Text(Image(systemName: "chevron.left")).font(.body).fontWeight(.semibold)
                        Text("Назад").font(.body)
                    }
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
        .sheet(isPresented: $showEditView, content: { addGramButton(gram: String(collection.selectedItem!.gram!).split(separator: ".").joined(separator: ","), editing: true, isShowingSheet: $showEditView, showSuccesNotify: .constant(false))})
        .alert("Несохраненные изменения", isPresented: $isUnsavedChanges, actions: {
            Button(role: .destructive, action: {
                switch collection.whereToSave {
                case .addedFoodItems:
                    collection.addedFoodItems = []
                case .editingFoodItems:
                    collection.editedFoodItems = []
                default:
                    break
                }
                presentationMode.wrappedValue.dismiss()
            }, label: {Text("Покинуть")})
        }, message: {Text("Вы внесли изменения, но не сохранили их. Если вы покините страницу - временные данные будут удалены.")})
        .onAppear {
            if idForDelete.isEmpty {
                collection.whereToSave = .addedFoodItems
            } else {
                collection.whereToSave = .editingFoodItems
            }
            if collection.whereToSave == .addedFoodItems {
                date = Date()
                updatePrediction(workList: collection.addedFoodItems)
            } else {
                updatePrediction(workList: collection.editedFoodItems)
            }
        }
        .onChange(of: collection.addedFoodItems, perform: { _ in
            updatePrediction(workList: collection.addedFoodItems)
        })
        .onChange(of: collection.editedFoodItems, perform: { _ in
            updatePrediction(workList: collection.editedFoodItems)
        })
        .onChange(of: sugar){ _ in
            if collection.whereToSave == .addedFoodItems {
                updatePrediction(workList: collection.addedFoodItems)
            } else {
                updatePrediction(workList: collection.editedFoodItems)
            }
        }
        .onChange(of: ftpreviewIndex, perform: { _ in
            if collection.whereToSave == .addedFoodItems {
                updatePrediction(workList: collection.addedFoodItems)
            } else {
                updatePrediction(workList: collection.editedFoodItems)
            }
        })
        .onChange(of: date, perform: { _ in
            if collection.whereToSave == .addedFoodItems {
                updatePrediction(workList: collection.addedFoodItems)
            } else {
                updatePrediction(workList: collection.editedFoodItems)
            }
        })
        .animation(.default, value: isVisible)
    }
    func removeRows(i: Int){
        if collection.whereToSave == .addedFoodItems {
            collection.addedFoodItems.remove(at: i)
        } else {
            collection.editedFoodItems.remove(at: i)
        }
    }
    func updatePrediction(workList: [foodItem]){
        do {
            if (workList.count != 0 && sugar != "" && routeManager.version != 2) {
                var food: [String] = []
                var gram: [Double] = []
                workList.forEach {
                    food.append($0.name)
                    gram.append($0.gram!)
                }
                let model_input = predictManager.provider.getData(BG0: try convert(txt: sugar), foodtype: ftpreviewIndex, foodN: food, gram: gram, picker_date: date)
                res = try predictManager.provider.getPredict(meal_type_n: model_input.meal_type_n, gi: model_input.gi, gl: model_input.gl, carbo: model_input.carbo, carbo_b6h: model_input.carbo_b6h, prot_b6h: model_input.prot_b6h, fat_b6h: model_input.fat_b6h, BG: model_input.BG, BMI: model_input.BMI, HbA1C_V1: model_input.HbA1C_V1, TG_V1: model_input.TG_V1, Hol_V1: model_input.Hol_V1, fasting_glu: model_input.fasting_glu, pregnancy_week: model_input.pregnancy_week)
                let checkCarbo = checkCarbo(foodType: ftpreviewIndex.rawValue, listOfFood: workList)
                recomendationCards = getMessage(highBGPredict: checkBGPredicted(BG1: res), highBGBefore: checkBGBefore(BG0: try convert(txt: sugar)), moderateAmountOfCarbo: checkCarbo.0, tooManyCarbo: checkCarbo.1, unequalGLDistribution: checkUnequalGlDistribution(listOfFood: workList), highGI: checkGI(listOfFood: workList))
                recCardID = recomendationCards.isEmpty ? UUID() : recomendationCards[0].id
                if !recomendationCards.isEmpty {
                    isVisible = true
                    withAnimation(.none){
                        sugarlvl = "УГК превысит норму"
                        recColor = Color(red: 255/255, green: 91/255, blue: 36/255)
                        fontColor = Color.white
                    }
                } else {
                    isVisible = false
                    withAnimation(.none){
                        sugarlvl = "УГК не превысит норму"
                        recColor = Color.green.opacity(0.7)
                        fontColor = Color.white
                    }
                }
                scolor = Color("listButtonColor")
            } else {
                isVisible = false
                withAnimation(.none){
                    sugarlvl = "УГК не определен"
                    recColor = Color("BG_Undefined")
                    fontColor = Color("BG_Font_Undefined")
                }
            }
        }
        catch inputErorrs.decimalError {
            scolor = .red
        }
        catch modelErorrs.generalError {
            scolor = .red
        }
        catch {
            scolor = .red
        }
    }
    func saveInDB(workList: [foodItem]){
        permission = diaryManager.provider.checkIfAlreadyEx(selectedDate: date, idForDelete: idForDelete)
        if permission {
            errorMessage = "Удалите или отредактиируйте уже существующий прием пищи"
        }
        if enabled && !permission {
            do {
                let _BG0 = try convert(txt: sugar)
                if !idForDelete.isEmpty {
                    deleteFromBD(idToDelete: idForDelete, table: 0)
                    hasChanged = true
                }
                for i in workList {
                    diaryManager.provider.SaveToDB(FoodName: i.name, gram: "\(i.gram!)", table_id: "\(i.table_id)", selectedDate: date, selectedType: ftpreviewIndex.rawValue)
                }
                diaryManager.provider.addPredictedRecord(selectedDate: date, selectedType: ftpreviewIndex.rawValue, BG0: _BG0, BG1: res)
                collection.selectedItem = nil
                self.presentationMode.wrappedValue.dismiss()
            }
            catch {
                print(error)
                permission = true
                errorMessage = "Заполните поля в соотвествии с требованиями"
            }
        }
        else if !enabled && !permission {
            if !idForDelete.isEmpty {
                deleteFromBD(idToDelete: idForDelete, table: 0)
                hasChanged = true
            }
            for i in workList {
                diaryManager.provider.SaveToDB(FoodName: i.name, gram: "\(i.gram!)", table_id: "\(i.table_id)", selectedDate: date, selectedType: ftpreviewIndex.rawValue)
            }
            diaryManager.provider.addPredictedRecord(selectedDate: date, selectedType: ftpreviewIndex.rawValue, BG0: 0.0, BG1: 0.0)
            collection.selectedItem = nil
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
