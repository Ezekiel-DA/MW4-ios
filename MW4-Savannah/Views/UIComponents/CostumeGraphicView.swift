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
    //@State var cRainbowAnime: Int //0-cycle, 1-wave
    @State var isPedRainbow: Bool
    //@State var pRainbowAnime: Int //0-cycle, 1-wave
    @State var txtDisplay: String
    @State var txtColor: Color
    @State var txtBgColor: Color
    @State var txtScroll: Int //0-none, 1-Left, 2-Up
    @State var txtSpeed: Double //text scroll speed
    //@State var isPulsing: Bool //pulse 3 sec - is this necessary?
    
    //preview botton action - should this be in this view or called via command
    
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
            //Text Background
            Rectangle()
                .frame(width: 200, height: 25)
                .position(x: 200,y: 280)
                .foregroundColor(txtBgColor)
            
            //Text and Animation
            switch txtScroll {
            case 0: //no scroll
                Text(txtDisplay)
                    //.fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    //.colorMultiply(txtColor)
                    .foregroundColor(txtColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .position(x: 200,y: 280)
                
            case 1: //scroll left
                Marquee(
                    text: txtDisplay,
                    marqTxtColor: txtColor,
                    font: .systemFont(ofSize: 16, weight: .regular),
                    speed: txtSpeed)
                
            default:
                Text("")
            }
        }
    }
    
    struct CostumeGraphicView_Previews: PreviewProvider {
        static var previews: some View {
            CostumeGraphicView(
                chairLightColor: .white,
                pedLightColor: .white,
                isChairRainbow: false,
                isPedRainbow: false,
                txtDisplay: "MAGIC WHEELCHAIR",
                txtColor: .white,
                txtBgColor: .gray,
                txtScroll: 0,
                txtSpeed: 0.02)
        }
    }
}
//Marquee: Scrolling Text
struct Marquee: View{
    @State var text: String
    var marqTxtColor: Color
    var font: UIFont
    var speed: Double
    var pause: Double = 0
    @State var storedSize: CGSize = .zero //storing text size
    @State var offset: CGFloat = 0 //animation offset
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View{
        //Scroll horizontally using ScrollView
        ScrollView(.horizontal, showsIndicators: false){
            Text(text)
                .foregroundColor(marqTxtColor)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .position(x: 300,y: 280)
                .font(Font(font))
                .offset(x: offset)
                .mask(Rectangle()
                    .frame(width: 200, height: 25)
                    .position(x: 200,y: 280)
                    .foregroundColor(.black))
        }
        .disabled(true) //disable manual scrolling
        .onAppear {
            
            // Base Text
            let baseText = text
            
            //Continuous Text Animation
            //Adding Spacing for continuous scrolling text
            (1...8).forEach { _ in
                text.append(" ")
            }
            //Stopping animiation exactly before the next text
            storedSize = textSize()
            text.append(baseText)
            
            //Calculating Total Secs based on Text Width
            //Animation speed for each character will be 0.02s
            let timing: Double = (speed * storedSize.width)
            
            //Delaying first animation
            DispatchQueue.main.asyncAfter(deadline: .now() + pause){
                withAnimation(.linear(duration: timing)){
                    offset = -storedSize.width
                }
            }
        }
        //Repeating Marquee effect with the help of a Timer
        .onReceive(Timer.publish(every: (speed * storedSize.width) + pause, on: .main, in: .default) .autoconnect()) { _ in
            
            //Resetting offset to 0, so it looks like it is looping
            offset = 0
            withAnimation(.linear(duration: (speed * storedSize.width))){
                offset = -storedSize.width
                
            }
        }
    }
    //Text Size for Offset Animation
    func textSize()-> CGSize{
        let attributes = [NSAttributedString.Key.font: font]
        
        let size = (text as NSString).size(withAttributes: attributes)
        
        return size
    }
}
