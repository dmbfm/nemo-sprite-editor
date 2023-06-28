//
//  EditorView.swift
//  nemosprite
//
//  Created by Daniel Fortes on 28/06/23.
//

import MetalKit

class EditorView : MTKView {
    
    var controller: EditorViewController?

    override var acceptsFirstResponder: Bool {
        true
    }
    
    override func mouseMoved(with event: NSEvent) {
        if let ctrl = self.controller {
            ctrl.nemoEditorWindow.inner.mouse.x = event.locationInWindow.x
            ctrl.nemoEditorWindow.inner.mouse.y = event.locationInWindow.y
            print("Mouse moved: \(ctrl.nemoEditorWindow.inner.mouse.x), \(ctrl.nemoEditorWindow.inner.mouse.y)")
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        print("Mouse down: (\(event.locationInWindow.x), \(event.locationInWindow.y)")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if let ctrl = self.controller {
            self.clearColor = ctrl.nemoEditorWindow.clearColor
            //nemoFrame(ctrl.nemoEditorWindow.innerPtr())
        }
    }
}
