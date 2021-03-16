//
//  CreateResponse.swift
//  elsa-ble
//
//  Created by Michael Irimus on 12.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public var syncStartResponse : SyncStartResponse!
public var _ekRndARndB2 : [UInt8]!

public func createResponse(data: Data){
    let dataLength = data.count / MemoryLayout<UInt8>.size
    var byteArray = [UInt8](repeating: 0, count: dataLength)    //provide a new byteArray from the received data
    data.copyBytes(to: &byteArray, count: dataLength)           //fill the new byteArray with the data
    
    //Determining Command Type of the Response
    var i = 13 // Command Type of a NWP Message = Byte 14 & 15, die untere Funktion incrementiert den Index sofort und die Zählung beginnt bei 0
    let commandType = bytesToUInt16(messageData: &byteArray, idx: &i)
    
    switch commandType {
    case CommandType.GET_VERSION_RES.rawValue:
        let getVersionResponse : GetVersionResponse! = GetVersionResponse()
        let nwpResponse : NWPResponse! = getVersionResponse.fromData(messageData: &byteArray)    //pass the byteArray to a newly created NWP Response
        nwpResponse.printResponseHeaderAndPayloadHeader()
        getVersionResponse.printParameter()
    case CommandType.GET_BATTERY_LEVEL_RES.rawValue:
        let getBatteryLevelResponse : GetBatteryLevelResponse! = GetBatteryLevelResponse()
        let nwpResponse : NWPResponse! = getBatteryLevelResponse.fromData(messageData: &byteArray)
        nwpResponse.printResponseHeaderAndPayloadHeader()
        getBatteryLevelResponse.printParameter()
    case CommandType.GET_AUTHORIZATION_IDENTIFIER_RES.rawValue:
        let getAuthorizationIdentifierResponse : GetAuthorizationIdentifierResponse! = GetAuthorizationIdentifierResponse()
        let nwpResponse : NWPResponse! = getAuthorizationIdentifierResponse.fromData(messageData: &byteArray)
        nwpResponse.printResponseHeaderAndPayloadHeader()
        getAuthorizationIdentifierResponse.printParameter()
    case CommandType.SYNC_START_RES.rawValue:
        syncStartResponse = SyncStartResponse()
        let nwpResponse : NWPResponse! = syncStartResponse.fromData(messageData: &byteArray)
        nwpResponse.printResponseHeaderAndPayloadHeader()
        syncStartResponse.printParameter()
        
        //key für Sync End Req berechnen
        _ekRndARndB2 = calcEkRndARndBRotR(syncStartResponse : syncStartResponse)
    case CommandType.SYNC_END_RES.rawValue:
        let syncEndResponse = SyncEndResponse()
        let nwpResponse : NWPResponse! = syncEndResponse.fromData(messageData: &byteArray)
        nwpResponse.printResponseHeaderAndPayloadHeader()
        syncEndResponse.printParameter()
    case CommandType.GET_TIME_RES.rawValue:
        let getTimeResponse : GetTimeResponse! = GetTimeResponse()
        let nwpResponse : NWPResponse! = getTimeResponse.fromData(messageData: &byteArray)
        nwpResponse.printResponseHeaderAndPayloadHeader()
        getTimeResponse.printParameters()
    case CommandType.INIT_DATA_RES.rawValue:
        let initDataResponse : InitDataResponse! = InitDataResponse()
        let nwpResponse : NWPResponse! = initDataResponse.fromData(messageData: &byteArray)
        nwpResponse.printResponseHeaderAndPayloadHeader()
        initDataResponse.printParameter()
    case CommandType.DEINIT_RES.rawValue:
        let deinitResponse : DeinitResponse! = DeinitResponse()
        let nwpResponse : NWPResponse! = deinitResponse.fromData(messageData: &byteArray)
        nwpResponse.printResponseHeaderAndPayloadHeader()
        deinitResponse.printParameter()
    default:
        print("No Command Type found for: 0x" + String(format: "%0X2", commandType))
    }
}
