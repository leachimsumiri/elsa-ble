//
//  CalculateSessionKey.swift
//  elsa-ble
//
//  Created by Michael Irimus on 20.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation


public var _sessionKey : [UInt8] = [UInt8](repeating: 0, count: 32)
public var _rndB : [UInt8] = [UInt8](repeating: 0, count: 32)

public func calcEkRndARndBRotR(syncStartResponse : SyncStartResponse) -> [UInt8]{
    var _rndB2 : [UInt8] = [UInt8](repeating: 0, count: 32)
    //var _rndA2 : [UInt8] = [UInt8](repeating: 0, count: 32)
    
    print("\nDecrypting ek(rndB)...")
    
    let iv_zero : [UInt8] = [UInt8](repeating: 0, count: 16)
    _rndB = decrypt(input: syncStartResponse.getSyncStartResponseEkrndB(), key: dataWithHexString(hex: DEV_KEY).bytes, iv: iv_zero)
    print(" rndB : \(_rndB.toHexString())")
    
    //rotating
    print("\nRotating rndB...")
    _rndB2 = rotateRightByteArr(ek: _rndB)
    print(" rndB' : \(_rndB2.toHexString())")
    
    //generating rndA and rndA rotated
    print("\nGenerating rndA...")
    let _rndA : [UInt8] = generateRandomBytes(32)
    print(" rndA : \(_rndA.toHexString())")
        //- macht Komponente
    //print("\nRotating rndA...")
    //_rndA2 = rotateRightByteArr(ek: _rndA)
    //print(" rndA' : \(_rndA2.toHexString())")
    
    //concatenating
    let _rndArndB2 = _rndA.toHexString() + _rndB2.toHexString()
    print("\n   rndArndB' : \(_rndArndB2)")
    
    //Encrypting
    print("\nEncrypting rndArndB'...")
    let iv_ekRndARndB2 : [UInt8] // IV = last 16 bytes of ek(rndB)
    iv_ekRndARndB2 = dataWithHexString(hex: syncStartResponse.getSyncStartResponseEkrndB().toHexString().subString(from: 32, to: 63)).bytes
    let _ekRndARndB2 : [UInt8] = encrypt(input: dataWithHexString(hex: _rndArndB2).bytes, key: dataWithHexString(hex: DEV_KEY).bytes, iv: iv_ekRndARndB2)
    print(" ek(rndArndB') : \(_ekRndARndB2.toHexString())")
    
    //- macht Komponente
    //print("\nEncrypting rndA'...")
    //let iv_ekRndA2 : [UInt8] // IV = last 16 bytes of ek(rndArndB')
    //iv_ekRndA2 = dataWithHexString(hex: _ekRndARndB2.toHexString().subString(from: 32, to: 63)).bytes
    //let _ekRndA2 : [UInt8] = encrypt(input: _rndA2, key: dataWithHexString(hex: DEV_KEY).bytes, iv: iv_ekRndA2)
    //print(" ek(rndA') : \(_ekRndA2.toHexString())")
    
    return _ekRndARndB2
}

public func calcRndA(ekRndARotR : [UInt8]) -> [UInt8]{
    let iv_ekRndA2 : [UInt8] // IV = last 16 bytes of ek(rndArndB')
    iv_ekRndA2 = dataWithHexString(hex: _ekRndARndB2.toHexString().subString(from: 32, to: 63)).bytes
    
    let rndARotR : [UInt8] = decrypt(input: ekRndARotR, key: dataWithHexString(hex: DEV_KEY).bytes, iv: iv_ekRndA2)
    let rndA : [UInt8] = rotateLeftByteArr(ek: rndARotR)
    
    return rndA
}

//Session Key = RndA(0-7) + RndB(0-7) + RndA(24-31) + RndB(24-31)
public func calcSessionKey(skey : [UInt8], rndA : [UInt8], rndB : [UInt8]) -> [UInt8]{
    var key = skey
    for i in 0...7 {
        key[i] = rndA[i]
    }
    for i in 0...7 {
        key[i+8] = rndB[i]
    }
    for i in 24...31 {
        key[i-8] = rndA[i]
    }
    for i in 24...31 {
        key[i] = rndB[i]
    }
    return key
}
