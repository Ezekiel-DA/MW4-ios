//
//  PedestalLightsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct PedestalLightsView: View {
    var body: some View {
        VStack {
            CostumeGraphicView(
                chairLightColor: .white,
                pedLightColor: .white,
                isChairRainbow: false,
                cRainbowAnime: 1, //0-none, 1-wave, 2-cycle
                isPedRainbow: false,
                pRainbowAnime: 1, //0-none, 1-wave, 2-cycle
                txtDisplay: "MAGIC WHEELCHAIR",
                txtColor: .white,
                txtBgColor: .gray,
                txtScroll: 0,
                txtSpeed: 0.02)
            
            Spacer()
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        LightStripEffectChooserView(isButtonSection: false)
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        LightStripEffectChooserView(isButtonSection: true)
                    }
                }
            }
            
           // BottomNavigationButtons().padding()
      
        }
    }
}

struct PedestalLightsView_Previews: PreviewProvider {
    static var previews: some View {
        PedestalLightsView()
    }
}
