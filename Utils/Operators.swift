//
//  Operators.swift
//  elsa-ble
//
//  Created by Michael Irimus on 21.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

prefix operator ++

public prefix func ++( x: inout Int) -> Int {
    x += 1
    return x
}
