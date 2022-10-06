//
//  AudioView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct AudioView: View {
    var body: some View {
        VStack {
            CostumeGraphicView(
                chairLightColor: .white,
                pedLightColor: .white,
                isChairRainbow: false,
                cRainbowAnime: 0,
                isPedRainbow: false,
                pRainbowAnime: 0,
                txtDisplay: "I WANT YOU",
                txtColor: .white,
                txtBgColor: .gray,
                txtScroll: 0,
                txtSpeed: 0.02)
            .frame(height:300)
            
                Form {
                    Section {
                      //List doesn't seem to work with Form & Section?
                       // It is not displaying correctly
                        //Need to figure out later
                        AudioChooserView()
                    }
                }
            
          
        }
   
    }
}

struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
        AudioView()
    }
}
