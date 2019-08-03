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
    let relativePath = arguments[2]
    let currentURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let fileURL = currentURL.appendingPathComponent(relativePath)
    if let data = try? Data(contentsOf: fileURL), let text = String(data: data, encoding: .utf8) {
        runByText(text)
    } else {
        printError("failed to read file \(relativePath)")
        exit(EXIT_FAILURE)
    }
} else if argc >= 2 {
    switch arguments[1] {
    case "-v", "--version":
        printVersion()
    case "-e":
        guard argc >= 3 else {
            printError("need to specify text to be evaluated")
            exit(EXIT_FAILURE)
        }
        runByText(arguments[2])
    case "-t", "--2swift":
        break
    case "-h", "--help":
        printHelp()
    default:
        printError("invalid option")
        exit(EXIT_FAILURE)
    }
}
