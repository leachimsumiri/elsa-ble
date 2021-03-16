//
//  DeinitResponse.swift
//  elsa-ble
//
//  Created by Michael Irimus on 20.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public let DEINIT_RES_PARAM_LENGTH : UInt8 = 2

public class DeinitResponse : NWPResponse{
    private var _status : UInt16!
    
    override public init(){
        super.init()
        parameterLength = getParameterLength()
        parameterBuffer = [UInt8](repeating: 0, count: Int(parameterLength))
        messageLength = getMessageLength()
        encryptionMode = EncryptionMode.EncryptionModeAESCCM256
        targetSEMIdentifier = SEMIdentifier.SEMIdentifierProgrammingDevice
        targetInstance = 0x00
        originatorSEMIdentifier = SEMIdentifier.SEMIdentifierCore
        originatorInstance = 0x00
    }
    
    override public func paramatersFrom(message: inout [UInt8], idx: inout Int) {
        _status = bytesToUInt16(messageData: &message, idx: &idx)
    }
    
    func printParameter(){
        print("\nParameters")
        print("{")
        print("Status : \(String(_status))")
        print("}")
    }
    
    func getParameterLength() -> UInt8{
        return DEINIT_RES_PARAM_LENGTH
    }
}
