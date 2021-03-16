//
//  InitDataRequest.swift
//  elsa-ble
//
//  Created by Michael Irimus on 19.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public let INIT_DATA_REQ_PARAM_LENGTH : UInt8 = 34

public class InitDataRequest : NWPRequest {
    private var _communicationKey : [UInt8] = [UInt8](repeating: 0, count: 32)
    private var _busAddress : BusAddress!
    private var _localOnly : Bool = false
    
    public override init() {
        super.init()
        parameterLength = getParameterLength()
        parameterBuffer = [UInt8](repeating: 0, count: Int(parameterLength))
        messageLength = getMessageLength()
        encryptionMode = EncryptionMode.EncryptionModePlain
        targetSEMIdentifier = SEMIdentifier.SEMIdentifierCore
        targetInstance = 0x00
        originatorSEMIdentifier = SEMIdentifier.SEMIdentifierOCH
        originatorInstance = 0x00
        commandType = CommandType.INIT_DATA_REQ
        targetBusAddress = BusAddress.OEC
        originatorBusAddress = BusAddress.OCH
    }
    
    func setParameter(communicationKey: [UInt8], busAddress : BusAddress, localOnly : Bool){
        _communicationKey = communicationKey
        _busAddress = busAddress
        _localOnly = localOnly
    }
    
    func getParameterLength() -> UInt8{
        return INIT_DATA_REQ_PARAM_LENGTH
    }
}
