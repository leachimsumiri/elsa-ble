//
//  NWPRequest.swift
//  elsa-ble
//
//  Created by Michael Irimus on 16.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public class NWPRequest : NWPMessage{
    override init(){
        super.init()
        messageType = MessageType.MessageTypeRequest
    }
}
