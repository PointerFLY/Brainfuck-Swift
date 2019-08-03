//
//  main.swift
//  Brainfuck
//
//  Created by PointerFLY on 31/7/19.
//  Copyright © 2019 PointerFLY. All rights reserved.
//

import Foundation

let argc = CommandLine.argc
let arguments = CommandLine.arguments

if argc == 1 {
    runInteractively()
} else if argc == 2 {
    let path = arguments[1]
    var fileURL = URL(fileURLWithPath: path)
    // If it is a absolute path
    if path[path.startIndex] != "/" {
        let currentURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        fileURL = currentURL.appendingPathComponent(path)
    }
    
    if let data = try? Data(contentsOf: fileURL), let text = String(data: data, encoding: .utf8) {
        runByText(text)
    } else {
        printError("failed to read file \(path)")
        exit(EXIT_FAILURE)
    }
} else if argc >= 2 {
    switch arguments[1] {
    case "-v", "--version":
        printVersion()
    case "-h", "--help":
        printHelp()
    case "-e":
        guard argc >= 3 else {
            printError("need to specify text to be evaluated")
            exit(EXIT_FAILURE)
        }
        runByText(arguments[2])
    case "-t", "--2swift":
        break
    default:
        printError("invalid option")
        exit(EXIT_FAILURE)
    }
}
