//
//  MessageTransform.swift
//  elsa-ble
//
//  Created by Michael Irimus on 06.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

var externData = ""

public func messageTransform(dataString: String){
    //check if complete datastream is valid message
    if(dataString.hasPrefix("AA") && dataString.hasSuffix("AD")){
        print("\nStart & End Marker detected, continue reading Data...\n")
        createResponse(data: dataWithHexString(hex: dataString))
    }
    //Exception Handling / Fault Tolerance
    else if (dataString.contains("AA") && dataString.contains("AD")) {// when valid data is inside a longer string
        let startidx : String.Index! = dataString.index(of: "AA")
        let endidx : String.Index! = dataString.index((dataString.index(of: "AD")!), offsetBy: 1)
        let plainData = dataString[startidx...endidx] //Substring between Start and Endmarker
        createResponse(data: dataWithHexString(hex: String(plainData)))
    } else if (dataString.contains("AA") && !dataString.contains("AD")){// when valid data started, but no end marker
        externData = dataString
    } else if (!dataString.contains("AA") && dataString.contains("AD")){// add end of data to valid start of data
        externData += dataString
        print("\nStart & End Marker correct, concatenating Message for valid Data: \(externData)\n")
        //externData = externData.subString(from: 2, to: externData.count-3)
        createResponse(data: dataWithHexString(hex: externData))
    }
    else {
        print("Data invalid, no Marker detected")
    }
}
