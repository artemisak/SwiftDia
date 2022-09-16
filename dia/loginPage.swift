import SwiftUI

enum Field: Hashable {
    case username
    case password
}

struct loginPage: View {
    @State private var login: String = ""
    @State private var pass: String = ""
    @State private var isnt: Bool = false
    @State private var reg: Bool = false
    @State private var isLoading: Bool = false
    @ObservedObject var islogin: check
    @Binding var txtTheme: DynamicTypeSize
    @FocusState private var focusedField: Field?
    var body: some View {
        GeometryReader {g in
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: .zero) {
                            TextField("Логин", text: $login)
                                .onChange(of: login, perform: {i in
                                    if isnt {
                                        withAnimation(){
                                            isnt.toggle()
                                        }
                                    }
                                })
                                .foregroundColor(.black)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .focused($focusedField, equals: .username)
                                .onSubmit {
                                    focusedField = .password
                                }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(isnt ? Color.red : Color.gray.opacity(0.5), lineWidth: 1))
                        VStack(alignment: .leading, spacing: .zero) {
                            SecureField("Пароль", text: $pass)
                                .onChange(of: pass, perform: {i in
                                    if isnt {
                                        withAnimation(){
                                            isnt.toggle()
                                        }
                                    }
                                })
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .focused($focusedField, equals: .password)
                                .onSubmit {
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.001, execute: {
                                        withAnimation(){
                                            isnt = islogin.setlogged(upass: pass, ulogin: login)
                                        }
                                    })
                                }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(isnt ? Color.red : Color.gray.opacity(0.5), lineWidth: 1))
                    }
                    if isnt {
                        Text("Неверный логин или пароль")
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Button(action: {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.001, execute: {
                            isLoading = false
                            withAnimation(){
                                isnt = islogin.setlogged(upass: pass, ulogin: login)
                            }
                        })
                    }, label: {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Войти")
                        }
                    })
                    .buttonStyle(RoundedRectangleButtonStyle())
                    NavigationLink(destination: {
                        regHelper(phelper: $reg)
                    }, label: {
                        HStack{
                            Text("Регистрация")
                            Image(systemName: "questionmark.circle")
                        }
                    })
                    .buttonStyle(ChangeColorButton())
                }
                .padding()
                .frame(width: g.size.width)
                .frame(minHeight: g.size.height)

            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Dia ID")
                        .foregroundColor(Color.black)
                        .font(.title)
                        .fontWeight(.bold)
                        .fixedSize()
                    Image("ofIconTransparent")
                        .resizable()
                        .frame(width: 35.0, height: 35.0)
                        .zIndex(1)
                }
            }
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button(action: {
                    focusedField = nil
                }, label: {
                    Text("Готово").dynamicTypeSize(txtTheme)
                })
            })
        }
        .onAppear {
            login = ""
            pass = ""
        }
        .ignoresSafeArea()
    }
}
