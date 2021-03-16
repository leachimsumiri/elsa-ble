//
//  GetBatteryLevelResponse.swift
//  elsa-ble
//
//  Created by Michael Irimus on 06.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public let GET_BATTERY_RES_PARAM_LENGHT : UInt8 = 1

public class GetBatteryLevelResponse : NWPResponse{
    private var _batteryLevel : UInt8!
    
    public override init() {
        super.init()
        parameterLength    = getParameterLength()
        parameterBuffer = [UInt8](repeating: 0, count: Int(parameterLength))
        messageLength      = getMessageLength()
    }
    
    override public func paramatersFrom(message:inout [UInt8], idx:inout Int) -> Void {
        _batteryLevel = message[++(idx)]
    }
    
    func getParameterLength() -> UInt8{
        return GET_BATTERY_RES_PARAM_LENGHT
    }
    
    func printParameter(){
        print("\nParameters")
        print("{")
        print("Battery Level : \(getBatteryLevel())")
        print("}")
        print("\n")
    }
    
    func getBatteryLevel() -> UInt8{
        return _batteryLevel
    }
}
