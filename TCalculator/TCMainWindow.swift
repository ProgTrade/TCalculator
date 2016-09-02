//
//  TCMainWindow.swift
//  TCalculator
//
//  Created by Dominic Beger on 02.09.16.
//  Copyright © 2016 Dominic Beger. All rights reserved.
//

import Cocoa
import Foundation

class TCMainWindow: NSWindow, NSWindowDelegate {
    
    func initialize() {
        self.delegate = self
    }
    
    func windowWillShow() {
        if !self.visible {
            let systemAppearanceName = (NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light").lowercaseString
            let systemAppearance = systemAppearanceName == "dark" ? NSAppearance(named: NSAppearanceNameVibrantDark) : NSAppearance(named: NSAppearanceNameVibrantLight)
            self.appearance = systemAppearance
        }
    }
    
    @IBOutlet weak var resultLabel: NSTextField!
    @IBOutlet weak var termTextField: NSTextField!
    @IBAction func evaluateButtonPressed(sender: AnyObject) {
        let parser = TCParser(term: termTextField.stringValue)
        do {
            resultLabel.stringValue = try parser.evaluate().description
        }
        catch let error as NSError {
            Swift.print(error)
            resultLabel.stringValue = "Parse Error"
        }
    }
}