//
//  CostumePreviewView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/25/22.
//

import SwiftUI

struct CostumePreviewView: View {
    @ObservedObject var costume: CostumeModelView
    
    var body: some View {
        ZStack {
            //Chair background
            Image("chairIconBase").position(x: 200, y: 150)
            
            //If Rainbow is triggered, show rainbow layer
            if costume.isButtonPressed ? costume.chairLightsAlt.mode.rawValue >= 2 : costume.chairLights.mode.rawValue >= 2 {
                LinearGradient(gradient: FastLEDHueGradient, startPoint: .leading, endPoint: .trailing)
                    .mask(Image("chairIconLights"))
                    .position(x: 200, y: 150)
            }else{
                //Else show the colored chair lights
                Image("chairIconLights")
                    .renderingMode(.template)
                    .foregroundColor(costume.isButtonPressed ? costume.chairLightsAlt.color : costume.chairLights.color)
                    .position(x: 200, y: 150)
            }
            //Pedestal base
            Image("PedestalBase").position(x: 200, y: 150)
            
            //If Rainbow is triggered, show this layer
            if costume.isButtonPressed ? costume.pedestalLightsAlt.mode.rawValue >= 2 : costume.pedestalLights.mode.rawValue >= 2 {
                LinearGradient(gradient: FastLEDHueGradient, startPoint: .bottom, endPoint: .top)
                    .frame(width:300,height:300)
                    .mask(Image("PedestalLights"))
                    .position(x: 200, y: 150)
            }else{
                //Else show the colord pedestal lights
                Image("PedestalLights")
                    .renderingMode(.template)
                    .foregroundColor(costume.isButtonPressed ? costume.pedestalLightsAlt.color : costume.pedestalLights.color)
                    .position(x: 200, y: 150)
            }
            Text(costume.isButtonPressed ? costume.textScreenAlt.string : costume.textScreen.string)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .colorMultiply(costume.isButtonPressed ? costume.textScreenAlt.color : costume.textScreen.color)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .position(x: 200,y: 280)
                    
        }.frame(height:300)
    }
}

struct CostumePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        CostumePreviewView(costume: CostumeModelView())
    }
}
