//
//  CostumeView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

enum NavigationTargets: Int, CaseIterable {
    case ChairLights
    case PedestalLights
    case Text
    case Audio
    
    var title: String {
        switch self {
        case .ChairLights: return "Chair lights"
        case .PedestalLights: return "Pedestal lights"
        case .Text: return "Text effects"
        case .Audio: return "Audio"
        }
    }
    
    var effectDescription: String {
        switch self {
        case .ChairLights: return "Red"
        case .PedestalLights: return "White, Pulsing"
        case .Text: return "ON"
        case .Audio: return "OFF"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .ChairLights: ChairLightsView()
        case .PedestalLights: PedestalLightsView()
        case .Text: TextEffectsView()
        case .Audio: AudioView()
        }
    }
}

struct CostumeView: View {
    var body: some View {
        NavigationView {
            VStack {
                ForEach(NavigationTargets.allCases, id: \.rawValue) { item in
                    EffectsListItemView(
                        text: item.title,
                        effectDescriptionText: item.effectDescription,
                        editDestination: AnyView(item.view
                            .navigationTitle(item.title)
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar{
                                Button("Reset") {}
                            }

                        )
                    )
                        
                }
                Spacer()
                CostumeGraphicView(
                    chairLightColor: .white,
                    pedLightColor: .white,
                    isChairRainbow: false,
                    cRainbowAnime: 1, //0-none, 1-wave, 2-cycle
                    isPedRainbow: false,
                    pRainbowAnime: 1, //0-none, 1-wave, 2-cycle
                    txtDisplay: "MAGIC WHEELCHAIR",
                    txtColor: .white,
                    txtBgColor: .gray,
                    txtScroll: 0,
                    txtSpeed: 0.02)
                Spacer()
                PreviewButtonView(action: {} )
                    .padding(.bottom)
            }
            .navigationBarTitle("THE CHOICE")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitleFontStyle(.title1)
        }
    }
}

struct CostumeView_Previews: PreviewProvider {
    static var previews: some View {
        CostumeView()
    }
}
