//
//  EditorViewController.swift
//  nemosprite
//
//  Created by Daniel Fortes on 28/06/23.
//

import AppKit

class EditorViewController : NSViewController {
    
    var editorView: EditorView!
    var nemoEditorWindow: NemoEditorWindow!
    var nemoInstanceHandle: UInt64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if let editorView = self.view as? EditorView {
            self.editorView = editorView
        } else {
            fatalError("missing view!")
        }
        
        self.editorView.controller = self
        self.nemoEditorWindow = NemoEditorWindow(view: self.editorView)
    
        self.nemoInstanceHandle = nemoBackendCreateInstance(self.nemoEditorWindow.innerPtr())
        
        if (self.nemoInstanceHandle == 0) {
            fatalError("Failed to create NEMO instance!")
        }
        
    }
    
    deinit {
        if (self.nemoInstanceHandle != 0) {
            nemoBackendDestroyInstance(self.nemoInstanceHandle)
        }
    }
        
    override func viewDidAppear() {
        self.view.window?.acceptsMouseMovedEvents = true
    }
    
    override var representedObject: Any? {
        didSet {
            
        }
    }
}
