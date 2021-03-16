//
//  BytesToUInt16.swift
//  elsa-ble
//
//  Created by Michael Irimus on 30.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

public func bytesToUInt16(messageData:inout Array<UInt8>, idx:inout Int) -> UInt16{
    let bytes : [UInt8] = [messageData[++(idx)], messageData[++(idx)]]
    let u16 : UInt16 = UnsafePointer(bytes).withMemoryRebound(to: UInt16.self, capacity: 1) {
        $0.pointee
    }
    return CFSwapInt16HostToBig(u16)
}
