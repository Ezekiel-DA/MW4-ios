//
//  DetailsView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 10/25/22.
//

import SwiftUI

struct DetailsView<Content>: View where Content: View {
    @ObservedObject var costume: CostumeModelView
    
    @ViewBuilder let defaultContent: Content
    @ViewBuilder let altContent: Content
    
    var body: some View {
        VStack {
            CostumePreviewView(costume: costume)
            
            Form {
                Section(content: {
                    defaultContent
                }, header: {
                    Text("Default").fontWeight(.heavy)
                })

                Section(content: {
                    altContent
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

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(costume: CostumeModelView(), defaultContent: {Text("contents of default section")}, altContent: {Text("contents of alt section")})
    }
}
