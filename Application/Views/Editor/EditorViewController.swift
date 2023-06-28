//
//  EditorViewController.swift
//  nemosprite
//
//  Created by Daniel Fortes on 28/06/23.
//

import AppKit

class EditorViewController : NSViewController {
    
    var editorView: EditorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let editorView = self.view as? EditorView {
            self.editorView = editorView
        } else {
            fatalError("missing view!")
        }
        
        nemoInit(self.editorView.nemoEditorWindow.innerPtr())
    }
    
//    override func viewDidAppear() {
//        self.view.window?.acceptsMouseMovedEvents = true
//    }
    
    override var representedObject: Any? {
        didSet {
            
        }
    }
}
