//
//  SyncStartResponse.swift
//  elsa-ble
//
//  Created by Michael Irimus on 10.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public let SYNC_START_RES_PARAM_LENGTH : UInt8! = 34

public class SyncStartResponse : NWPResponse{
    
    private var _status : UInt16! = 0
    private var _ekrndB : [UInt8] = [UInt8](repeating: 0, count: 32)
    
    override public init() {
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
        commandType = CommandType.SYNC_START_RES
    }
    
    override public func paramatersFrom(message: inout [UInt8], idx: inout Int) {
        _status = bytesToUInt16(messageData: &message, idx: &idx)
        for i in 0..._ekrndB.count-1{
            _ekrndB[i] = message[++(idx)]
        }
    }
    
    func printParameter() {
        print("\nParameters")
        print("{")
        print("Status : \(getStatus())")
        print("ek(rndB): \(getSyncStartResponseEkrndB().toHexString())")
        print("}")
    }
    
    func getParameterLength() -> UInt8 {
        return SYNC_START_RES_PARAM_LENGTH
    }
    
    func getStatus() -> UInt16{
        return _status
    }
    
    func getSyncStartResponseEkrndB() -> [UInt8]{
        return _ekrndB
    }
}
