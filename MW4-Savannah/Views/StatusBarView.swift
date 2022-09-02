//
//  TopStatusBar.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 8/30/22.
//

import SwiftUI

struct StatusBarView: View {
    var connected: Bool
    var fwVersion: Int?
    
    var width: CGFloat = 100.0
    
    var body: some View {
        HStack {
            if (connected) {
                Label("Connected", systemImage: "wifi")
                    .labelStyle(.titleAndIcon)
                    .foregroundColor(.green)
                    .font(.footnote)
                    .frame(width: width)
            } else {
                Label("Scanning...", systemImage: "wifi.slash")
                    .labelStyle(.titleAndIcon)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            Spacer()
            Text("(not) The Voice™").font(.title2)
            Spacer()
            if let version = fwVersion { Text("fw ver.: " + String(version)).font(.footnote)} else {
                Text("fw ver.: ?").font(.footnote).opacity(0.2) 
            }
        }
    }
}

struct TopStatusBar_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView(connected: true, fwVersion: 2)
    }
}
