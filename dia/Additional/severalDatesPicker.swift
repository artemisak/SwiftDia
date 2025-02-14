import SwiftUI

struct severalDatesPicker: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var multipleIsPresented = false
    @State private var rkManager3 = RKManager(calendar: Calendar.current, minimumDate: Calendar.current.date(byAdding: .month, value: -1, to: Date())!, maximumDate: Calendar.current.date(byAdding: .month, value: 1, to: Date())!, mode: 3)
    var body: some View {
        RKViewController(isPresented: self.$multipleIsPresented, rkManager: self.rkManager3)
            .onAppear(perform: startUp)
            .navigationTitle("Полные дни")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button(action: {
                        patientManager.provider.addDatesToDB(dates: rkManager3.selectedDates)
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Сохранить")
                    }
                }
            }
    }
    func startUp() {
        rkManager3.selectedDates = patientManager.provider.getDatesFromDB()
        rkManager3.colors.weekdayHeaderColor = Color.blue
        rkManager3.colors.monthHeaderColor = Color("listButtonColor")
        rkManager3.colors.textColor = Color.blue
        rkManager3.colors.disabledColor = Color.red
        rkManager3.colors.todayBackColor = Color.blue
        rkManager3.colors.weekdayHeaderColor = Color("listButtonColor")
    }
}
