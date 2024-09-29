//
//  MovieEndPoint.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 26.09.2024.
//

import Foundation

enum NetworkEnvironment {
    case production
}

public enum GistApi {
    case getGists(perPage: Int, page: Int)
    case getCommits(perPage: Int, page: Int, gistId: String)
}

extension GistApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://api.github.com/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getGists:
            return "gists"
        case .getCommits(_, _, let id):
            return "gists/\(id)/commits"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .getGists(let perPage, let page):
                    return .requestParameters(bodyParameters: nil,
                                              bodyEncoding: .urlEncoding,
                                              urlParameters: ["per_page": perPage,
                                                              "page":page])
        case .getCommits(let perPage, let page, _):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["per_page": perPage,
                                                      "page":page])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
