//
//  TextEffectsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct TextEffectsView: View {
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
                    //txtDisplay: "I WANT YOU",
                    txtColor: .white)
                
                Form {
                    Section {
                        TextChooserView(isButtonSection: false, textDisplayService: costumeManager.frontTextService)
                    }
                    
                    Section {
                        TextChooserView(isButtonSection: true, textDisplayService: costumeManager.frontTextService)
                    }
                }
            }
    }
}

//struct TextEffectsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextEffectsView(textDisplayService: TextDisplayServiceMock(text: "TEAM SAVANNAH", scrolling: 1))
//            .previewInterfaceOrientation(.portrait)
//    }
//}
