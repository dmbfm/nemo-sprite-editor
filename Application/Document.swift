//
//  Document.swift
//  nemosprite
//
//  Created by Daniel Fortes on 28/06/23.
//

import Cocoa

class Document: NSDocument {

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("EditorWindow"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("EditorWindowController")) as! NSWindowController
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        return "NEMO".data(using: .utf8)!
    }

    override func read(from data: Data, ofType typeName: String) throws {
    }
}

