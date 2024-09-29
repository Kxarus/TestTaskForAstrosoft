//
//  NetworkManagerProtocol.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 29.09.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func getNewGists(perPage: Int, page: Int, completion: @escaping (_ gists: [Gist]?,_ error: String?) -> ())
    func getCommits(gistId: String, perPage: Int, page: Int, completion: @escaping (_ commits: [Commit]?,_ error: String?) -> ())
}
