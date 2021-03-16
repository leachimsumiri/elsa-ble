//
//  NWPMessage.swift
//  elsa-ble
//
//  Created by Michael Irimus on 02.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public typealias _BusAddress    = UInt8
public typealias SecurityFlags  = CFBitVector   //CFBitVectors manage ordered collections of bit values, which are either 0 or 1

public typealias _SEMIdentifier     = SEMIdentifier
public typealias _UserStatus        = UserStatus
public typealias _EncryptionMode    = EncryptionMode
public typealias _CommandType       = CommandType

let START_MARKER: UInt8        = 0xAA
let END_MARKER: UInt8          = 0xAD

public class NWPMessage{
    public var userStatus:      UserStatus!
    public var encryptionMode:  EncryptionMode!
    public var messageType:     MessageType!
    public var repeatFlag:      Bool!         //Security Flag Bit 3; 0 = new message; 1 = repeat
    public var ignoreNonce:     Bool!         //Security Flag Bit 4; 0 = Nonce Counter hast to be verified; 1 = ignore
    public var oddKeyFlag:      Bool!
    public var bootloaderFlag:  Bool!
    
    public var originatorBusAddress:    BusAddress!
    public var targetBusAddress:        BusAddress!
    
    public var originatorSEMIdentifier: SEMIdentifier!
    public var targetSEMIdentifier:     SEMIdentifier!
    
    public var originatorInstance:  UInt8!
    public var targetInstance:      UInt8!
    
    public var nonceCounter:    UInt32!             //Datatype Word, 4 Byte
    public var commandType:     CommandType!        //NWP Word, 2 Byte
    
    public var messageLength:   UInt8!      //NWP Message = Variable Length Array
    public var parameterLength: UInt8!
    public var parameterBuffer: [UInt8]!
    
    public init() {
        repeatFlag                 = false
        ignoreNonce                = false
        nonceCounter               = 0
        parameterLength            = 0
        targetBusAddress           = BusAddress.Local
        originatorBusAddress       = BusAddress.Local
        targetSEMIdentifier        = SEMIdentifier.SEMIdentifierUnspecified
        originatorSEMIdentifier    = SEMIdentifier.SEMIdentifierUnspecified
        targetInstance             = 0
        originatorInstance         = 0
        commandType                = CommandType.null
        oddKeyFlag                 = false
        bootloaderFlag             = false
        encryptionMode             = EncryptionMode.EncryptionModePlain
        userStatus                 = UserStatus.UserStatusNotApplicable
    }
    
    public func data() -> [UInt8]{
        var index:Int = 0
        let length:Int = Int(getMessageLength())
        
        //variable length Array
        var message: [UInt8] = [UInt8](repeating: 0, count: length)
        
        //1. Length
        message[index] = UInt8(length-1)
        
        //2. Security Flags
        let securityFlags : CFMutableBitVector = CFBitVectorCreateMutable(kCFAllocatorDefault, 8)
        
        switch encryptionMode {
        case EncryptionMode(rawValue: 0):
            CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_1, 0)
            CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_2, 0)
            CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_3, 0)
            break
        case EncryptionMode(rawValue: 1):
            CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_1, 0)
            CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_2, 1)
            CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_3, 0)
            break
        default:
            CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_1, 0)
            CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_2, 0)
            CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_3, 0)
            break
        }
        
        //set bits seperately
        CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_REPEAT_FLAG_BIT,       CFBit(repeatFlag.intValue))
        CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_IGNORE_NONCE_COUNTER,  CFBit(ignoreNonce.intValue))
        CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_MESSAGETYPE,           CFBit(messageType.rawValue))
        CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDX_ODD_KEY_IDENTIFICATOR, CFBit(oddKeyFlag.intValue))
        CFBitVectorSetBitAtIndex(securityFlags, Constants.BITIDC_BOOTLOADER_PROTOCOL,   CFBit(bootloaderFlag.intValue))
        
        //get all values
        CFBitVectorGetBits (securityFlags, CFRange(location: 0, length: 8), &message[++(index)])
        
        //3. User status
        message[++(index)] = UInt8(userStatus!.rawValue)
        
        //4. Nonce Counter, 4 Byte
        let _nonceCounter: UInt32 = nonceCounter
        message[++(index)] = UInt8((_nonceCounter >> 24) & 0xff)
        message[++(index)] = UInt8((_nonceCounter >> 16) & 0xff)
        message[++(index)] = UInt8((_nonceCounter >> 8) & 0xff)
        message[++(index)] = UInt8((_nonceCounter >> 0) & 0xff)
        
        //5. Bus Addresses
        message[++(index)] = UInt8(targetBusAddress!.rawValue)
        message[++(index)] = UInt8(originatorBusAddress!.rawValue)
        
        //5. Logical Addresses
        message[++(index)] = UInt8(targetSEMIdentifier!.rawValue)
        message[++(index)] = targetInstance
        message[++(index)] = UInt8(originatorSEMIdentifier!.rawValue)
        message[++(index)] = originatorInstance
        
        //6. Command type
        let ctValue: UInt16 = UInt16(commandType!.rawValue)
        message[++(index)] = UInt8((ctValue >> 8) & 0xff)
        message[++(index)] = UInt8((ctValue >> 0) & 0xff)
        
        //7. Parameters
        if(parameterLength > 0){
            message.replaceSubrange((++(index)..<Int(parameterLength)+index), with: parameterBuffer)
            index = index + parameterBuffer.count-1
        }
        
        //8. MAC
        message[++(index)] = 0
        message[++(index)] = 0
        message[++(index)] = 0
        message[++(index)] = 0
        
        //9. Encryption @ AES-CCM 256
        
        //10. Checksum
        var messageData2 = message
        messageData2.removeLast(4)
        
        let crc32 : UInt32 = messageData2.crc32()
        message[++(index)] = UInt8((crc32 >> 24) & 0xff)
        message[++(index)] = UInt8((crc32 >> 16) & 0xff)
        message[++(index)] = UInt8((crc32 >> 8) & 0xff)
        message[++(index)] = UInt8(crc32 & 0xff)
        
        return message
    }
    
    public func getMessageLength() -> UInt8 {
        return Constants.TRANSPORT_HEADER_LENGTH + Constants.LOGICAL_ADDRESSING_LENGTH + Constants.MESSAGE_TYPE_LENGTH + (self.parameterLength) + Constants.CHECKSUM_LENGTH + Constants.MAC_LENGTH
    }
}
