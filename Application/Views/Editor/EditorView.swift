//
//  EditorView.swift
//  nemosprite
//
//  Created by Daniel Fortes on 28/06/23.
//

import MetalKit

class EditorView : MTKView {
    
    var nemoEditorWindow = NemoEditorWindow()
    
    override var acceptsFirstResponder: Bool {
        true
    }
    
    override func mouseMoved(with event: NSEvent) {
        self.nemoEditorWindow.inner.mouse.x = event.locationInWindow.x
        self.nemoEditorWindow.inner.mouse.y = event.locationInWindow.y
        print("Mouse moved: (\(self.nemoEditorWindow.inner.mouse.x), \(self.nemoEditorWindow.inner.mouse.y)")
    }
    
    override func mouseDown(with event: NSEvent) {
        print("Mouse down: (\(event.locationInWindow.x), \(event.locationInWindow.y)")
    }
}
