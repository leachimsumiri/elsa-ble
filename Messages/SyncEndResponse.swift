//
//  SyncEndResponse.swift
//  elsa-ble
//
//  Created by Michael Irimus on 20.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation
import CryptoSwift

public let SYNC_END_RESPONSE_PARAM_LENGTH : UInt8 = 34

public class SyncEndResponse : NWPResponse{
    private var _status : UInt16!
    private var _ekRndARotR : [UInt8] = [UInt8](repeating: 0, count: 32)
    
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
        commandType = CommandType.SYNC_END_RES
    }
    
    override public func paramatersFrom(message: inout [UInt8], idx: inout Int) {
        _status = bytesToUInt16(messageData: &message, idx: &idx)
        for i in 0..._ekRndARotR.count-1{
            _ekRndARotR[i] = message[++(idx)]
        }
    }
    
    func printParameter() {
        print("\nParameters")
        print("{")
        print("Status : \(getStatus())")
        print("}")
        //Session Key
        print("\nCalculating Session Key... ( RndA(0-7) + RndB(0-7) + RndA(24-31) + RndB(24-31) )")
        _sessionKey = calcSessionKey(skey: _sessionKey, rndA: calcRndA(ekRndARotR: _ekRndARotR), rndB: _rndB)
        print(" Session Key : \(_sessionKey.toHexString())")
    }
    
    func getParameterLength() -> UInt8{
        return SYNC_END_RESPONSE_PARAM_LENGTH
    }
    
    func getStatus() -> UInt16{
        return _status
    }
}
