//
//  NWPFunction.swift
//  elsa-ble
//
//  Created by Michael Irimus on 24.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public class NWPFunction{
    
    private var _commandId: UInt16
    
    public init(commandId : UInt16){
        _commandId = commandId
    }
    
    /**
     * Returns the CommandType for the given request or response id.
     *
     * @param commandId the request or response id
     * @return the CommandType instance or 0 if an invalid request or response id was specified
     */
    public static func forCommandId(commandId: UInt16) -> CommandType{
        for i in 0...CommandType.allCases.count-1{
            if(CommandType.allCases[i].rawValue == commandId){
                return CommandType.allCases[i]
            }
        }
        return CommandType.null
    }
    
    public func getCommandId() -> UInt16{
        return _commandId
    }
}
