//
//  VirtualMachine.swift
//  
//
//  Created by Aaron Sky on 12/4/21.
//

import Algorithms
import Foundation
import DequeModule

public struct VirtualMachine {
    public enum ExitCode: Equatable {
        case halted
        case waitingForInput
        case output(UInt16)
    }
    
    public enum Error: Swift.Error {
        case poppedEmptyStack
    }
    
    public var memory: [UInt16] = Array(repeating: 0, count: 32768)
    public var registers = Registers()
    var stack: [UInt16] = []
    var input: Deque<UInt8> = []
    var programCounter: Int = 0
    
    public init(contentsOf url: URL) throws {
        let image = try Data(contentsOf: url)
        let program = image
            .chunks(ofCount: 2)
            .map { chunk in
                chunk.withUnsafeBytes { pointer in
                    pointer.load(as: UInt16.self)
                }
            }
        self.init(program: program)
    }
    
    init(program: [UInt16]) {
        memory = program
    }
    
    public mutating func run() throws -> ExitCode {
        while true {
            guard let instruction = Instruction(pc: programCounter,
                                                memory: memory,
                                                registers: registers)
            else {
                throw Opcode.Error.invalid(memory[programCounter])
            }
            
            var exit: ExitCode?
            var jumped = false
            
            switch instruction.code {
            case .halt:
                exit = .halted
            case .set:
                registers[instruction.a] = instruction.b
            case .push:
                stack.append(UInt16(instruction.a))
            case .pop:
                guard let popValue = stack.popLast() else {
                    throw Error.poppedEmptyStack
                }
                registers[instruction.a] = popValue
            case .equals:
                registers[instruction.a] = (instruction.b == instruction.c) ? 1 : 0
            case .greaterThan:
                registers[instruction.a] = (instruction.b > instruction.c) ? 1 : 0
            case .jump:
                programCounter = Int(instruction.a)
                jumped = true
            case .jumpIfTrue:
                if instruction.a != 0 {
                    programCounter = Int(instruction.b)
                    jumped = true
                }
            case .jumpIfFalse:
                if instruction.a == 0 {
                    programCounter = Int(instruction.b)
                    jumped = true
                }
            case .add:
                registers[instruction.a] = UInt16((Int(instruction.b) + Int(instruction.c)) % 32768)
            case .multiply:
                registers[instruction.a] = UInt16((Int(instruction.b) * Int(instruction.c)) % 32768)
            case .modulo:
                registers[instruction.a] = instruction.b % instruction.c
            case .bitwiseAnd:
                registers[instruction.a] = instruction.b & instruction.c
            case .bitwiseOr:
                registers[instruction.a] = instruction.b | instruction.c
            case .bitwiseNot:
                registers[instruction.a] = ~instruction.b & 0x7FFF
            case .readMemory:
                registers[instruction.a] = memory[Int(instruction.b)]
            case .writeMemory:
                memory[instruction.a] = instruction.b
            case .call:
                stack.append(UInt16(programCounter + instruction.stride))
                programCounter = Int(instruction.a)
                jumped = true
            case .return:
                guard let retValue = stack.popLast() else {
                    exit = .halted
                    break
                }
                programCounter = Int(retValue)
                jumped = true
            case .output:
                exit = .output(UInt16(instruction.a))
            case .input:
                guard let input = self.input.popFirst() else {
                    return .waitingForInput // return without storing exit here so we don't update programCounter
                }
                registers[instruction.a] = UInt16(input)
            case .noop:
                break
            }
            
            programCounter += jumped ? 0 : instruction.stride
            if let exit = exit {
                return exit
            }
        }
    }
    
    public mutating func sendInput(_ input: String) {
        self.input.append(contentsOf: Array(input.utf8))
    }
}
