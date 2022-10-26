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
        VStack {
            CostumePreviewView(costume: costume)
            
            Form {
                Section(content: {
                    LightStripEffectChooserView(lights: $costume.chairLights)
                }, header: {
                    Text("Default").fontWeight(.heavy)
                })
                
                Section(content: {
                    LightStripEffectChooserView(lights: $costume.chairLightsAlt)
                }, header: {
                    HStack {
                        Text("On button press").fontWeight(.heavy)
                        Text("(for 60 seconds)").fontWeight(.regular)
                    }
                })
            }
        }
    }
}

struct ChairLightsView_Previews: PreviewProvider {
    static var previews: some View {
        ChairLightsView(costume: CostumeModelView())
    }
}
