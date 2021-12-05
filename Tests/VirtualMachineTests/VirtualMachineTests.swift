//
//  VirtualMachineTests.swift
//  
//
//  Created by Aaron Sky on 12/4/21.
//

@testable import VirtualMachine
import XCTest

class VirtualMachineTests: XCTestCase {
    func testSimpleProgram() throws {
        var vm = VirtualMachine(program: [9, 32768, 32769, 4, 19, 32768])
        guard case let .output(c) = try vm.run() else {
            XCTFail("Expected program to output")
            return
        }
        try XCTAssertEqual(
            XCTUnwrap(String(bytes: [UInt8(c)], encoding: .utf8)),
            "\u{04}"
        )
    }
}
