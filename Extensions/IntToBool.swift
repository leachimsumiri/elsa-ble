//
//  IntToBool.swift
//  elsa-ble
//
//  Created by Michael Irimus on 27.08.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

extension Int {
    public var boolValue: Bool {
        return self != 0
    }
}
