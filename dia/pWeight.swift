import SwiftUI

struct pWeight: View {
    @Binding var bWeight: Bool
    @Binding var txt: String
    @State private var lineColor: Color = Color.black
    var body: some View {
        VStack(spacing:0){
            Text("Вес до беременности, в кг")
                .padding()
            Divider()
            VStack(spacing:0){
                TextField("кг", text: $txt)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .keyboardType(.decimalPad)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(lineColor)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
            }.padding()
            Divider()
            HStack(){
                Button(action: {
                    txt = ""
                    bWeight.toggle()
                }){
                    Text("Отменить")
                }
                .buttonStyle(TransparentButton())
                Divider()
                Button(action: {
                    do {
                        addWeight(Weight: try convert(txt: txt))
                        txt = ""
                        lineColor = Color.black
                        bWeight.toggle()
                    } catch {
                        lineColor = Color.red
                    }
                }){
                    Text("Сохранить")
                }
                .buttonStyle(TransparentButton())
            }.frame(height: 50)
        }
        .background(Color.white.cornerRadius(10))
        .padding([.leading, .trailing], 15)
    }
}

enum inputErorrs: Error {
    case decimalError
}

func convert(txt: String) throws -> Double {
    let decimal = txt.components(separatedBy:",")
    guard decimal.count-1 < 2 else {
        throw inputErorrs.decimalError
    }
    return Double(String(txt.map{ $0 == "," ? "." : $0}))!
}
