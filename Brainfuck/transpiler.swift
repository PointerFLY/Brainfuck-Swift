//
//  transpiler.swift
//  brainfuck
//
//  Created by PointerFLY on 3/8/19.
//  Copyright © 2019 PointerFLY. All rights reserved.
//

import Foundation

func transpile(sourcePath: String, targetPath: String) {
    let url = urlFromPath(sourcePath)
    guard let data = try? Data(contentsOf: url), let text = String(data: data, encoding: .utf8) else {
        printError("failed to read file \(sourcePath)")
        exit(EXIT_FAILURE)
    }
    
    var swiftText =
    """
    import Foundation

    var tape = [UInt8](repeating: 0, count: 1000 * 1000)
    var pointer: Int = 0\n
    """
    
    var i = 0;
    while i < text.count {
        defer { i += 1 }
        
        let char = text[text.index(text.startIndex, offsetBy: i)]
        guard let token = Token(rawValue: char) else { continue }
        var statement = ""
        
        switch token {
        case .left:
            statement = "pointer -= 1\n"
        case .right:
            statement = "pointer += 1\n"
        case .increase:
            statement = "tape[pointer] += 1\n"
        case .decrease:
            statement = "tape[pointer] -= 1\n"
        case .loopStart:
            statement = "while tape[pointer] != 0 {\n"
        case .loopEnd:
            statement = "}\n"
        case .input:
            statement =
            """
            FileHandle.standardInput.readData(ofLength: 1)
            let data = FileHandle.standardInput.readData(ofLength: 1)
            let char = String(data: data, encoding: .ascii)!.first!
            tape[pointer] = char.asciiValue!\n
            """
        case .output:
            statement =
            """
            print(String(Character(UnicodeScalar(tape[pointer]))), terminator: "")\n
            """
        }
        
        swiftText.append(contentsOf: statement)
    }
    
    try! swiftText.write(to: urlFromPath(targetPath), atomically: false, encoding: .utf8)
}
