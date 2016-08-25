//
//  Extensions.swift
//  TCalculator
//
//  Created by Dominic Beger on 24.08.16.
//  Copyright © 2016 Dominic Beger. All rights reserved.
//

import Foundation

extension String {
    // At least Swift has extension properties. But the fact that it's necessary to create a custom property for a String-length is indeed creepy.
    var length: Int { return characters.count }
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i])
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
    
    func isLetter() -> Bool {
        guard self.length == 1 else {
            return false
        }
        
        let letters = NSCharacterSet.letterCharacterSet()
        let range = self.rangeOfCharacterFromSet(letters)
        return range?.count > 0
    }
    
    func isDigit() -> Bool {
        guard self.length == 1 else {
            return false
        }
        
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        let range = self.rangeOfCharacterFromSet(digits)
        return range?.count > 0
    }
    
    func isMathematicOperator() -> Bool {
        guard self.length == 1 else {
            return false
        }
        
        return "+-*/%^!".containsString(self)
    }
    
    func isBracket() -> Bool {
        guard self.length == 1 else {
            return false
        }
        
        return "()".containsString(self)
    }
    
    func replace(index: Int, _ newChar: Character) -> String {
        var chars = Array(self.characters)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
}

extension Dictionary {
    func containsKey(key: Key) -> Bool {
        return self[key] != nil
    }
}