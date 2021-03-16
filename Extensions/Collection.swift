//
//  Collection.swift
//  elsa-ble
//
//  Created by Michael Irimus on 06.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

extension Collection where Element == UInt8 {
    var data: Data { return Data(self) }
}
