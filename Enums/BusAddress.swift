//
//  Busaddress.swift
//  elsa-ble
//
//  Created by Michael Irimus on 21.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public enum BusAddress: UInt8{
    case Local = 0xFF   //Defines the bus address (byte) for the hardware unit the programming device is connected to (e.g. wall reader unit).
    /**
     * This address value actually is set on devices with unknown address.
     * It will not be proxied to the bus, so it is essentially a way to
     * communicate locally.
     */
    
    case BCU    = 0x80     //Defines the bus address (byte) for the hardware unit with the bus controller.
    case PG     = 0xFE     //Defines the bus address (byte) for the programming device.
    case CWL    = 0x7f     //Defines the WL construction bus address (byte).
    case OEC    = 0x02     //Defines the bus address (byte) for the online evva component.
    case OCH    = 0x01     //Defines the bus address (byte) for the online component handler.
}
