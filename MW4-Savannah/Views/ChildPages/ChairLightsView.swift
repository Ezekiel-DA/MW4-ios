//
//  ChairLightsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct ChairLightsView: View {
    @ObservedObject var costume: CostumeModelView
    
    var body: some View {
        DetailsView(costume: costume, defaultContent: {
            LightStripEffectChooserView(lights: $costume.chairLights)
        }, altContent: {
            LightStripEffectChooserView(lights: $costume.chairLightsAlt)
        })
    }
}

struct ChairLightsView_Previews: PreviewProvider {
    static var previews: some View {
        ChairLightsView(costume: CostumeModelView())
    }
}
