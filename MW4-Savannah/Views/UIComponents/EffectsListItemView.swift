//
//  EffectsListItemView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct EffectsListItemView: View {
    let text: String
    let effectDescriptionText: String
    let editDestination: AnyView
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill").resizable().frame(width: 8, height: 8)
            Text(text)
                .fontWeight(.bold)
            Spacer()
//            Text("[\(effectDescriptionText)]")
//                .fontWeight(.light)
            ZStack {
                Circle().frame(width: 24, height: 24).foregroundColor(Color(.systemCyan)).opacity(0.2)
                NavigationLink(destination: editDestination, label: {
                    Image(systemName: "pencil")
                })
            }
        }
        .padding(.horizontal)
    }
}

struct EffectsListItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EffectsListItemView(text: "Chair Lights", effectDescriptionText: "Red", editDestination: AnyView(Text("Dummy")))
            EffectsListItemView(text: "Pedestal Lights", effectDescriptionText: "Red, Pulse", editDestination: AnyView(Text("Dummy")))
            EffectsListItemView(text: "Text Effects", effectDescriptionText: "ON", editDestination: AnyView(Text("Dummy")))
            EffectsListItemView(text: "Audio", effectDescriptionText: "OFF", editDestination: AnyView(Text("Dummy")))
        }
    }
}
