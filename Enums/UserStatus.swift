//
//  Userstatus.swift
//  elsa-ble
//
//  Created by Michael Irimus on 21.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

//Status Codes
public enum UserStatus: UInt8{
    case UserStatusNotApplicable    = 0x00    //Defines a not applicable status.
    case UserStatusSuccessFull      = 0x01    //Defines the status for a successful operation.
    case UserStatusRetry            = 0x02    //Defines the status for a non successful operation, that might be retried.
    case UserStatusForce            = 0x03    //Defines the status for a non successful operation that might be forced (avoiding internal dependencies).
    case UserStatusFatal            = 0x04    //Defines the status for a non successful operation, due to a device failure. Device replacement is likely recommended.
    case UserStatusGoBack           = 0x05    //Defines the status for a non successful operation, that involved wrong request data. The diagnostic can be read after deciphering the message.
}
