//
//  main.swift
//  Brainfuck
//
//  Created by PointerFLY on 31/7/19.
//  Copyright © 2019 PointerFLY. All rights reserved.
//

import Foundation

let program = CommandLine.arguments[1]

var length = 1_000_000
var tape = [UInt8](repeating: 0, count: length)
var pointer: Int = 0
var loopStack = [Int]()


var i = 0;
while i < program.count {
    defer { i += 1 }
    
    let char = program[program.index(program.startIndex, offsetBy: i)]
    guard let token = Token(rawValue: char) else { continue }

    switch token {
    case .left:
        pointer -= 1
    case .right:
        pointer += 1
    case .increase:
        tape[pointer] += 1
    case .decrease:
        tape[pointer] -= 1
    case .loopStart:
        loopStack.append(i)
    case .loopEnd:
        let startIndex = loopStack.popLast()!
        if tape[pointer] != 0 {
            i = startIndex - 1
        }
    case .input:
        let data = FileHandle.standardInput.readData(ofLength: 1)
        let char = String(data: data, encoding: .ascii)!.first!
        tape[pointer] = char.asciiValue!
    case .output:
        let char = Character(UnicodeScalar(tape[pointer]))
        print(String(char), terminator: "")
    }
}
