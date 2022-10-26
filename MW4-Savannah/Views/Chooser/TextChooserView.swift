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
//    case Up
    
    var title: String {
        switch self {
        case .None: return "None"
        case .Left: return "Left"
//        case .Up: return "Up"
        }
    }
    
    var graphics: String {
        switch self {
        case .None:
            return "nosign"
        case .Left:
            return "arrow.left"
//        case .Up:
//            return "arrow.up"
        }
    }
}

struct TextChooserView: View {
    let isButtonSection: Bool
    @State private var isOn: Bool = true
    @State private var picked: Int = 0
    
    @ObservedObject var textDisplayService: TextDisplayService
    
    var body: some View {
        VStack(alignment: .leading) {
            if (isButtonSection) {
                HStack {
                    Text("On button press:").fontWeight(.heavy)
                    Text("for 60 seconds").font(/*@START_MENU_TOKEN@*/.subheadline/*@END_MENU_TOKEN@*/).fontWeight(.light)
                }
            }
            
            //Only show additional UI if the toggle is On
            if (isOn){
                Text("Color")
                Picker(selection: $picked, label: Text("Or")) {
                    ForEach(ColorMode.allCases, id: \.rawValue) { item in
                        VStack{

                            Text(item.title).tag(item.rawValue)
                        }
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
//                if (picked == 2){
//                    HColorPickerView(hue: $textDisplayService.hue,label: "Color")
//                }
                
                Text("Text")
                TextField("I WANT YOU", text: Binding($textDisplayService.text)!)
                    .frame(alignment: .leading)
                    .padding(4)
                    .border(.black)
                Text("Scrolling")
                
                Picker(selection: Binding($textDisplayService.scrolling)!, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    ForEach(ScrollingModes.allCases, id: \.rawValue) { item in
                        Image(systemName: item.graphics).tag(UInt8(item.rawValue))
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

struct TextChooserView_Previews: PreviewProvider {
    static var previews: some View {
        TextChooserView(isButtonSection: true, textDisplayService: TextDisplayServiceMock(text: "Hello world", scrolling: 1))
    }
}
