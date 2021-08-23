
import SwiftUI

struct ContentView: View {
    @State private var showModal: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                HStack {
                    VStack {
                        NavigationLink(destination: page2()) {
                            VStack {
                                Image("menu_sugar")
                                Text("Изменение сахара")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        NavigationLink(destination: page2()) {
                            VStack {
                                Image("menu_food")
                                Text("Прием пищи")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }.padding(.vertical, 26.3)
                        NavigationLink(destination: page2()) {
                            VStack {
                                Image("menu_paper")
                                Text("История записей")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    VStack {
                        NavigationLink(destination: page3()) {
                            VStack {
                                Image("menu_syringe")
                                Text("Введение инсулина").foregroundColor(Color.black).multilineTextAlignment(.center)
                            }
                            
                        }
                        NavigationLink(destination: page3()) {
                            VStack {
                                Image("menu_sleep")
                                Text("Физическая активность \n и сон").foregroundColor(Color.black).multilineTextAlignment(.center)
                            }
                            
                        }
                        .padding(.top, 26.3)
                        NavigationLink(destination: page3()) {
                            VStack {
                                Image("menu_chart")
                                Text("Эскпорт данных").foregroundColor(Color.black).multilineTextAlignment(.center)
                            }
                        }
                    }
                }.padding(.bottom)
                ModalView(isShowing: $showModal)
                .navigationBarTitle("Главная")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        Button(action: {showModal.toggle()}){
                            Image(systemName: "gear")
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 12")
        }
    }
}

