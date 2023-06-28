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
    
    var mouse: nemo_NemoEditorWindow.__Unnamed_struct_mouse {
        get {
            self.inner.mouse
        }
        
        set {
            self.inner.mouse = newValue
        }
    }
    
    var currentDrawable: MTLDrawable {
        get {
            return self.inner.current_drawable.bindMemory(to: MTLDrawable.self, capacity: 1).pointee
        }
        set {
            withUnsafePointer(to: newValue) { ptr in
                var rawPtr = UnsafeRawPointer(ptr)
                self.inner.current_drawable = rawPtr
            }
        }
    }
    
    var currentRenderPassDescriptor: MTLRenderPassDescriptor {
        get {
            return self.inner.current_render_pass_descriptor.bindMemory(to: MTLRenderPassDescriptor.self, capacity: 1).pointee
        }
        set {
            withUnsafePointer(to: newValue) { ptr in
                var rawPtr = UnsafeRawPointer(ptr)
                self.inner.current_render_pass_descriptor = rawPtr
            }
        }
    }
    
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
    
    init() {
        self.inner = nemo_NemoEditorWindow()
        self.inner.mouse.x = 100
        self.inner.mouse.y = 200
    }
}

extension NemoEditorWindow {
    public func innerPtr() -> UnsafeMutablePointer<nemo_NemoEditorWindow> {
        withUnsafeMutablePointer(to: &self.inner) { ptr in
            return ptr
        }
    }
}
