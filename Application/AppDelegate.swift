//
//  AppDelegate.swift
//  nemosprite
//
//  Created by Daniel Fortes on 28/06/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    
        let storyboard = NSStoryboard(name: "WelcomeWindow", bundle: nil)
        let wc: NSWindowController = storyboard.instantiateInitialController()!
        wc.showWindow(self)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return false
    }
    
    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return false
    }
}

