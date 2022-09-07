//
//  TextEffectsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct TextEffectsView: View {
    var body: some View {
        VStack {
            Image("textEffectsImage").resizable().frame(width: 150, height: 200)
            Spacer()
            
            Form {
                Section {
                    TextChooserView()
                }
                
                Section {
                    VStack(alignment: .leading) {
                        HColorPickerView(label: "Text color")
                    }
                }
            }
            
            BottomNavigationButtons().padding()
        }
    }
}

struct TextEffectsView_Previews: PreviewProvider {
    static var previews: some View {
        TextEffectsView()
    }
}