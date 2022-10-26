//
//  CostumeNotPresentView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/25/22.
//

import SwiftUI

struct CostumeNotPresentView: View {
    @ObservedObject var costume: CostumeModelView
    @Binding var demoMode: Bool
    
    var body: some View {
        VStack {
            Text(costume.bluetoothOff ?
                 "Please turn Bluetooth on in Settings."
                 : costume.bluetoothUnavailable ?
                 "Please allow \(Bundle.main.displayName) access to Bluetooth"
                 : costume.ready ? "Costume found, connecting..." : "Please turn on costume"
            )
        }
        Text("or")
        Button("use Demo mode") {
            demoMode = true
        }
    }
}

struct CostumeNotPresentView_Previews: PreviewProvider {
    static var previews: some View {
        CostumeNotPresentView(costume: CostumeModelView(), demoMode: .constant(false))
    }
}
