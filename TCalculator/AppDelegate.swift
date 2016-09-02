//
//  AppDelegate.swift
//  TCalculator
//
//  Created by Dominic Beger on 24.08.16.
//  Copyright © 2016 Dominic Beger. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainWindowController: TCMainWindowController!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Add system theme change listener
        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.systemThemeChanged(_:)), name: "AppleInterfaceThemeChangedNotification", object: nil)
        
        TCTokenActions.initConstantActions()
        TCTokenActions.initFunctionActions()
        TCTokenActions.initOperatorActions()
        
        mainWindowController = TCMainWindowController(windowNibName: "TCMainWindow")
        mainWindowController.showWindow(nil)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func systemThemeChanged(notification: NSNotification) {
        // If the user changes their system's color scheme, we'll know
        let systemAppearanceName = (NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light").lowercaseString
        let systemAppearance = systemAppearanceName == "dark" ? NSAppearance(named: NSAppearanceNameVibrantDark) : NSAppearance(named: NSAppearanceNameVibrantLight)
        
        if mainWindowController.window != nil && mainWindowController.window!.visible {
            mainWindowController.window?.appearance = systemAppearance
        }
    }
}

