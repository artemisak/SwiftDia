import SwiftUI

enum injects :String, CaseIterable, Identifiable {
    case natoshak = "Натощак"
    case zavtrak = "Завтрак"
    case obed = "Обед"
    case uzin = "Ужин"
    case dop = "Дополнительно"
    var id: String { self.rawValue }
}

enum injectType: String, CaseIterable, Identifiable {
    case ultra = "Ультракоторкий"
    case kor = "Короткий"
    case prolong = "Пролонгированный"
    var id: String { self.rawValue }
}

struct inject: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var t: String = ""
    @State private var date = Date()
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var isAct: Bool = false
    @State private var isCorrect: Bool = false
    @State private var previewIndex1 = injects.natoshak
    @State private var previewIndex = injectType.ultra
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        List {
            Section(header: Text("Общая информация").font(.system(size: 15.5))){
                TextField("Ед.", text: $t)
                    .keyboardType(.decimalPad)
                NavigationLink(destination: injectTypePicker(previewIndex: $previewIndex), label: {
                    HStack{
                        Text("Тип действия")
                        Spacer()
                        Text("\(previewIndex.rawValue)")
                            .foregroundColor(.gray)
                    }
                })
                NavigationLink(destination: injectPicker(previewIndex1: $previewIndex1), label: {
                    HStack{
                        Text("Прием пищи")
                        Spacer()
                        Text("\(previewIndex1.rawValue)")
                            .foregroundColor(.gray)
                    }
                })
            }
            Section(header: Text("Время измерения").font(.system(size: 15.5))){
                VStack(alignment: .center){
                    DatePicker(
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    ){}
                        .environment(\.locale, Locale.init(identifier: "ru"))
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .clipped()
                        .compositingGroup()
                }.frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Введение инсулина")
        .toolbar {
            ToolbarItemGroup(){
                Button(action: {
                    do {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ru_RU")
                        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
                        addInject(ed: try convert(txt: t), type: previewIndex.rawValue, priem: previewIndex1.rawValue, time: dateFormatter.string(from: date))
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        isCorrect = true
                    }
                }) {
                    Text("Сохранить").dynamicTypeSize(txtTheme)
                }
                .alert(isPresented: $isCorrect) {
                    Alert(title: Text("Статус операции"), message: Text("Введите релевантное \nзначение"), dismissButton: .default(Text("ОК")))
                }
            }
        }
        .toolbar(content: {
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button(action: {
                    UIApplication.shared.dismissedKeyboard()
                }, label: {
                    Text("Готово").dynamicTypeSize(txtTheme)
                })
            })
        })
        .ignoresSafeArea(.keyboard)
        .onAppear(perform: {
            UIScrollView.appearance().keyboardDismissMode = .onDrag
            UITableView.appearance().showsVerticalScrollIndicator = false
        })
    }
}

struct injectTypePicker: View {
    @Binding var previewIndex: injectType
    var body: some View {
        Form {
            Picker(selection: $previewIndex, label: Text("Тип действия").font(.system(size: 15.5))) {
                Text("Ультракороткий").tag(injectType.ultra)
                Text("Короткий").tag(injectType.kor)
                Text("Пролонгированный").tag(injectType.prolong)
            }.pickerStyle(.inline)
        }
    }
}

struct injectPicker: View {
    @Binding var previewIndex1: injects
    var body: some View {
        Form {
            Picker("Прием пищи", selection: $previewIndex1) {
                Text("Натощак").tag(injects.natoshak)
                Text("Завтрак").tag(injects.zavtrak)
                Text("Обед").tag(injects.obed)
                Text("Ужин").tag(injects.uzin)
                Text("Дополнительно").tag(injects.dop)
            }.pickerStyle(.inline)
        }
    }
}
