//
//  PreviewButtonView.swift
//  MW4-Savannah
//
//  Created by Nicolas LEFEBVRE on 9/6/22.
//

import SwiftUI

struct PreviewButtonView: View {
    let action: () -> Void
    
    var body: some View {
        VStack {
            Button(action: action) {
                ZStack {
                    Circle().frame(width: 62, height: 62).foregroundColor(Color(.black))
                    Circle().frame(width: 60, height: 60).foregroundColor(Color(.systemCyan))
                    Image("buttonImage").resizable().frame(width: 65, height: 65)
                }
            }
            Text("Preview effects")
        }
    }
}

struct PreviewButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewButtonView(action: {})
    }
}
