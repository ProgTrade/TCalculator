//
//  TCGenericToken.swift
//  TCalculator
//
//  Created by Dominic Beger on 24.08.16.
//  Copyright © 2016 Dominic Beger. All rights reserved.
//

import Foundation

class TCGenericToken<T>: TCToken, CustomStringConvertible {
    
    var value: T!
    var priority: Int!
    var isRightAssociative: Bool!
    var description: String { return "\(value)" }
    
    init(value: T, type: TCTokenType) throws {
        
        self.value = value
        switch type {
            
        case TCTokenType.Number,
             TCTokenType.Constant:
            self.priority = 100
            
        case TCTokenType.Operator:
            if let operatorValue = value as? String {
                switch operatorValue {
                case "+":
                    self.priority = 1
                    self.isRightAssociative = false
                case "-":
                    self.priority = 1
                    self.isRightAssociative = false
                case "*":
                    self.priority = 2
                    self.isRightAssociative = false
                case "/":
                    self.priority = 2
                    self.isRightAssociative = false
                case "%":
                    self.priority = 3
                    self.isRightAssociative = false
                case "!":
                    self.priority = 4
                    self.isRightAssociative = false
                case "^":
                    self.priority = 5
                    self.isRightAssociative = true
                default:
                    throw InvalidTokenError.TokenIsUnknownOperator
                }
            }
            else {
                throw InvalidTokenError.TokenValueNotMatchingType
            }
            
        default: break // Bracket or other token types are not important with regard to priorities or associativity as they're handled differently
            
        }
        
        super.init(type: type)
    }
    
    
}