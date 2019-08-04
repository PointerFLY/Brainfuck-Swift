//
//  manual.swift
//  brainfuck
//
//  Created by PointerFLY on 3/8/19.
//  Copyright © 2019 PointerFLY. All rights reserved.
//

import Foundation

func printVersion() {
    print("0.0.1")
}

func printHelp() {
    print(
        """
        usage: brainfuck [-evht] [file...]
                -h --help                       show a help message
                -v --version                    show version information
                <file_path>                     run code from file
                -e                              run code directly
                -t <source_path> <target_path>  transfer to swift
        """
    )
}

func printError(_ text: String) {
    if let data = ("error: " + text).data(using: .utf8) {
        FileHandle.standardError.write(data)
    }
}

func urlFromPath(_ path: String) -> URL {
    var fileURL = URL(fileURLWithPath: path)
    // If it is a absolute path
    if path[path.startIndex] != "/" {
        let currentURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        fileURL = currentURL.appendingPathComponent(path)
    }
    
    return fileURL
}
