//
//  GetAuthorizationIdentifierResponse.swift
//  elsa-ble
//
//  Created by Michael Irimus on 06.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public let GET_DOOR_ID_RES_PARAM_LENGTH : UInt8 = 2

public class GetAuthorizationIdentifierResponse : NWPResponse{
    
    private var _doorID : UInt16!
    
    public override init(){
        super.init()
        parameterLength = getParameterLength()
        parameterBuffer = [UInt8](repeating: 0, count: Int(parameterLength))
        messageLength = getMessageLength()
    }
    
    override public func paramatersFrom(message: inout [UInt8], idx: inout Int) {
        idx = ++(idx)
        _doorID = bytesToUInt16(messageData: &message, idx: &idx)
    }
    
    func printParameter(){
        print("\nParameters")
        print("{")
        print("Door ID : \(getAuthorizationIdentifier())")
        print("}")
        print("\n")
    }
    
    func getParameterLength() -> UInt8{
        return GET_DOOR_ID_RES_PARAM_LENGTH
    }
    
    func getAuthorizationIdentifier() -> UInt16{
        return _doorID
    }
}
