//
//  ChairLightsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct ChairLightsView: View {
    
    var body: some View {
        VStack {
            Image("chairLightsImage").resizable().frame(width: 150, height: 200)
            Spacer()
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        LightStripEffectChooserView(name: "")
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        LightStripEffectChooserView(name: "Button trigger")
                    }
                }
            }
            
            BottomNavigationButtons().padding()
        }
    }
}

struct ChairLightsView_Previews: PreviewProvider {
    static var previews: some View {
        ChairLightsView()
    }
}
