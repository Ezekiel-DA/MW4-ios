//
//  TextChooserView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/7/22.
//

import SwiftUI


enum TextColor: Int, CaseIterable {
    case White
    case Red
    case Custom
    
    var title: String {
        switch self {
        case .White: return "White"
        case .Red: return "Red"
        case .Custom: return "Custom"
        }
    }
    
}

struct TextChooserView: View {
    let isButtonSection: Bool
    @State private var isOn: Bool = true
    @State private var isScrollingEnabled: Bool = false
    @State private var text: String = "I WANT YOU"
    @State private var colorPicked: Int = 0
    @State private var rainbowModePicked: Int = 0
    @State private var scrollingSpeed: Double = 100
    
    
    var body: some View {
        VStack(alignment: .leading) {
            if (isButtonSection) {
                Toggle(isOn: $isOn) { Text("Button Trigger").fontWeight(.heavy) }
                Text("Display desired text for 3s")
                    .padding(.bottom)
            }
            else{
                Text("Default Status").fontWeight(.heavy)
            }
            //Only show additional UI if the toggle is On
            if (isOn){
                Text("Text Color")
                Picker(selection: $colorPicked, label: Text("Or")) {
                    ForEach(TextColor.allCases, id: \.rawValue) { item in
                        VStack{

                            Text(item.title).tag(item.rawValue)
                        }
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
           
                
                if (colorPicked == 2){
                    HColorPickerView(label: "Color")
                    Divider()

                }
                
                Text("Text to display")
                TextField("I WANT YOU", text: $text)
                    .frame(alignment: .leading)
                    .padding(4)
                    .border(.black)
                Toggle(isOn: $isScrollingEnabled) { Text("Scrolling")}
              
                if(isScrollingEnabled){
                    VStack(alignment: .leading){
                        Divider()
                        Text("Scrolling Speed")
                        HStack{
                            Image(systemName: "tortoise.fill").foregroundColor(.gray)
                            Slider(value: $scrollingSpeed, in: 0...200)
                            Image(systemName: "hare.fill").foregroundColor(.gray)
                        
                        }
                        Divider()
                    }
                  
                
                }
                
            }
      
        
        }
    }
}

struct TextChooserView_Previews: PreviewProvider {
    static var previews: some View {
        TextChooserView(isButtonSection: true)
    }
}
