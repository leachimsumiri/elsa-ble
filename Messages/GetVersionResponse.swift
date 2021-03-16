//
//  GetVersionResponse.swift
//  elsa-ble
//
//  Created by Michael Irimus on 24.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public let GET_VERSION_RES_PARAM_LENGTH : UInt8 = 86

public class GetVersionResponse : NWPResponse {
    
    private final var _componentType : [UInt8] = [UInt8](repeating: 0, count: 16)
    private final var _firmwareVariant : [UInt8] = [UInt8](repeating: 0, count: 16)
    private final var _internalRevision : [UInt8] = [UInt8](repeating: 0, count: 8)
    private final var _electricalVersion : [UInt8] = [UInt8](repeating: 0, count: 10)
    private final var _mechanicalVersion : [UInt8] = [UInt8](repeating: 0, count: 10)
    private final var _serialNumber : [UInt8] = [UInt8](repeating: 0, count: 16)
    
    private var _majorBootloaderVersion : UInt16!
    private var _minorBootloaderVersion : UInt16!
    private var _firmwareUpdateFileFormatVersion : UInt16!
    private var _majorFirmwareVersion : UInt16!
    private var _minorFirmwareVersion : UInt16!
    
    private var _componentTypeString : String!
    
    public override init() {
        super.init()
        parameterLength    = getParameterLength()
        parameterBuffer    = [UInt8](repeating: 0, count: Int(parameterLength))
        messageLength      = getMessageLength()
    }
    
    override public func paramatersFrom(message:inout [UInt8], idx:inout Int) -> Void {
        for i in 0..<_componentType.count{
            _componentType[i] = message[++(idx)]
        }
        
        _majorBootloaderVersion = bytesToUInt16(messageData: &message, idx: &idx)
        _minorBootloaderVersion = bytesToUInt16(messageData: &message, idx: &idx)
        _firmwareUpdateFileFormatVersion = bytesToUInt16(messageData: &message, idx: &idx)
        _majorFirmwareVersion = bytesToUInt16(messageData: &message, idx: &idx)
        _minorFirmwareVersion = bytesToUInt16(messageData: &message, idx: &idx)
        
        for i in 0..<_firmwareVariant.count{
            _firmwareVariant[i] = message[++(idx)]
        }
        
        for i in 0..<_internalRevision.count{
            _internalRevision[i] = message[++(idx)]
        }
        
        for i in 0..<_electricalVersion.count{
            _electricalVersion[i] = message[++(idx)]
        }
        
        for i in 0..<_mechanicalVersion.count{
            _mechanicalVersion[i] = message[++(idx)]
        }
        
        for i in 0..<_serialNumber.count{
            _serialNumber[i] = message[++(idx)]
        }
        
        _componentTypeString = getComponentTypeString(bytes: _componentType)
    }
    
    private func getParameterLength() -> UInt8{
        return GET_VERSION_RES_PARAM_LENGTH
    }
    
    func printParameter(){
        print("\nParameters")
        print("{")
        print("Component Type = "               + String(getComponentTypeString(bytes: getComponentType())))
        sleep(1)
        print("\nMajor Bootloader Version = "   + String(getMajorBootloaderVersion()))
        print("Minor Bootloader Version = "     + String(getMinorBootloaderVersion()))
        print("Firmware Format Version = "      + String(getFirmwareUpdateFileFormatVersion()))
        print("Major Fimware Version = "        + String(getMajorFirmwareVersion()))
        print("Minor Firmware Version = "       + String(getMinorFirmwareVersion()))
        print("\nFirmware Variant = "           + String(bytes: getFirmwareVariant(), encoding: .ascii)!)
        print("Internal Revision = "            + String(bytes: getInternalRevision(), encoding: .ascii)!)
        //workaround for optionals..
        //TBD
        if( getElectricalVersion().contains(0) ){
            print("\nElectrical Version = none")
        } else {
            print("\nElectrical Version = \(String(describing: String(bytes: getElectricalVersion(), encoding: .ascii)))")
        }
        if( getMechanicalVersion().contains(0) ){
            print("Mechanical Version = none")
        } else {
            print("Mechanical Version = \(String(describing: String(bytes: getMechanicalVersion(), encoding: .ascii)))")
        }
        if( getSerialNumber().contains(0) ){
            print("Serial Number = none")
        } else {
            print("Serial Number = \(String(describing: String(bytes: getSerialNumber(), encoding: .ascii)))")
        }
        print("}")
        print("\n")
    }
    
    public func getComponentType() -> [UInt8]{
        return _componentType
    }
    
    public func getFirmwareVariant() -> [UInt8]{
        return _firmwareVariant
    }
    
    public func getInternalRevision() -> [UInt8]{
        return _internalRevision
    }
    
    public func getElectricalVersion() -> [UInt8]{
        return _electricalVersion
    }
    
    public func getMechanicalVersion() -> [UInt8]{
        return _mechanicalVersion
    }
    
    public func getSerialNumber() -> [UInt8]{
        return _serialNumber
    }
    
    public func getMajorBootloaderVersion() -> UInt16{
        return _majorBootloaderVersion
    }
    
    public func getMinorBootloaderVersion() -> UInt16{
        return _minorBootloaderVersion
    }
    
    public func getFirmwareUpdateFileFormatVersion() -> UInt16 {
        return _firmwareUpdateFileFormatVersion
    }
    
    public func getMajorFirmwareVersion() -> UInt16 {
        return _majorFirmwareVersion
    }
    
    public func getMinorFirmwareVersion() -> UInt16{
        return _minorFirmwareVersion
    }
    
    public func getComponentTypeString(bytes: [UInt8]) -> String{
        _componentTypeString = String(bytes: bytes, encoding: .utf8)
        return _componentTypeString
    }
}
