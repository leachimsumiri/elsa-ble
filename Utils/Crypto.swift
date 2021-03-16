//
//  Crypto.swift
//  elsa-ble
//
//  Created by Michael Irimus on 11.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation
import CryptoSwift

//@param number of random bytes to be generated
func generateRandomBytes(_ n: UInt8) -> [UInt8] {
    return (0..<n).map{ _ in UInt8(arc4random_uniform(255)) }
}

func rotateRightByteArr(ek: [UInt8]) -> [UInt8]{
    let x = ek[ek.count-1]
    var ek2 = ek
    for i in (1...ek.count-1).reversed(){
        ek2[i] = ek2[i-1]
    }
    ek2[0] = x
    return ek2
}

func rotateLeftByteArr(ek: [UInt8]) -> [UInt8]{
    let x = ek[0]
    var ek2 = ek
    for i in (0...ek.count-2).reversed(){
        ek2[i] = ek2[i+1]
    }
    ek2[ek.count-1] = x
    return ek2
}
    
public func encrypt(input: [UInt8], key: [UInt8], iv: [UInt8]) -> [UInt8]{
    let encrypted : [UInt8]
    do {
        encrypted = try AES(key: key, blockMode: CBC(iv: iv), padding: .zeroPadding).encrypt(input)
        return encrypted
    } catch {
        encrypted = dataWithHexString(hex: "0000000000000000000000").bytes
        print("Error @ Encryption: \(error)")
    }
    return encrypted
}

public func decrypt(input: [UInt8], key: [UInt8], iv: [UInt8]) -> [UInt8]{
    let decrypted : [UInt8]
    do {
        decrypted = try AES(key: key, blockMode: CBC(iv: iv), padding: .noPadding).decrypt(input)
        return decrypted
    } catch {
        decrypted = dataWithHexString(hex: "0000000000000000000000").bytes
        print("Error @ Decryption: \(error)")
    }
    return decrypted
}
