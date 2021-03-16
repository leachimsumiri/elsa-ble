//
//  NWPConstants.swift
//  elsa-ble
//
//  Created by Michael Irimus on 21.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public struct Constants{
    public static let HEADER_LENGTH:UInt8               = 8
    public static let TRANSPORT_HEADER_LENGTH:UInt8     = 9
    public static let LOGICAL_ADDRESSING_LENGTH:UInt8   = 4
    public static let MESSAGE_TYPE_LENGTH:UInt8         = 2
    public static let MAC_LENGTH:UInt8                  = 4
    public static let CHECKSUM_LENGTH:UInt8             = 4
    public static let NONCE_LENGTH                      = 13
    
    public static let MAX_NWP_LENGTH = 128

    public static let BITIDX_ENCRYPTION_MODE_1      = 7
    public static let BITIDX_ENCRYPTION_MODE_2      = 6
    public static let BITIDX_ENCRYPTION_MODE_3      = 5
    public static let BITIDX_REPEAT_FLAG_BIT    	= 4
    public static let BITIDX_IGNORE_NONCE_COUNTER   = 3
    public static let BITIDX_MESSAGETYPE            = 2
    public static let BITIDX_ODD_KEY_IDENTIFICATOR  = 1
    public static let BITIDC_BOOTLOADER_PROTOCOL    = 0

    public static let BA_BUSCONTROLLER:UInt8        = 0x80      //Doorbus Address - Cylinder Main Print
    public static let BA_PROGRAMMING_DEVICE:UInt8   = 0xFE      //maintenance component
    public static let BA_LOCAL                      = 0xFF      //cable connected, maybe not necessary          // ! BUS ADRESS != LOGICAL ADDRESS !
    public static let BA_BACKEND                    = 0x05      //backend
    public static let BA_OCH                        = 0x06      //OCH

    public static let INSTANCE_CORE:UInt8 = 0

    public static let NONCE_WATERMARK = 0xFFFFFF00              //from this value it will only allow update key function messages with a valid and verified nonce counter used for encryption.
}

