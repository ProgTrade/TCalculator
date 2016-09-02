//
//  TCMainWindowController.swift
//  TCalculator
//
//  Created by Dominic Beger on 02.09.16.
//  Copyright © 2016 Dominic Beger. All rights reserved.
//

import Cocoa
import Foundation

class TCMainWindowController: NSWindowController {
    
    var mainWindow: TCMainWindow { return self.window as! TCMainWindow }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.mainWindow.initialize()
    }
    
    override func showWindow(sender: AnyObject?) {
        self.mainWindow.windowWillShow()
        super.showWindow(sender)
    }
}