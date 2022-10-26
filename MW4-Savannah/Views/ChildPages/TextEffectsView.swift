//
//  TextEffectsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct TextEffectsView: View {
    @ObservedObject var costume: CostumeModelView
        
    var body: some View {
        DetailsView(costume: costume, defaultContent: {
            TextChooserView(textScreen: $costume.textScreen)
        }, altContent: {
            TextChooserView(textScreen: $costume.textScreenAlt)
        })
    }
}

struct TextEffectsView_Previews: PreviewProvider {
    static var previews: some View {
        TextEffectsView(costume: CostumeModelView())
    }
}
