//
//  SyncStartRequest.swift
//  elsa-ble
//
//  Created by Michael Irimus on 10.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public let SYNC_START_REQ_PARAM_LENGTH : UInt8 = 3

public class SyncStartRequest : NWPRequest{
    
    private var _usingOddKey : UInt8! = 0
    private var _authorizationID : UInt16! = 0
    
    public override init() {
        super.init()
        parameterLength = getParameterLength()
        parameterBuffer = [UInt8](repeating: 0, count: Int(parameterLength))
        messageLength = getMessageLength()
        targetSEMIdentifier = SEMIdentifier.SEMIdentifierUnspecified
        originatorSEMIdentifier = SEMIdentifier.SEMIdentifierUnspecified
        targetInstance = 0x00
        originatorInstance = 0x00
        encryptionMode = EncryptionMode.EncryptionModePlain
        userStatus = UserStatus.UserStatusNotApplicable
        commandType = CommandType.SYNC_START_REQ
        targetBusAddress = BusAddress.OEC
        originatorBusAddress = BusAddress.OCH
    }
    
    func setParameter(usingOddKey : UInt8!, authorizationID: UInt16!) {
        _usingOddKey = usingOddKey
        _authorizationID = authorizationID
        parameterBuffer[0] = usingOddKey
        parameterBuffer[1] = UInt8((authorizationID >> 8) & 0xff)
        parameterBuffer[2] = UInt8(authorizationID & 0xff)
    }
    
    func getParameterLength() -> UInt8 {
        return SYNC_START_REQ_PARAM_LENGTH
    }
}
