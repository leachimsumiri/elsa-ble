//
//  GetTimeResponse.swift
//  elsa-ble
//
//  Created by Michael Irimus on 06.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public let GET_TIME_RES_PARAM_LENGTH : UInt8 = 7

public class GetTimeResponse : NWPResponse{
    
    private var _seconds        : UInt8!
    private var _minutes        : UInt8!
    private var _hours          : UInt8!
    private var _days           : UInt8!
    private var _dayInWeek      : UInt8!
    private var _month          : UInt8!
    private var _year           : UInt8!
    
    public override init() {
        super.init()
        parameterLength     = getParameterLength()
        parameterBuffer = [UInt8](repeating: 0, count: Int(parameterLength))
        messageLength       = getMessageLength()
    }
    
    override public func paramatersFrom(message: inout [UInt8], idx: inout Int) {
        _seconds = message[++(idx)]
        _minutes = message[++(idx)]
        _hours = message[++(idx)]
        _days = message[++(idx)]
        _dayInWeek = message[++(idx)]
        _month = message[++(idx)]
        _year = message[++(idx)]
    }
    
    func printParameters(){
        print("\nParameters")
        print("{")
        print("Seconds : \(getSeconds())")
        print("}\n")
    }
    
    func getParameterLength() -> UInt8{
        return GET_TIME_RES_PARAM_LENGTH
    }
    
    func getSeconds() -> UInt8{
        return _seconds
    }
}
