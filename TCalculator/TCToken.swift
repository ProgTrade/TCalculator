//
//  TCToken.swift
//  TCalculator
//
//  Created by Dominic Beger on 24.08.16.
//  Copyright © 2016 Dominic Beger. All rights reserved.
//

#if os(OSX) || os(iOS)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif
import Foundation

class TCToken {
    
    var type: TCTokenType!
    init(type: TCTokenType) {
        self.type = type
    }
    
    static func readNumberToken(input: String, inout index: Int) throws -> TCGenericToken<Double> {
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
    
    static func readStringToken(input: String, inout index: Int) throws -> TCGenericToken<String> {
        
        var newType: TCTokenType!
        var endIndex = index
        while (endIndex < input.length && (input[endIndex].isLetter() || input[endIndex].isMathematicOperator() || input[endIndex].isBracket())) {
            endIndex += 1
            
            let currentString: String = input[index...endIndex]
            // Last two conditions to parse e.g. "* sin(5)" correctly: As soon as the current token has finished, we should stop reading.
            if (TCTokenActions.functionActions.containsKey(currentString) || TCTokenActions.operatorActions.containsKey(currentString) || TCTokenActions.constantActions.containsKey(currentString) || currentString.isBracket()) {
                // This indicates that it has been found in the dictionary, so that is already it.
                break
            }
        }
        
        let stringToken: String = input[index...endIndex]
        if (TCTokenActions.functionActions.containsKey(stringToken)) {
            newType = TCTokenType.Function
        }
        else if (TCTokenActions.operatorActions.containsKey(stringToken)) {
            newType = TCTokenType.Operator
        }
        else if (stringToken.isBracket()) {
            newType = TCTokenType.Bracket
        }
        else if (TCTokenActions.constantActions.containsKey(stringToken)) {
            newType = TCTokenType.Constant
        }
        else {
            throw InvalidTokenError.TokenTypeNotFound(readToken: stringToken)
        }
        
        index = endIndex
        return try! TCGenericToken<String>(value: stringToken, type: newType)
    }
    
    func evaluate(inout tokenStack: Stack<Double>) throws {
        
        // Unwrapping it because Swift does not automatically do that for an implicitly unwrapped optional when using switch-case
        switch (self.type!) {
            
        case TCTokenType.Number:
            // The tokens coming from our tokenizer should be fine, but we need to check them, though.
            if let token = self as? TCGenericToken<Double> {
                tokenStack.push(token.value)
            }
        case TCTokenType.Function:
            if let token = self as? TCGenericToken<String> {
                if let action: (inout Stack<Double>) -> Void = TCTokenActions.functionActions[token.value] {
                    action(&tokenStack)
                }
            }
        case TCTokenType.Operator:
            if let token = self as? TCGenericToken<String> {
                if let action: (inout Stack<Double>) -> Void = TCTokenActions.operatorActions[token.value] {
                    action(&tokenStack)
                }
            }
        case TCTokenType.Constant:
            if let token = self as? TCGenericToken<String> {
                if let action: (inout Stack<Double>) -> Void = TCTokenActions.constantActions[token.value] {
                    action(&tokenStack)
                }
            }
            
        default:
            // wat
            print("Type is: \(self.type) and it could not be evaluated.")
        }
        
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
                
                infixTokens.append(try readStringToken(localTerm, index: &i)) // TODO: Check error handling
            }
            else if (current.isDigit()) { // Number
                infixTokens.append(try readNumberToken(localTerm, index: &i)) // TODO: Check error handling
            }
            else {
                throw InvalidTokenError.TokenTypeNotFound(readToken: current)
            }
        }
        
        return infixTokens
    }
}