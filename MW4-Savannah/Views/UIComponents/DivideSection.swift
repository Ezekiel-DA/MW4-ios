//
//  DivideSection.swift
//  MW4-Savannah
//
//  Created by LI Yun on 10/3/22.
//

import SwiftUI

struct DivideSection: View {
    let isButtonSection: Bool
    let buttonDescription: String
    @State private var isOn: Bool = true
    
    var body: some View {
            if (isButtonSection) {
                Toggle(isOn: $isOn) { Text("Button Trigger").fontWeight(.heavy) }
                Text(buttonDescription)
                    .padding(.bottom)
            }
            else{
                Text("Default Status").fontWeight(.heavy)
                Text(buttonDescription)
            }
        
  
    }
}

struct DivideSection_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            DivideSection(isButtonSection: false, buttonDescription: "The default status for the chair")
            Spacer()
            DivideSection(isButtonSection: true, buttonDescription: "Pulse desired color for 3s")
        }
          
        
      
    }
}
