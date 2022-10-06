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
    @State var cRainbowAnime: Int //0-none, 1-wave, 2-cycle
    @State var isPedRainbow: Bool
    @State var pRainbowAnime: Int //0-none, 1-wave, 2-cycle
    @State var txtDisplay: String
    @State var txtColor: Color
    @State var txtBgColor: Color
    @State var txtScroll: Int //0-none, 1-Left
    @State var txtSpeed: Double //text scroll speed
    //@State var isPulsing: Bool //pulse 3 sec - is this necessary?
    
    //preview botton action - should this be in this view or called via command
    
    var body: some View {
        ZStack {
            //Chair background
            Image("chairIconBase").position(x: 200, y: 150)
            
            //If Rainbow is triggered, show rainbow layer
            if isChairRainbow == true {
                switch cRainbowAnime {
                case 0: //case of no animation
                    Image("chairIconLights")
                        .renderingMode(.template)
                        .foregroundColor(chairLightColor)
                        .position(x: 200, y: 150)
                        .rainbow()
                case 1: //case of rainbow wave
                    Image("chairIconLights")
                        .renderingMode(.template)
                        .foregroundColor(chairLightColor)
                        .position(x: 200, y: 150)
                        .rainbowAnimation()
                case 2: //case of rainbow wave
                    Image("chairIconLights")
                        .renderingMode(.template)
                        .foregroundColor(chairLightColor)
                        .position(x: 200, y: 150)
                        .rainbowCycle()
                default:
                    Image("chairIconLights")
                        .renderingMode(.template)
                        .foregroundColor(chairLightColor)
                        .position(x: 200, y: 150)
                        .rainbow()
                }
            }else{
                //Else show the solid colored chair lights
                Image("chairIconLights")
                    .renderingMode(.template)
                    .foregroundColor(chairLightColor)
                    .position(x: 200, y: 150)
            }
            //Pedestal base
            Image("PedestalBase").position(x: 200, y: 150)
            
            //If Rainbow is triggered, show this layer
            if isPedRainbow == true{
                switch pRainbowAnime {
                case 0: //case of no animation
                    Image("PedestalLights")
                        .renderingMode(.template)
                        .foregroundColor(pedLightColor)
                        .position(x: 200, y: 150)
                        .rainbow()
                case 1: //case of rainbow wave
                    Image("PedestalLights")
                        .renderingMode(.template)
                        .foregroundColor(pedLightColor)
                        .position(x: 200, y: 150)
                        .rainbowAnimation()
                case 2:
                    Image("PedestalLights")
                        .renderingMode(.template)
                        .position(x: 200, y: 150)
                        .rainbowCycle()
                default:
                    Image("PedestalLights")
                        .renderingMode(.template)
                        .foregroundColor(pedLightColor)
                        .position(x: 200, y: 150)
                        .rainbow()
                }
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
                isChairRainbow: true,
                cRainbowAnime: 2,
                isPedRainbow: true,
                pRainbowAnime: 2,
                txtDisplay: "I WANT YOU",
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
            (1...50).forEach { _ in
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
//Rainbow ViewModifier
struct Rainbow: ViewModifier {
    let hueColors = stride(from: 0, to: 1, by: 0.01).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }

    func body(content: Content) -> some View {
        content
            .overlay(GeometryReader { (proxy: GeometryProxy) in
                ZStack {
                    LinearGradient(gradient: Gradient(colors: self.hueColors),
                                   startPoint: .top,
                                   endPoint: .bottom)
                        .frame(height: (proxy.size.height))
                }
            })
            .mask(content)
    }
}
extension View {
    func rainbow() -> some View {
        self.modifier(Rainbow())
    }
}
//Rainbow Animation View Modifier
struct RainbowAnimation: ViewModifier {
    @State var isOn: Bool = false
    let hueColors = stride(from: 0, to: 1, by: 0.01).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }
    // Animation
    var duration: Double = 8
    var animation: Animation {
        Animation
            .linear(duration: duration)
            .repeatForever(autoreverses: false)
    }

    func body(content: Content) -> some View {
    // Two gradient lengths for looping/repeating
        let gradient = LinearGradient(gradient: Gradient(colors: hueColors+hueColors), startPoint: .bottom, endPoint: .top)
        return content.overlay(GeometryReader { proxy in
            ZStack {
                gradient
    // Double height of gradient
                    .frame(height: 2*proxy.size.height)
    // Use a ternary operator to change the y offset from its initial position of half the masks height to the bottom to half the masks height to the top
                    .offset(y: self.isOn ? -proxy.size.height : 0)
            }
        })
        //Use the on appear method to change the isOn value to true using the animation made earlier
        .onAppear {
            withAnimation(self.animation) {
                self.isOn = true
            }
        }
        .mask(content)
    }
}
extension View {
    func rainbowAnimation() -> some View {
        self.modifier(RainbowAnimation())
    }
}
struct RainbowCycle: ViewModifier {
    @State private var cycle = false
    // Animation
    var duration: Double = 2
    var animation: Animation {
        Animation
            .linear(duration: duration)
            .repeatForever(autoreverses: false)
    }
    func body(content: Content) -> some View {
        return content.overlay(GeometryReader { proxy in
            Image("gradientChunk")
            .frame(height: 2*proxy.size.height)
            .offset(y: self.cycle ? -proxy.size.height*6 : proxy.size.height*5)
        })
        .onAppear {
            withAnimation(self.animation.speed(0.1)) {
                self.cycle = true
            }
        }
        .mask(content)
    }
}
extension View {
    func rainbowCycle() -> some View {
        self.modifier(RainbowCycle())
    }
}
