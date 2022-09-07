//
//  BottomNavigationButtons.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/7/22.
//

import SwiftUI

struct BottomNavigationButtons: View {
    var body: some View {
        HStack {
            Button("Reset") {
                
            }.frame(minWidth: 140).padding().border(.black, width: 1).foregroundColor(.black)
            Button("Done") {
                
            }.frame(minWidth: 140).padding().border(.black, width: 1).foregroundColor(.black)
        }
    }
}

struct BottomNavigationButtons_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationButtons()
    }
}
