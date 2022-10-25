//
//  CostumeGraphicView.swift
//  MW4-Savannah
//
//  Created by LAMA Chin-Loo on 10/1/22.
//

import SwiftUI

struct CostumeGraphicView: View {
    @ObservedObject var chairLightsManager: LightDeviceService
    @ObservedObject var pedestalLightsManager: LightDeviceService
    
    @State var chairLightColor: Color
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
                    .foregroundColor(Color(hue: chairLightsManager.hue != nil ? chairLightsManager.hue!.double / 255 : 0.0,
                                           saturation: chairLightsManager.saturation != nil ? chairLightsManager.saturation!.double / 255 : 0.0,
                                           brightness: chairLightsManager.value != nil ? chairLightsManager.value!.double / 255 : 0.0))
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
                    .foregroundColor(Color(hue: pedestalLightsManager.hue != nil ? pedestalLightsManager.hue!.double / 255 : 0.0,
                                           saturation: pedestalLightsManager.saturation != nil ? pedestalLightsManager.saturation!.double / 255 : 0.0,
                                           brightness: pedestalLightsManager.value != nil ? pedestalLightsManager.value!.double / 255 : 0.0))
                    .position(x: 200, y: 150)
            }
            Text(txtDisplay)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .colorMultiply(txtColor)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .position(x: 200,y: 280)
                	
        }.frame(height:300)
    }
}

struct CostumeGraphicView_Previews: PreviewProvider {
    static var previews: some View {
        CostumeGraphicView(
            chairLightsManager: LightDeviceServiceMock(hue: 0, saturation: 0, value: 255),
            pedestalLightsManager: LightDeviceServiceMock(hue: 128, saturation: 255, value: 255),
            chairLightColor: .green,
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
