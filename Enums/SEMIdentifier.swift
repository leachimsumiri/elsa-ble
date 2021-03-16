//
//  SEMIdentifier.swift
//  elsa-ble
//
//  Created by Michael Irimus on 21.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

//State-Event-Machines; Inside the Payload - for intern logical Addressing
public enum SEMIdentifier: UInt8{
    case SEMIdentifierCore              = 0     //Defines the identifier for the core SEM.
    case SEMIdentifierBCU               = 1     //Defines the identifier for the BCU SEM.
    case SEMIdentifierDoorContact       = 2     //Defines the identifier for the door contact SEM.
    case SEMIdentifierOpener            = 3     //Defines the identifier for the opener SEM.
    case SEMIdentifierRFID              = 4     //Defines the identifier for the RFID SEM.
    case SEMIdentifierProgrammingDevice = 5     //Defines the identifier for the programming device.
    case SEMIdentifierOCH               = 6     //Defines the identifier for the backend.
    case SEMIdentifierUnspecified       = 255   //Defines the identifier for unspecified components.
}
