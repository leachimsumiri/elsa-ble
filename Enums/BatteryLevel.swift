//
//  BatteryLevel.swift
//  elsa-ble
//
//  Created by Michael Irimus on 06.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public enum BatteryLevel : UInt8{
    case Empty          =   0
    case Ok             =   1
    case Unavailable    =   255
}
