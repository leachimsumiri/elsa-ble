//
//  NWPFunctionTests.swift
//  elsa-bleTests2
//
//  Created by Michael Irimus on 24.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation
import XCTest
import elsa_ble

public class NWPFunctionTests : XCTestCase{
    
    public let _NWPFunction : NWPFunction! = NWPFunction.init(commandId: CommandType.GET_VERSION_REQ.rawValue)
    
    public func testNWPFunction(){
        let command:UInt16 = NWPFunction.forCommandId(commandId: _NWPFunction.getCommandId()).rawValue
        print("\n0x" + String(format:"%2X", command) + "\n")
        XCTAssertNotEqual(command, 0)
    }
}
