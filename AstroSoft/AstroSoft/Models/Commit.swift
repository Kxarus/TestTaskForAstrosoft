//
//  Commit.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 28.09.2024.
//

import Foundation

struct Commit: Decodable {
    let url: String?
    let version: String?
    let user: User?
}

struct User: Decodable {
    let login: String?
}
