//
//  EndPointType.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 26.09.2024.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
