//
//  TokenProcessor.swift
//  TCalculator
//
//  Created by Dominic Beger on 02.09.16.
//  Copyright © 2016 Dominic Beger. All rights reserved.
//

import Foundation

class TCTokenActions {
    
    static let π = M_PI
    static let 𝑒 = M_E
    typealias StackAction = (inout Stack<Double>) -> Void
    
    static var constantActions: [String: StackAction] = [String: StackAction]()
    static var functionActions: [String: StackAction] = [String: StackAction]()
    static var operatorActions: [String: StackAction] = [String: StackAction]()
    
    static func initConstantActions() {
        constantActions["e"] = { (s) in s.push(𝑒) }
        constantActions["pi"] = { (s) in s.push(π) }
    }
    
    static func initFunctionActions() {
        functionActions["sin"] = { (s) in s.push(sin(s.pop()!)) }
        functionActions["cos"] = { (s) in s.push(cos(s.pop()!)) }
        functionActions["tan"] = { (s) in s.push(tan(s.pop()!)) }
        functionActions["asin"] = { (s) in s.push(asin(s.pop()!)) }
        functionActions["acos"] = { (s) in s.push(acos(s.pop()!)) }
        functionActions["atan"] = { (s) in s.push(atan(s.pop()!)) }
        functionActions["sqrt"] = { (s) in s.push(sqrt(s.pop()!)) }
        functionActions["abs"] = { (s) in s.push(abs(s.pop()!)) }
        functionActions["ln"] = { (s) in s.push(log(s.pop()!)) }
        functionActions["lg"] = { (s) in s.push(log10(s.pop()!)) }
        functionActions["log"] = { (s) in
            let exponent = s.pop()
            s.push(MathHelper.logC(exponent!, forBase: s.pop()!))
        }
    }
    
    static func initOperatorActions() {
        operatorActions["+"] = { (s) in s.push(s.pop()! + s.pop()!) }
        operatorActions["-"] = { (s) in
            let subtrahend = s.pop()
            s.push(s.pop()! - subtrahend!)
        }
        operatorActions["*"] = { (s) in s.push(s.pop()! * s.pop()!) }
        operatorActions["/"] = { (s) in
            let divisor = s.pop()
            s.push(s.pop()! / divisor!)
        }
        operatorActions["!"] = { (s) in s.push(-s.pop()!) }
        operatorActions["^"] = { (s) in
            let exponent = s.pop()
            s.push(pow(s.pop()!, exponent!))
        }
    }
}