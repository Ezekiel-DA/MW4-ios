//
//  TextChooserView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/7/22.
//

import SwiftUI

enum ScrollingModes: Int, CaseIterable {
    case None
    case Left
    case Up
    
    var title: String {
        switch self {
        case .None: return "None"
        case .Left: return "Left"
        case .Up: return "Up"
        }
    }
    
    var graphics: String {
        switch self {
        case .None:
            return "nosign"
        case .Left:
            return "arrow.left"
        case .Up:
            return "arrow.up"
        }
    }
}

struct TextChooserView: View {
    let isButtonSection: Bool
    @State private var isOn: Bool = true
    @State private var text: String = "I WANT YOU"
    @State private var picked: Int = 0
    
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
                Text("Color")
                Picker(selection: $picked, label: Text("Or")) {
                    ForEach(LightModes.allCases, id: \.rawValue) { item in
                        VStack{

                            Text(item.title).tag(item.rawValue)
                        }
                           
                        
                       
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                if (picked == 3){
                    HColorPickerView(label: "Color")

                }
                
                Text("Text")
                TextField("I WANT YOU", text: $text)
                    .frame(alignment: .leading)
                    .padding(4)
                    .border(.black)
                Text("Scrolling")
                
                Picker(selection: $picked, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    ForEach(ScrollingModes.allCases, id: \.rawValue) { item in
                            //Text(item.title).tag(item.rawValue)
                        Image(systemName: item.graphics).tag(item.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
      
        
        }
    }
}

struct TextChooserView_Previews: PreviewProvider {
    static var previews: some View {
        TextChooserView(isButtonSection: true)
    }
}
