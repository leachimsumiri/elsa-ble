//
//  Data.swift
//  elsa-ble
//
//  Created by Michael Irimus on 24.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

//https://stackoverflow.com/questions/39075043/how-to-convert-data-to-hex-string-in-swift
//Converts a Data Object to a Hex String
extension Data {
    /*struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }*/
    
    public func toHexEncodedString() -> String {
        let hexDigits = Array(("0123456789ABCDEF").utf16)
        var chars: [unichar] = []
        chars.reserveCapacity(2 * count)
        for byte in self {
            chars.append(hexDigits[Int(byte / 16)])
            chars.append(hexDigits[Int(byte % 16)])
        }
        return String(utf16CodeUnits: chars, count: chars.count)
    }
    
    public func toString() -> String {
        return String(data: self, encoding: .utf8)!
    }
    
    var uint32: UInt32 {
        return withUnsafeBytes { $0.pointee }
    }
}
