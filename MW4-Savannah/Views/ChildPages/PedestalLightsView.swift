//
//  PedestalLightsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct PedestalLightsView: View {
    @ObservedObject var costumeManager: CostumeManager
    
    var body: some View {
        VStack {
            CostumeGraphicView(
                chairLightsManager: costumeManager.chairLightsService,
                pedestalLightsManager: costumeManager.pedestalLightsService,
                chairLightColor: .white,
                isChairRainbow: false,
                isPedRainbow: false,
                txtDisplay: Binding($costumeManager.frontTextService.text)!,
                txtColor: .white)
            
            Spacer()
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        LightStripEffectChooserView(device: costumeManager.pedestalLightsService, isButtonSection: false)
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        LightStripEffectChooserView(device: costumeManager.pedestalLightsService, isButtonSection: true)
                    }
                }
            }
        }
    }
}

struct PedestalLightsView_Previews: PreviewProvider {
    static var previews: some View {
        PedestalLightsView(costumeManager: CostumeManagerMock(connected: true, bluetoothUnavailable: false, bluetoothOff: false, fwVersion: 2))
    }
}
