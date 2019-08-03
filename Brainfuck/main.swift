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
} else if argc >= 3 {
    switch arguments[1] {
    case "-v", "--version":
        printVersion()
    case "-h", "--help":
        printHelp()
    case "-e":
        runByText(arguments[2])
    case "-t":
        guard argc >= 4 else {
            printError("target file path if missing")
            exit(EXIT_FAILURE)
        }
        transpile(sourcePath: arguments[2], targetPath: arguments[3])
    default:
        printError("invalid option")
        exit(EXIT_FAILURE)
    }
}
