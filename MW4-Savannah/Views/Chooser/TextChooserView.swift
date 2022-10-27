//
//  TextChooserView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/7/22.
//

import SwiftUI

enum ScrollingMode: Int, CaseIterable, Identifiable {
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
    
    var id: Self { self }
}

struct TextChooserView: View {
    @Binding var textScreen: TextModelView
    
    @State private var isOn: Bool = true
    @State private var colorSelection: ColorMode
    @State private var scrollingMode: ScrollingMode
    
    init(textScreen: Binding<TextModelView>) {
        _textScreen = textScreen
        
        if (textScreen.wrappedValue.color == .white) {
            colorSelection = .White
        } else if (textScreen.wrappedValue.color == Color.fullRed) {
            colorSelection = .Red
        } else {
            colorSelection = .Custom
        }
        
        if (textScreen.wrappedValue.scrolling) {
            scrollingMode = .Left
        } else {
            scrollingMode = .None
        }
    }
        
    var body: some View {
        VStack(alignment: .leading) {
            
            //Only show additional UI if the toggle is On
            if (isOn){
                HStack {
                    Text("Color")
                    Picker("Color", selection: $colorSelection) {
                        ForEach(ColorMode.allCases) { item in
                            VStack{
                                Text(item.title)
                            }
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .onChange(of: colorSelection) { newValue in
                        switch newValue {
                        case .White:
                            textScreen.color = Color.white
                        case .Red:
                            textScreen.color = Color.fullRed
                        case .Custom:
                            break
                        }
                    }
                }
                if (colorSelection == .Custom){
                    HColorPickerView(color: $textScreen.color)
                }
                                
                Text("Text")
                TextField("I WANT YOU", text: $textScreen.string)
                    .textInputAutocapitalization(.characters)
                    .frame(alignment: .leading)
                    .padding(4)
                    .border(.black)
                Text("Scrolling")
                
                Picker(selection: $scrollingMode, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    ForEach(ScrollingMode.allCases) { item in
                        Image(systemName: item.graphics)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: scrollingMode, perform: {newValue in
                    switch newValue {
                    case .None:
                        textScreen.scrolling = false
                    case .Left:
                        textScreen.scrolling = true
                    }
                })
            }
        }
    }
}

struct TextChooserView_Previews: PreviewProvider {
    static var previews: some View {
        TextChooserView(textScreen: .constant(TextModelView(string: "TESTING")))
    }
}
