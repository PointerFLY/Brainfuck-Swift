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
    var skipLoopCounter: Int = 0
    
    var i = 0;
    while i < text.count {
        let char = text[text.index(text.startIndex, offsetBy: i)]
        guard let token = Token(rawValue: char) else {
            i += 1
            continue
        }
        
        guard skipLoopCounter == 0 else {
            if token == .loopStart {
                skipLoopCounter += 1
            } else if token == .loopEnd {
                skipLoopCounter -= 1
            }
            i += 1
            continue
        }
        
        switch token {
        case .left:
            pointer -= 1
            checkTapePointer(tape: &tape, pointer: pointer)
        case .right:
            pointer += 1
            checkTapePointer(tape: &tape, pointer: pointer)
        case .increase:
            tape[pointer] &+= 1
        case .decrease:
            tape[pointer] &-= 1
        case .loopStart:
            if tape[pointer] == 0 {
                skipLoopCounter = 1
            } else {
                loopStack.append(i)
            }
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
        
        i += 1
    }
}

func runInteractively() {
    var tape = [UInt8](repeating: 0, count: 1000 * 1000)
    var pointer: Int = 0
    var loopStack = [Int]()
    var tokens = [Token]()
    var i = 0
    var skipLoopCounter: Int = 0
    
    while (true) {
        var token: Token
        if i < tokens.count { // Still in the loop
            token = tokens[i]
        } else {
            let data = FileHandle.standardInput.readData(ofLength: 1)
            guard let char = String(data: data, encoding: .ascii)?.first else { continue }
            guard let t = Token(rawValue: char) else { continue }
            token = t
            tokens.append(token)
        }
        
        guard skipLoopCounter == 0 else {
            if token == .loopStart {
                skipLoopCounter += 1
            } else if token == .loopEnd {
                skipLoopCounter -= 1
            }
            i += 1
            continue
        }

        switch token {
        case .left:
            pointer -= 1
            checkTapePointer(tape: &tape, pointer: pointer)
        case .right:
            pointer += 1
            checkTapePointer(tape: &tape, pointer: pointer)
        case .increase:
            tape[pointer] &+= 1
        case .decrease:
            tape[pointer] &-= 1
        case .loopStart:
            if tape[pointer] == 0 {
                skipLoopCounter = 1
            } else {
                loopStack.append(i)
            }
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
        
        i += 1
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
