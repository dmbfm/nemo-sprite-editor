//
//  NemoEditorWindow.swift
//  nemosprite
//
//  Created by Daniel Fortes on 28/06/23.
//

import Foundation
import MetalKit

class NemoEditorWindow {
    var inner: nemo_NemoEditorWindow
    var view: EditorView
    
    var clearColor: MTLClearColor {
        get {
            return MTLClearColorMake(
                self.inner.clear_color.r,
                self.inner.clear_color.g,
                self.inner.clear_color.b,
                self.inner.clear_color.a
            );
        }
    }
    
    init(view: EditorView) {
        self.inner = nemo_NemoEditorWindow()
        self.inner.mouse.x = 100
        self.inner.mouse.y = 200
        self.view = view
        
        withUnsafePointer(to: self) { ptr in
            let rawptr = UnsafeMutableRawPointer(mutating: ptr)
            self.inner.platform_data = rawptr
        }
        
        self.inner.current_render_pass_descriptor_callback =  { ptr in
            let _self = ptr?.bindMemory(to: NemoEditorWindow.self, capacity: 1).pointee
            if let view = _self?.view, let rpd = view.currentRenderPassDescriptor {
                return withUnsafePointer(to: rpd) { ptr in
                    UnsafeRawPointer(ptr)
                }
            }
            
            return nil
        }
        
        self.inner.current_drawable_callback = { ptr in
            let _self = ptr?.bindMemory(to: NemoEditorWindow.self, capacity: 1).pointee
            if let view = _self?.view, let rpd = view.currentDrawable {
                return withUnsafePointer(to: rpd) { ptr in
                    UnsafeRawPointer(ptr)
                }
            }
            
            return nil
        }
    }
    
}

extension NemoEditorWindow {
    public func innerPtr() -> UnsafeMutablePointer<nemo_NemoEditorWindow> {
        withUnsafeMutablePointer(to: &self.inner) { ptr in
            return ptr
        }
    }
}
