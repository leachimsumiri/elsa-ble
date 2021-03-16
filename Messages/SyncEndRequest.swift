//
//  SyncEndRequest.swift
//  elsa-ble
//
//  Created by Michael Irimus on 20.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public let SYNC_END_REQUEST_PARAM_LENGTH : UInt8 = 66

public class SyncEndRequest : NWPRequest{
    
    private var _status : UInt16!
    private var _ekRndARndBRotR : [UInt8] = [UInt8](repeating: 0, count: 64)
    
    public override init() {
        super.init()
        nonceCounter = syncStartResponse.nonceCounter+1
        parameterLength = getParameterLength()
        parameterBuffer = [UInt8](repeating: 0, count: Int(parameterLength))
        messageLength = getMessageLength()
        targetSEMIdentifier = SEMIdentifier.SEMIdentifierUnspecified
        targetInstance = 0x00
        originatorSEMIdentifier = SEMIdentifier.SEMIdentifierUnspecified
        originatorInstance = 0x00
        encryptionMode = EncryptionMode.EncryptionModePlain
        userStatus = UserStatus.UserStatusNotApplicable
        commandType = CommandType.SYNC_END_REQ
        targetBusAddress = BusAddress.OEC
        originatorBusAddress = BusAddress.OCH
    }
    
    func setParameter(status : UInt16!, ekRndARndB2 : [UInt8]!){
        _status = status
        _ekRndARndBRotR = ekRndARndB2
        parameterBuffer[0] = UInt8((status >> 8) & 0xff)
        parameterBuffer[1] = UInt8(status & 0xff)
        parameterBuffer.replaceSubrange((2..<Int(parameterLength)), with: ekRndARndB2)
    }
    
    func getParameterLength() -> UInt8{
        return SYNC_END_REQUEST_PARAM_LENGTH
    }
}
