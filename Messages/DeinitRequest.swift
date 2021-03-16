//
//  DeinitRequest.swift
//  elsa-ble
//
//  Created by Michael Irimus on 20.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public class DeinitRequest : NWPRequest{
    private var _localOnly : UInt8! = 0
    
    override public init() {
        super.init()
        parameterLength = getParameterLength()
        parameterBuffer = [UInt8](repeating: 0, count: Int(parameterLength))
        messageLength = getMessageLength()
        encryptionMode = EncryptionMode.EncryptionModeAESCCM256
        targetSEMIdentifier = SEMIdentifier.SEMIdentifierCore
        targetInstance = 0x00
        originatorSEMIdentifier = SEMIdentifier.SEMIdentifierOCH
        originatorInstance = 0x00
        commandType = CommandType.DEINIT_REQ
        targetBusAddress = BusAddress.OEC
        originatorBusAddress = BusAddress.OCH
    }
    
    func getParameterLength() -> UInt8{
        return 1
    }
}
