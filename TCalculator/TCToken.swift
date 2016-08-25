//
//  TCToken.swift
//  TCalculator
//
//  Created by Dominic Beger on 24.08.16.
//  Copyright © 2016 Dominic Beger. All rights reserved.
//

import Foundation

class TCToken {
    
    // Value type is currently a placeholder.
    // TODO: Add a delegate for editing the stack as value of the dictionaries
    static let constantActions: [String: AnyObject] = [String: AnyObject]()
    static let functionActions: [String: AnyObject] = [String: AnyObject]()
    static let operatorActions: [String: AnyObject] = [String: AnyObject]()
    
    var type: TCTokenType!
    
    init(type: TCTokenType) {
        self.type = type
    }
    
    static func ReadNumberToken(input: String, inout index: Int) throws -> TCGenericToken<Double> {
        var endIndex = index
        while (endIndex < input.length && (input[endIndex].isDigit() || input[endIndex] == ".")) {
            endIndex += 1
        }
        
        let numberToken: String = input[index...endIndex]
        let numberValue = Double(numberToken)
        if let number = numberValue {
            index = endIndex
            return try! TCGenericToken<Double>(value: number, type: TCTokenType.Number)
        }
        else {
            throw InvalidTokenError.TokenIsNotValidNumber(token: numberToken)
        }
    }
    
    static func ReadStringToken(input: String, inout index: Int) throws -> TCGenericToken<String> {
        
        var newType: TCTokenType!
        var endIndex = index
        while (endIndex < input.length && (input[endIndex].isLetter() || input[endIndex].isMathematicOperator() || input[endIndex].isBracket())) {
            endIndex += 1
            
            let currentString: String = input[index...endIndex]
            // Last two conditions to parse e.g. "* sin(5)" correctly: As soon as the current token has finished, we should stop reading.
            if (functionActions.containsKey(currentString) || operatorActions.containsKey(currentString) || constantActions.containsKey(currentString) || currentString.isBracket()) {
                // This indicates that it has been found in the dictionary, so that is already it.
                break
            }
        }
        
        let stringToken: String = input[index...endIndex]
        if (functionActions.containsKey(stringToken)) {
            newType = TCTokenType.Function
        }
        else if (operatorActions.containsKey(stringToken)) {
            newType = TCTokenType.Operator
        }
        else if (stringToken.isBracket()) {
            newType = TCTokenType.Bracket
        }
        else if (constantActions.containsKey(stringToken)) {
            newType = TCTokenType.Constant
        }
        else {
            throw InvalidTokenError.TokenTypeNotFound(readToken: stringToken)
        }
        
        index = endIndex
        return try! TCGenericToken<String>(value: stringToken, type: newType)
    }
    
    static func createInfixTokens(term: String) throws -> [TCToken] {
        
        var localTerm = term
        let whiteSpaceRegEx: NSRegularExpression = try! NSRegularExpression(pattern: "\\s+", options: [.CaseInsensitive])
        whiteSpaceRegEx.replaceMatchesInString(NSMutableString(string: localTerm), options: [], range: NSMakeRange(0, term.length), withTemplate: "")
        
        var infixTokens = [TCToken]()
        var i = 0
        while (i < localTerm.length)
        {
            let current: String = localTerm[i]
            if (current.isLetter() || current.isMathematicOperator() || current.isBracket())
                // Functions/Operators/Constants
            {
                if ((current == "+" || current == "-") &&
                    (i == 0 ||
                        (infixTokens[infixTokens.count - 1].type == TCTokenType.Bracket &&
                            (infixTokens[infixTokens.count - 1] as! TCGenericToken<String>).value == "(")))
                    // Must be a sign and handled differently.
                {
                    if (current == "-") {
                        localTerm = localTerm.replace(i, "!")
                    }
                    else {
                        // Remove the '+' as it is redundant and disturbs our calculations
                        localTerm.removeAtIndex(localTerm.startIndex.advancedBy(i))
                    }
                }
                
                infixTokens.append(try ReadStringToken(localTerm, index: &i)) // TODO: Check error handling
            }
            else if (current.isDigit()) { // Number
                infixTokens.append(try ReadNumberToken(localTerm, index: &i)) // TODO: Check error handling
            }
            else {
                throw InvalidTokenError.TokenTypeNotFound(readToken: current)
            }
        }
        
        return infixTokens
    }
}