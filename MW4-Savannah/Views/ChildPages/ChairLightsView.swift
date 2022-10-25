//
//  ChairLightsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct ChairLightsView: View {
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
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        LightStripEffectChooserView(device: costumeManager.chairLightsService, isButtonSection: false)
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        LightStripEffectChooserView(device: costumeManager.chairLightsService, isButtonSection: true)
                    }
                }
            }
        }
    }
}

struct ChairLightsView_Previews: PreviewProvider {
    static var previews: some View {
        ChairLightsView(costumeManager: CostumeManagerMock(connected: true, bluetoothUnavailable: false, bluetoothOff: false, fwVersion: 2))
    }
}
