//
//  GetVersionResponseTests.swift
//  elsa-bleTests2
//
//  Created by Michael Irimus on 24.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation
import XCTest
import elsa_ble

open class GetVersionResponseTests: XCTestCase {
    
    public var response : GetVersionResponse! = GetVersionResponse()
    
    open func testPlainGetVersionResponse(testString: String) {
        let testData : Data = dataWithHexString(hex: testString)
        let testDataLength = testData.count / MemoryLayout<UInt8>.size
        var testByteArray = [UInt8](repeating: 0, count: testDataLength)
        testData.copyBytes(to: &testByteArray, count: testDataLength)
        let nwpResponse : NWPResponse! = response.fromData(messageData: &testByteArray)
        //for i in 1...testByteArray.count-2{
            //Generates a failure when expression1 == expression2
            //XCTAssertNotEqual(testByteArray[i], convertedData[i], "\nRight - Actual: " + String(convertedData[i]) + " Expected: " + String(testByteArray[i]) + "\n")
            //Generates a failure when expression1 != expression2
            //XCTAssertEqual(testByteArray[i], convertedData[i], "\nWrong - Actual: " + String(convertedData[i]) + " Expected: " + String(testByteArray[i]) + "\n")
        //}
        print("\nMessageLength = "              + String(nwpResponse.getMessageLength()))
        print("\nSecurityFlags")
        print("{")
        print("EncryptionMode = "               + String(nwpResponse.encryptionMode.rawValue))
        print("RepeatFlag = "                   + String(nwpResponse.repeatFlag.intValue))
        print("Ignore Nonce = "                 + String(nwpResponse.ignoreNonce.intValue))
        print("MessageType = "                  + String(nwpResponse.messageType.rawValue))
        print("ODD Key Identificator = "        + String(nwpResponse.oddKeyFlag.intValue))
        print("Bootloader Protocol = "          + String(nwpResponse.bootloaderFlag.intValue))
        print("}")
        print("\nUserStatus = "                 + String(nwpResponse.userStatus.rawValue))
        print("NonceCounter = "                 + String(nwpResponse.nonceCounter))
        print("\nTarget Bus Address = "         + String(nwpResponse.targetBusAddress.rawValue))
        print("Originator Bus Address = "       + String(nwpResponse.originatorBusAddress.rawValue))
        print("Target SEM Identifier = "        + String(nwpResponse.targetSEMIdentifier.rawValue))
        print("Target Instance = "              + String(nwpResponse.targetInstance))
        print("Originator SEM Identifier = "    + String(nwpResponse.originatorSEMIdentifier.rawValue))
        print("Originator Instance = "          + String(nwpResponse.originatorInstance))
        print("\nCommand Type = "               + nwpResponse.commandType.description)
        
        if( (nwpResponse.commandType.rawValue) == 0){
            print("No Command Type found for: 0x" + String(format: "%0X2", nwpResponse.commandType.rawValue))
        }
        
        print("\nParameters")
        print("{")
        print("Component Type = "               + String(response.getComponentTypeString(bytes: response.getComponentType())))
        print("\nMajor Bootloader Version = "   + String(response.getMajorBootloaderVersion()))
        print("Minor Bootloader Version = "     + String(response.getMinorBootloaderVersion()))
        print("Firmware Format Version = "      + String(response.getFirmwareUpdateFileFormatVersion()))
        print("Major Fimware Version = "        + String(response.getMajorFirmwareVersion()))
        print("Minor Firmware Version = "       + String(response.getMinorFirmwareVersion()))
        print("\nFirmware Variant = "           + String(bytes: response.getFirmwareVariant(), encoding: .ascii)!)
        print("Internal Revision = "            + String(bytes: response.getInternalRevision(), encoding: .ascii)!)
        print("Electrical Version = "           + String(bytes: response.getElectricalVersion(), encoding: .ascii)!)
        print("Mechanical Version = "           + String(bytes: response.getMechanicalVersion(), encoding: .ascii)!)
        print("Serial Number = "                + String(bytes: response.getSerialNumber(), encoding: .ascii)!)
        print("}")
        print("\n")
    }
}

