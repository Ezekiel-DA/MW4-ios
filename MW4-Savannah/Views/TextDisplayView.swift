//
//  TextDisplayView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/2/22.
//

import SwiftUI

struct TextDisplayView: View {
    @ObservedObject var textDisplayService: TextDisplayService
    
    var body: some View {
        if (textDisplayService.device != nil) {
            VStack {
                HStack {
                    Text("Text: ")
                    TextField("front text", text: Binding($textDisplayService.text)!)
                }
            }
        }
    }
}

struct TextDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        TextDisplayView(textDisplayService: TextDisplayService())
    }
}
