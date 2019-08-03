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
        usage: brainfuck [-evh] [file...]
                -e                              run code directly
                -v --version                    show version information
                -h --help                       show a help message
                -t <source_path> <target_path>  transfer to swift
        """
    )
}

func printError(_ text: String) {
    if let data = ("error: " + text).data(using: .utf8) {
        FileHandle.standardError.write(data)
    }
}
