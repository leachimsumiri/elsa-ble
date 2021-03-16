//
//  Encryptionmode.swift
//  elsa-ble
//
//  Created by Michael Irimus on 21.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public enum EncryptionMode: UInt8{
    case EncryptionModePlain        = 0
    case EncryptionModeAESCCM256    = 1
}
