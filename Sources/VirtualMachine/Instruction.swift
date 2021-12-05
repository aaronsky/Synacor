//
//  Instruction.swift
//  
//
//  Created by Aaron Sky on 12/4/21.
//

struct Instruction {
    var code: Opcode

    var arguments: [UInt16] = []

    var a: Int {
        Int(arguments[0])
    }

    var b: UInt16 {
        arguments[1]
    }

    var c: UInt16 {
        arguments[2]
    }

    var stride: Int {
        1 + arguments.count
    }

    init?(pc: Int, memory: [UInt16], registers: Registers) {
        guard let code = Opcode(rawValue: memory[pc]) else {
            return nil
        }

        self.code = code

        defer {
            precondition(arguments.count == code.argumentCount)
        }

        guard code.argumentCount > 0 else {
            return
        }

        let a: UInt16

        switch code {
        case .push, .jump, .jumpIfTrue, .jumpIfFalse, .call, .writeMemory, .output:
            a = argument(at: pc + 1,
                         memory: memory,
                         registers: registers)
        default:
            a = memory[pc + 1] - 32768
        }

        arguments.append(a)

        guard code.argumentCount >= 2 else {
            return
        }

        for offset in 2...code.argumentCount {
            arguments.append(
                argument(at: pc + offset,
                         memory: memory,
                         registers: registers)
            )
        }
    }

    private func argument(at pointer: Int, memory: [UInt16], registers: Registers) -> UInt16 {
        let value = memory[pointer]
        switch value {
        case 0..<32768:
            return value
        case 32768..<32776:
            return registers[Int(value - 32768)]
        default:
            preconditionFailure("invalid number \(value)")
        }
    }
}
