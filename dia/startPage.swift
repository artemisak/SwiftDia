//
//  startPage.swift
//  dia
//
//  Created by Артём Исаков on 20.08.2022.
//

import SwiftUI

struct startPage: View {
    @StateObject private var islogin = check()
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        NavigationView {
            if islogin.istrue {
                if islogin.isChoosed {
                    mainPage(txtTheme: $txtTheme)
                } else {
                    versionChoose()
                }
            } else {
                loginPage(txtTheme: $txtTheme)
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            islogin.checklog()
        }
        .environmentObject(islogin)
    }
}

struct startPage_Previews: PreviewProvider {
    static var previews: some View {
        startPage(txtTheme: .constant(.medium))
    }
}
