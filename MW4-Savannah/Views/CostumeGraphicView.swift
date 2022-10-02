//
//  CostumeGraphicView.swift
//  MW4-Savannah
//
//  Created by LAMA Chin-Loo on 10/1/22.
//

import SwiftUI

struct CostumeGraphicView: View {
    @State var chairLightColor: Color
    @State var pedLightColor: Color
    @State var isChairRainbow: Bool
    @State var isPedRainbow: Bool
    @State var txtDisplay: String
    @State var txtColor: Color
    
    var body: some View {
        ZStack {
            //Chair background
            Image("chairIconBase").position(x: 200, y: 150)
            
            //If Rainbow is triggered, show rainbow layer
            if isChairRainbow == true {
                LinearGradient(gradient: FastLEDHueGradient, startPoint: .leading, endPoint: .trailing)
                    .mask(Image("chairIconLights"))
                    .position(x: 200, y: 150)
            }else{
                //Else show the colored chair lights
                Image("chairIconLights")
                    .renderingMode(.template)
                    .foregroundColor(chairLightColor)
                    .position(x: 200, y: 150)
            }
            //Pedestal base
            Image("PedestalBase").position(x: 200, y: 150)
            
            //If Rainbow is triggered, show this layer
            if isPedRainbow == true{
                LinearGradient(gradient: FastLEDHueGradient, startPoint: .bottom, endPoint: .top)
                    .frame(width:300,height:300)
                    .mask(Image("PedestalLights"))
                    .position(x: 200, y: 150)
            }else{
                //Else show the colord pedestal lights
                Image("PedestalLights")
                    .renderingMode(.template)
                    .foregroundColor(pedLightColor)
                    .position(x: 200, y: 150)
            }
            Text(txtDisplay)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .colorMultiply(txtColor)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .position(x: 200,y: 280)
                
        }
    }
}

struct CostumeGraphicView_Previews: PreviewProvider {
    static var previews: some View {
        CostumeGraphicView(
            chairLightColor: .green,
            pedLightColor: .orange,
            isChairRainbow: false,
            isPedRainbow: false,
            txtDisplay: "HAPPY BIRTHDAY",
            txtColor: .blue)
    }
}
//pulse 3 sec
//preview botton action
//scroll direction
//
