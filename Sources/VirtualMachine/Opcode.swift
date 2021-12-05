//
//  Opcode.swift
//  
//
//  Created by Aaron Sky on 12/4/21.
//

public enum Opcode: UInt16, CustomDebugStringConvertible {
    enum Error: Swift.Error {
        case invalid(UInt16)
    }
    
    case halt
    case `set`
    case push
    case pop
    case equals
    case greaterThan
    case jump
    case jumpIfTrue
    case jumpIfFalse
    case add
    case multiply
    case modulo
    case bitwiseAnd
    case bitwiseOr
    case bitwiseNot
    case readMemory
    case writeMemory
    case call
    case `return`
    case output
    case input
    case noop
    
    public var argumentCount: Int {
        switch self {
        case .halt, .return, .noop:
            return 0
        case .push, .pop, .jump, .call, .output, .input:
            return 1
        case .set, .jumpIfTrue, .jumpIfFalse, .bitwiseNot, .readMemory, .writeMemory:
            return 2
        case .equals, .greaterThan, .add, .multiply, .modulo, .bitwiseAnd, .bitwiseOr:
            return 3
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .halt:
            return "HALT"
        case .set:
            return "SET"
        case .push:
            return "PUSH"
        case .pop:
            return "POP"
        case .equals:
            return "EQ"
        case .greaterThan:
            return "GT"
        case .jump:
            return "JMP"
        case .jumpIfTrue:
            return "JT"
        case .jumpIfFalse:
            return "JF"
        case .add:
            return "ADD"
        case .multiply:
            return "MULT"
        case .modulo:
            return "MOD"
        case .bitwiseAnd:
            return "AND"
        case .bitwiseOr:
            return "OR"
        case .bitwiseNot:
            return "NOT"
        case .readMemory:
            return "RMEM"
        case .writeMemory:
            return "WMEM"
        case .call:
            return "CALL"
        case .return:
            return "RET"
        case .output:
            return "OUT"
        case .input:
            return "IN"
        case .noop:
            return "NOOP"
        }
    }
}
