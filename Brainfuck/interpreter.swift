//
//  ArgParser.swift
//  brainfuck
//
//  Created by PointerFLY on 3/8/19.
//  Copyright © 2019 PointerFLY. All rights reserved.
//

import Foundation

func runByText(_ text: String) {
    var tape = [UInt8](repeating: 0, count: 1000 * 1000)
    var pointer: Int = 0
    var loopStack = [Int]()
    
    var i = 0;
    while i < text.count {
        defer { i += 1 }
        
        let char = text[text.index(text.startIndex, offsetBy: i)]
        guard let token = Token(rawValue: char) else { continue }
        
        switch token {
        case .left:
            pointer -= 1
            checkTapePointer(tape: &tape, pointer: pointer)
        case .right:
            pointer += 1
            checkTapePointer(tape: &tape, pointer: pointer)
        case .increase:
            tape[pointer] += 1
        case .decrease:
            tape[pointer] -= 1
        case .loopStart:
            loopStack.append(i)
        case .loopEnd:
            guard let startIndex = loopStack.popLast() else {
                printError("illegal ] end without [")
                exit(EXIT_FAILURE)
            }
            
            if tape[pointer] != 0 {
                i = startIndex - 1
            }
        case .input:
            let data = FileHandle.standardInput.readData(ofLength: 1)
            guard let value = String(data: data, encoding: .ascii)?.first?.asciiValue else {
                printError("only ascii code is supported")
                exit(EXIT_FAILURE)
            }
            tape[pointer] = value
        case .output:
            let char = Character(UnicodeScalar(tape[pointer]))
            print(String(char), terminator: "")
        }
    }
}

func runInteractively() {
    var tape = [UInt8](repeating: 0, count: 1000 * 1000)
    var pointer: Int = 0
    var loopStack = [Int]()
    var tokens = [Token]()
    var index = 0
    
    while (true) {
        var token: Token
        if index < tokens.count { // Still in the loop
            token = tokens[index]
        } else {
            let data = FileHandle.standardInput.readData(ofLength: 1)
            guard let char = String(data: data, encoding: .ascii)?.first else { continue }
            guard let t = Token(rawValue: char) else { continue }
            token = t
            tokens.append(token)
        }

        switch token {
        case .left:
            pointer -= 1
            checkTapePointer(tape: &tape, pointer: pointer)
        case .right:
            pointer += 1
            checkTapePointer(tape: &tape, pointer: pointer)
        case .increase:
            tape[pointer] += 1
        case .decrease:
            tape[pointer] -= 1
        case .loopStart:
            loopStack.append(index)
        case .loopEnd:
            guard let startIndex = loopStack.popLast() else {
                printError("illegal ] end without [")
                exit(EXIT_FAILURE)
            }
            
            if tape[pointer] != 0 {
                index = startIndex - 1
            }
        case .input:
            let data = FileHandle.standardInput.readData(ofLength: 1)
            guard let value = String(data: data, encoding: .ascii)?.first?.asciiValue else {
                printError("only ascii code is supported")
                exit(EXIT_FAILURE)
            }
            tape[pointer] = value
        case .output:
            let char = Character(UnicodeScalar(tape[pointer]))
            print(String(char), terminator: "")
        }
        
        index += 1
    }
}

private func checkTapePointer(tape: inout [UInt8], pointer: Int) {
    if pointer < 0 {
        printError("tape pointer out of boundary")
    } else if pointer >= tape.count {
        var newTape = [UInt8](repeating: 0, count: tape.count * 2)
        newTape.insert(contentsOf: tape, at: 0)
        tape = newTape
    }
}
