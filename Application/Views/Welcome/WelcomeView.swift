//
//  WelcomeView.swift
//  nemosprite
//
//  Created by Daniel Fortes on 28/06/23.
//

import SwiftUI

struct WelcomeView: View {
    
    var urls: [String] = ["Some File"]
    var controller: WelcomeViewController? = nil
    
    var body: some View {
        VStack {
            List {
                ForEach(urls, id: \.self) {
                    Text("\($0)")
                }
            }
            .scaledToFill()
            
            Spacer()
            
            Button("New Sprite") {
                if let vc = self.controller {
                    vc.newSpriteButtonHandler()
                }
            }
        }
        .padding()
        .frame(width: 200, height: 100)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
