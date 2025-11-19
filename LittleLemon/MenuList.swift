//
//  MenuList.swift
//  LittleLemon
//
//  Created by John Raetzel on 11/19/25.
//

import Foundation

struct MenuList: Decodable {
    let menu: [MenuItem]
}

struct MenuItem: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: String
    let image: String
    let category: String
}
