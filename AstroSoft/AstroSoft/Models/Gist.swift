//
//  Gist.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 26.09.2024.
//

import Foundation

// MARK: - WelcomeElement
struct Gist: Decodable {
    let id: String?
    let files: [String: File]
    let description: String?
    let owner: Owner?
}

// MARK: - Files
struct File: Decodable {
    let filename, type, language: String?
    let rawURL: String?
    let size: Int?

    enum CodingKeys: String, CodingKey {
        case filename, type, language
        case rawURL = "raw_url"
        case size
    }
}



// MARK: - Owner
struct Owner: Decodable {
    let login: String
    let id: Int
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }
}
