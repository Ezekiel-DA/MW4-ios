//
//  PedestalLightsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct PedestalLightsView: View {
    @ObservedObject var costume: CostumeModelView
    
    var body: some View {
        DetailsView(costume: costume, defaultContent: {
            LightStripEffectChooserView(lights: $costume.pedestalLights)
        }, altContent: {
            LightStripEffectChooserView(lights: $costume.pedestalLightsAlt)
        })
    }
}

struct PedestalLightsView_Previews: PreviewProvider {
    static var previews: some View {
        PedestalLightsView(costume: CostumeModelView())
    }
}
