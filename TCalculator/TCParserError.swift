//
//  ParserError.swift
//  TCalculator
//
//  Created by Dominic Beger on 02.09.16.
//  Copyright © 2016 Dominic Beger. All rights reserved.
//

import Foundation

enum TCParserError: ErrorType {
    case NumberNotFollowedByOperatorOrClosingBracket
    case ClosingBracketNotFollowedByOperatorOrClosingBracket
}