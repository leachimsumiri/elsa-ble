//
//  Messagetype.swift
//  elsa-ble
//
//  Created by Michael Irimus on 21.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public enum MessageType: UInt8{
    case MessageTypeResponse    = 0     //  Slave/Server    to  Master/Client
    case MessageTypeRequest     = 1      //  Master/Client   to  Slave/Server
}
