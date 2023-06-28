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
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if let editorView = self.view as? EditorView {
            self.editorView = editorView
        } else {
            fatalError("missing view!")
        }
        
        self.editorView.controller = self
        self.nemoEditorWindow = NemoEditorWindow(view: self.editorView)
        
//        self.nemoEditorWindow = NemoEditorWindow() {
//            return self.editorView.currentDrawable
//        } currentRenderPassDescriptorCallback: {
//            return self.editorView.currentRenderPassDescriptor
//        }
        
        nemoInit(self.nemoEditorWindow.innerPtr())
    }
    
    override func viewDidAppear() {
        self.view.window?.acceptsMouseMovedEvents = true
    }
    
    override var representedObject: Any? {
        didSet {
            
        }
    }
}
