//
//  elsa_bleTests2.swift
//  elsa-bleTests2
//
//  Created by Michael Irimus on 21.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import XCTest
import elsa_ble

public class GetVersionRequestTests: XCTestCase {
    
    public var request:GetVersionRequest! = GetVersionRequest()
    
    override public func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    public func testPlainGetVersionRequest() {
        request.encryptionMode = _EncryptionMode.EncryptionModePlain
        let key : String = "AA162000000000000201000006006E70000000002926877BAD"
        let reqData : Data = Data(request.data())
        let dataString : String = reqData.toHexEncodedString()
        print(dataString)
        XCTAssertEqual(key, dataString)
    }
}
