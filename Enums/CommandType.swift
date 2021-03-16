//
//  CommandType.swift
//  elsa-ble
//
//  Created by Michael Irimus on 24.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public enum CommandType : UInt16, CaseIterable, CustomStringConvertible{
    case GET_VERSION_REQ                        = 0x6E70
    case GET_VERSION_RES                        = 0x6E71
    case GET_BATTERY_LEVEL_REQ                  = 0x6E78
    case GET_BATTERY_LEVEL_RES                  = 0x6E79
    case GET_AUTHORIZATION_IDENTIFIER_REQ       = 0x6E76    // = GET_DOOR_ID
    case GET_AUTHORIZATION_IDENTIFIER_RES       = 0x6E77
    case GET_TIME_REQ                           = 0x6E72
    case GET_TIME_RES                           = 0x6E73
    case INIT_DATA_REQ                          = 0x001C
    case INIT_DATA_RES                          = 0x001D
    case SYNC_START_REQ                         = 0x000A
    case SYNC_START_RES                         = 0x000B
    case SYNC_END_REQ                           = 0x000C
    case SYNC_END_RES                           = 0x000D
    case DEINIT_REQ                             = 0x0016
    case DEINIT_RES                             = 0x0017
    
    case GENERICK_ACK                           = 0x7FFF
    case null                                   = 0x0000
    
    public var description: String {
        let value = String(format:"%02X", rawValue)
        return "0x" + value + " (\(name))"
    }
    
    private var name: String {
        switch self {
        case .GET_VERSION_REQ:                      return "GET_VERSION_REQ"
        case .GET_VERSION_RES:                      return "GET_VERSION_RES"
        case .GET_BATTERY_LEVEL_REQ:                return "GET_BATTERY_LEVEL_REQ"
        case .GET_BATTERY_LEVEL_RES:                return "GET_BATTERY_LEVEL_RES"
        case .GET_AUTHORIZATION_IDENTIFIER_REQ:     return "GET_AUTHORIZATION_IDENTIFIER_REQ"
        case .GET_AUTHORIZATION_IDENTIFIER_RES:     return "GET_AUTHORIZATION_IDENTIFIER_RES"
        case .GET_TIME_REQ:                         return "GET_TIME_REQ"
        case .GET_TIME_RES:                         return "GET_TIME_RES"
        case .SYNC_START_REQ:                       return "SYNC_START_REQ"
        case .SYNC_START_RES:                       return "SYNC_START_RES"
        case .SYNC_END_REQ:                         return "SYNC_END_REQ"
        case .SYNC_END_RES:                         return "SYNC_END_RES"
        case .INIT_DATA_REQ:                        return "INIT_DATA_REQ"
        case .INIT_DATA_RES:                        return "INIT_DATA_RES"
        case .DEINIT_REQ:                           return "DEINIT_REQ"
        case .DEINIT_RES:                           return "DEINIT_RES"
            
        case .GENERICK_ACK:                         return "GENERICK_ACK"
        case .null:                                 return "null"
        }
    }
}
