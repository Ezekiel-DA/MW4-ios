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
            CostumeGraphicView(
                chairLightColor: .white,
                pedLightColor: .white,
                isChairRainbow: false,
                isPedRainbow: false,
                txtDisplay: "I WANT YOU",
                txtColor: .white)
            
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
        ForEach(["iPhone 7 Plus", "iPhone Xs"], id: \.self) { deviceName in
            ChairLightsView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}


