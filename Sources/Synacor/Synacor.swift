//
//  Synacor.swift
//  
//
//  Created by Aaron Sky on 12/4/21.
//

import ArgumentParser
import Foundation
import VirtualMachine

@main
struct Synacor: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A command to run Synacor games",
        subcommands: [
            Play.self,
            Disassemble.self,
            Teleporter.self
        ],
        defaultSubcommand: Play.self
    )
}

extension Synacor {
    struct Play: ParsableCommand {
        @Argument(help: "Path to the challenge binary.")
        var path: URL

        func run() throws {
            var vm = try VirtualMachine(contentsOf: path)
            vm.memory[0x0209] = 8
            vm.memory[0x156D] = 6
            vm.memory[0x1571] = 21
            vm.memory[0x1572] = 21
            vm.registers.h = 25734

            var buffer: [UInt8] = []

        runloop:
            while true {
                switch try vm.run() {
                case .halted:
                    break runloop
                case .waitingForInput:
                    write(&buffer)
                    guard let input = readLine(strippingNewline: false) else {
                        continue
                    }
                    vm.sendInput(input)
                case .output(let o):
                    buffer.append(UInt8(o))
                }
            }

            write(&buffer)
        }

        func write(_ buffer: inout [UInt8]) {
            guard let output = String(bytes: buffer, encoding: .utf8) else {
                return
            }
            print(output)
            buffer.removeAll()
        }
    }
}

extension Synacor {
    struct Disassemble: ParsableCommand {
        @Argument(help: "Path to the challenge binary.")
        var path: URL

        func run() throws {
            let vm = try VirtualMachine(contentsOf: path)

            var pc = 0

            while pc < vm.memory.count {
                guard let code = Opcode(rawValue: UInt16(vm.memory[pc])) else {
                    pc += 1
                    continue
                }

                let arguments: String
                if code.argumentCount >= 1 {
                    arguments = (1..<code.argumentCount)
                        .map {
                            let v = vm.memory[pc + $0]
                            switch v {
                            case 0..<32768:
                                return "\(v)"
                            case 32768..<32776:
                                return "\(v - 32768)"
                            default:
                                fatalError()
                            }
                        }
                        .joined(separator: " ")
                } else {
                    arguments = ""
                }

                print("\(String(format: "0x%06X", pc)): \(code.debugDescription) \(arguments)")

                pc += 1 + code.argumentCount
            }
        }
    }
}

extension Synacor {
    struct Teleporter: ParsableCommand {}
}

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        if let url = URL(string: argument), url.scheme != nil {
            self.init(string: argument)
        } else {
            // Assuming it is a file url.
            self.init(fileURLWithPath: argument)
        }
    }
}
