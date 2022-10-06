//
//  TextEffectsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct TextEffectsView: View {
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
                    txtScroll: 0,//0-none, 1-scroll left
                    txtSpeed: 0.02) //seconds

                Form {
                    Section {
                       
                        TextChooserView(isButtonSection: false)
                    }
                    
                    Section {
                        TextChooserView(isButtonSection: true)
                    }
                }
                //BottomNavigationButtons().padding()
            }
            
         
        

    }
}

struct TextEffectsView_Previews: PreviewProvider {
    static var previews: some View {
        TextEffectsView()
            .previewInterfaceOrientation(.portrait)
    }
}
