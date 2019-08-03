//
//  Operator.swift
//  Brainfuck
//
//  Created by Ma Linghao on 1/8/19.
//  Copyright © 2019 PointerFLY. All rights reserved.
//

import Cocoa

enum Token: Character {
    case left = "<"
    case right = ">"
    case increase = "+"
    case decrease = "-"
    case loopStart = "["
    case loopEnd = "]"
    case input = ","
    case output = "."
}
