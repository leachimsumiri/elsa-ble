//
//  CreateRequest.swift
//  elsa-ble
//
//  Created by Michael Irimus on 19.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public func createRequest(request : NWPRequest) -> Data{
    //let requestData = dataWithHexString(hex: VALID_SYNC_START_REQUEST)
    let requestData = dataWithHexString(hex: String("AA\(request.data().toHexString())AD"))
    return requestData
}
