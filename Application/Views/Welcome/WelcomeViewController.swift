//
//  WelcomeViewController.swift
//  nemosprite
//
//  Created by Daniel Fortes on 28/06/23.
//

import AppKit
import SwiftUI

class WelcomeViewController : NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let urls = NSDocumentController.shared.recentDocumentURLs.map { url in
            url.pathComponents.last!
        }
        
        
        let view = NSHostingView(rootView: WelcomeView(urls: urls, controller: self))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(view)
        view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    public func newSpriteButtonHandler() {
        print("new sprite!")
        NSDocumentController.shared.newDocument(self)
        self.view.window?.close()
    }
}
