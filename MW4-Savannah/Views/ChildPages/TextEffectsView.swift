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
                    isPedRainbow: false,
                    txtDisplay: "I WANT YOU",
                    txtColor: .white)

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
