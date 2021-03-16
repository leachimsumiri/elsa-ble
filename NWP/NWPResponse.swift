//
//  NWPResponse.swift
//  elsa-ble
//
//  Created by Michael Irimus on 16.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation
import CryptoSwift

public class NWPResponse : NWPMessage {
    var message : [UInt8]!
    
    override public init() {
        super.init()
        messageType = MessageType.MessageTypeResponse
    }
    
    public func fromData(messageData:inout [UInt8]) -> NWPResponse{
        var idx : Int = 0
        let length : Int = Int(messageData[++(idx)])
        var expectedCrcData : [UInt8] = [UInt8](repeating: 0, count: 4)
        
        //1. Length
        
        //Exception Handling - Message Length
        let actualDataLength = messageData.count-3
        if (length != actualDataLength){//messageData.count = LengthValue + 1 (byte of length value itself)
            print("wrong data size: \(length); expected \(actualDataLength)")
        }
        
        //Checksum
        expectedCrcData[3] =  messageData[length-2]
        expectedCrcData[2] =  messageData[length-1]
        expectedCrcData[1] =  messageData[length]
        expectedCrcData[0] =  messageData[length+1]
        
        var messageData2 = messageData
        messageData2.removeFirst()
        messageData2.removeLast(5)
        
        let expectedCrcUINT32 = expectedCrcData.data.uint32
        let dataCrc = messageData2.crc32()
        
        if(expectedCrcUINT32 == dataCrc){
            print("CHECKSUM CORRECT")
        } else {
            print("CHECKSUM FALSE")
            print("Expected CRC:    \(expectedCrcUINT32)")
            print("Calculated CRC:  \(dataCrc)")
        }
        
        //2. Header
        
        //Security Flags
        let securityFlags: CFBitVector = CFBitVectorCreate(nil, &messageData[++(idx)], 8)
        
        let bit1: CFBit = CFBitVectorGetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_1)
        let bit2: CFBit = CFBitVectorGetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_2)
        let bit3: CFBit = CFBitVectorGetBitAtIndex(securityFlags, Constants.BITIDX_ENCRYPTION_MODE_3)
        
        if(bit1 == 0 && bit2 == 0 && bit3 == 0){
            encryptionMode = _EncryptionMode.EncryptionModePlain
        } else {
            encryptionMode = _EncryptionMode.EncryptionModeAESCCM256
        }
        
        repeatFlag      = Int(CFBitVectorGetBitAtIndex(securityFlags, Constants.BITIDX_REPEAT_FLAG_BIT)).boolValue
        ignoreNonce     = Int(CFBitVectorGetBitAtIndex(securityFlags, Constants.BITIDX_IGNORE_NONCE_COUNTER)).boolValue
        messageType     = MessageType(rawValue: UInt8(Int(CFBitVectorGetBitAtIndex(securityFlags, Constants.BITIDX_MESSAGETYPE))))
        oddKeyFlag      = Int(CFBitVectorGetBitAtIndex(securityFlags, Constants.BITIDX_ODD_KEY_IDENTIFICATOR)).boolValue
        bootloaderFlag  = Int(CFBitVectorGetBitAtIndex(securityFlags, Constants.BITIDC_BOOTLOADER_PROTOCOL)).boolValue
        
        if(messageType != MessageType.MessageTypeResponse){
            NSLog("Wrong Message Type")
        }
        
        //User Status
        userStatus = UserStatus(rawValue: UInt8(messageData[++(idx)]))
        
        //Nonce Counter
        var _nonceCounter: UInt32 = CFSwapInt32HostToBig(nonceCounter) //swap to big endian
        let accessCounter: UnsafeMutablePointer<UInt32> = UnsafeMutablePointer<UInt32>(&_nonceCounter)
        accessCounter[3] = UInt32(CChar(((messageData[++(idx)]) >> 24) & 0xff))
        accessCounter[2] = UInt32(CChar(((messageData[++(idx)]) >> 16) & 0xff))
        accessCounter[1] = UInt32(CChar(((messageData[++(idx)]) >> 8) & 0xff))
        accessCounter[0] = UInt32(CChar(((messageData[++(idx)]) >> 0) & 0xff))
        nonceCounter = _nonceCounter
        
        //Bus Addresses
        targetBusAddress = BusAddress(rawValue: UInt8(messageData[++(idx)]))
        originatorBusAddress = BusAddress(rawValue: UInt8(messageData[++(idx)]))
        
        //2. Payload
        
        //Aes-CCM 256
        
        //Logical Addressing
        targetSEMIdentifier = SEMIdentifier(rawValue: UInt8(messageData[++(idx)]))
        targetInstance = messageData[++(idx)]
        originatorSEMIdentifier = SEMIdentifier(rawValue: UInt8(messageData[++(idx)]))
        originatorInstance = messageData[++(idx)]
        
        //Command Type
        commandType = NWPFunction.forCommandId(commandId: bytesToUInt16(messageData: &messageData, idx: &idx))
        
        //Parameters
        paramatersFrom(message: &messageData, idx: &idx)
        
        //MAC
        
        //let mac: HMAC = HMAC.init(key: messageData)
        
        
        return self
    }
    
    public func paramatersFrom(message:inout [UInt8], idx:inout Int) -> Void {
    }
    
    public func printResponseHeaderAndPayloadHeader(){
        print("\nMessageLength = "              + String(self.getMessageLength()))
        print("\nSecurityFlags")
        print("{")
        print("EncryptionMode = "               + String(self.encryptionMode.rawValue))
        print("RepeatFlag = "                   + String(self.repeatFlag.intValue))
        print("Ignore Nonce = "                 + String(self.ignoreNonce.intValue))
        print("MessageType = "                  + String(self.messageType.rawValue))
        print("ODD Key Identificator = "        + String(self.oddKeyFlag.intValue))
        print("Bootloader Protocol = "          + String(self.bootloaderFlag.intValue))
        print("}")
        sleep(1)
        print("\nUserStatus = "                 + String(self.userStatus.rawValue))
        print("NonceCounter = "                 + String(self.nonceCounter))
        print("\nTarget Bus Address = "         + String(self.targetBusAddress.rawValue))
        print("Originator Bus Address = "       + String(self.originatorBusAddress.rawValue))
        print("Target SEM Identifier = "        + String(self.targetSEMIdentifier.rawValue))
        print("Target Instance = "              + String(self.targetInstance))
        print("Originator SEM Identifier = "    + String(self.originatorSEMIdentifier.rawValue))
        print("Originator Instance = "          + String(self.originatorInstance))
        print("\nCommand Type = "               + String(self.commandType.description))
    }
}
