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
    
}

struct TextChooserView: View {
    @State private var text: String = "I WANT YOU"
    @State private var picked: Int = 0
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    Text("Text")
                    TextField("I WANT YOU", text: $text)
                        .frame(width: 300, alignment: .leading)
                        .padding(4)
                        .border(.black)
                    Text("Scrolling")
                    
                    Picker(selection: $picked, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                        ForEach(ScrollingModes.allCases, id: \.rawValue) { item in
                            Text(item.title).tag(item.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Text color")
                    HColorPickerView()
                }
            }
        }
    }
}

struct TextChooserView_Previews: PreviewProvider {
    static var previews: some View {
        TextChooserView()
    }
}
