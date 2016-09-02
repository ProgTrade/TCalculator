//
//  Parser.swift
//  TCalculator
//
//  Created by Dominic Beger on 24.08.16.
//  Copyright © 2016 Dominic Beger. All rights reserved.
//

import Foundation

class TCParser {
    
    var parserTerm: NSString!
    
    init(term: NSString) {
        parserTerm = term
    }
    
    func evaluate() throws -> Double {
        
        guard let term = parserTerm where term.length != 0 else {
            print("\"parserTerm\" is nil or empty.")
            return Double.NaN
        }
        
        var resultStack = Stack<Double>()
        var infixTokens: [TCToken]!
        do {
            infixTokens = try TCToken.createInfixTokens(term as String)
        }
        catch let error as NSError {
            throw error
        }
        
        var postfixTokens: [TCToken]!
        do {
            postfixTokens = try TCToken.shuntingYard(infixTokens)
        }
        catch let error as NSError {
            throw error
        }
        
        for pToken in postfixTokens {
            pToken.evaluate(&resultStack)
        }
        
        return resultStack.pop()!
    }
}