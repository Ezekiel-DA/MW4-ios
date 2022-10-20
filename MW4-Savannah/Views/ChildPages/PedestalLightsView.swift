//
//  PedestalLightsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct PedestalLightsView: View {
    @ObservedObject var lightDeviceService: LightDeviceService
    
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
                        LightStripEffectChooserView(device: lightDeviceService, isButtonSection: false)
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        LightStripEffectChooserView(device: lightDeviceService, isButtonSection: true)
                    }
                }
            }
            
           // BottomNavigationButtons().padding()
      
        }
    }
}

struct PedestalLightsView_Previews: PreviewProvider {
    static var previews: some View {
        PedestalLightsView(lightDeviceService: LightDeviceService())
    }
}
