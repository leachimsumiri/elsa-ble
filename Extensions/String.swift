//
//  String.swift
//  elsa-ble
//
//  Created by Michael Irimus on 05.09.18.
//  Copyright © 2018 Michael Irimus. All rights reserved.
//

import Foundation

extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex...endIndex])
    }
}
