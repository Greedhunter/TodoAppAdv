//
//  Items.swift
//  TodoAppAdv
//
//  Created by Jack on 4/29/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import Foundation

class Items: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
