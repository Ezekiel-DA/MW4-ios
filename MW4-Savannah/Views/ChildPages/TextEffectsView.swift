//
//  TextEffectsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct TextEffectsView: View {
    @ObservedObject var textDisplayService: TextDisplayService
    
    var body: some View {
       
            VStack {
//                CostumeGraphicView(
//                    costumeManager: // TODO
//                    chairLightColor: .white,
//                    pedLightColor: .white,
//                    isChairRainbow: false,
//                    isPedRainbow: false,
//                    txtDisplay: "I WANT YOU",
//                    txtColor: .white)

                Form {
                    Section {
                       
                        TextChooserView(isButtonSection: false, textDisplayService: textDisplayService)
                    }
                    
                    Section {
                        TextChooserView(isButtonSection: true, textDisplayService: textDisplayService)
                    }
                }
            }
    }
}

struct TextEffectsView_Previews: PreviewProvider {
    static var previews: some View {
        TextEffectsView(textDisplayService: TextDisplayServiceMock(text: "TEAM SAVANNAH", scrolling: 1))
            .previewInterfaceOrientation(.portrait)
    }
}
