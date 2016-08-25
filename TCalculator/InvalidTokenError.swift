//
//  InvalidTokenError.swift
//  TCalculator
//
//  Created by Dominic Beger on 24.08.16.
//  Copyright © 2016 Dominic Beger. All rights reserved.
//

import Foundation

enum InvalidTokenError: ErrorType {
    case TokenValueNotMatchingType
    case TokenIsUnknownOperator
    case TokenTypeNotFound(readToken: String)
    case TokenIsNotValidNumber(token: String)
}