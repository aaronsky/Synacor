//
//  Registers.swift
//  
//
//  Created by Aaron Sky on 12/4/21.
//

public struct Registers {
    public var a: UInt16 = 0
    public var b: UInt16 = 0
    public var c: UInt16 = 0
    public var d: UInt16 = 0
    public var e: UInt16 = 0
    public var f: UInt16 = 0
    public var g: UInt16 = 0
    public var h: UInt16 = 0

    init() {}

    subscript(index: Int) -> UInt16 {
        get {
            switch index {
            case 0:
                return a
            case 1:
                return b
            case 2:
                return c
            case 3:
                return d
            case 4:
                return e
            case 5:
                return f
            case 6:
                return g
            case 7:
                return h
            default:
                preconditionFailure("invalid register \(index)")
            }
        }
        set {
            switch index {
            case 0:
                a = newValue
            case 1:
                b = newValue
            case 2:
                c = newValue
            case 3:
                d = newValue
            case 4:
                e = newValue
            case 5:
                f = newValue
            case 6:
                g = newValue
            case 7:
                h = newValue
            default:
                preconditionFailure("invalid register \(index)")
            }
        }
    }
}
