//
//  GetVersionRequest.swift
//  elsa-ble
//
//  Created by Michael Irimus on 02.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public let GET_VERSION_REQ_PARAMLENGTH : UInt8 = 0         // no params

public class GetVersionRequest : NWPRequest {
    
    public override init() {
        super.init()
        messageLength              = getMessageLength()
        originatorBusAddress       = BusAddress.OCH
        originatorSEMIdentifier    = SEMIdentifier.SEMIdentifierOCH
        originatorInstance         = 0
        targetBusAddress           = BusAddress.OEC
        targetSEMIdentifier        = _SEMIdentifier.SEMIdentifierCore
        targetInstance             = Constants.INSTANCE_CORE
        commandType                = CommandType.GET_VERSION_REQ
        userStatus                 = _UserStatus.UserStatusNotApplicable
        parameterLength            = getParameterLength()
        encryptionMode             = EncryptionMode.EncryptionModePlain
    }
    
    func getParameterLength() -> UInt8{
        return GET_VERSION_REQ_PARAMLENGTH
    }
}

