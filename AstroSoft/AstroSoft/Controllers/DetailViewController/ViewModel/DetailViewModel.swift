//
//  DetailViewModel.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 26.09.2024.
//

import Foundation
import UIKit

protocol DetailViewModelDelegate: AnyObject {
    func dataSourceDidChange(rows: [DetailViewModel.ItemModel])
}

final class DetailViewModel {
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let gist: Gist
    private var commits: [Commit] = []
    private var currentPage = 1
    private var perPage = 15
    
    var rows: [ItemModel] {
        didSet {
            delegate?.dataSourceDidChange(rows: rows)
        }
    }
    
    weak var delegate: DetailViewModelDelegate?

    init(gist: Gist) {
        self.rows = []
        self.gist = gist
        
        fetchFirstPageCommits()
    }
    
    // MARK: - Functions
    func configureSections() {
        var items: [ItemModel] = []
        
        items.append(.avatar(avatarUrl: gist.owner?.avatarURL ?? ""))
        items.append(.empty(height: 16))
        items.append(.text(text: gist.owner?.login ?? "", textSize: 16, alignment: .center))
        items.append(.empty(height: 16))
        items.append(.text(text: gist.description ?? "", textSize: 16, alignment: .center))
        items.append(.empty(height: 16))
        items.append(.text(text: "Файлы:", textSize: 24))
        items.append(.empty(height: 16))

        gist.files.forEach {
            items.append(.file(file: $0.value))
            items.append(.empty(height: 5))
        }

        items.append(.empty(height: 16))
        
        if commits.count > 0 {
            items.append(.text(text: "Список коммитов:", textSize: 24))
            items.append(.empty(height: 11))
            
            commits.forEach {
                items.append(.empty(height: 5))
                let commit = "\($0.user?.login ?? ""): \($0.version ?? "")"
                items.append(.text(text: commit, textSize: 16))
            }
        }

        rows = items
    }
    
    func isLoadedNextPage(lastRow: ItemModel) -> Bool {
        if commits.count >= perPage {
            switch lastRow {
            case .text(let text, _, _):
                guard let lastCommit = commits.last else {
                    return false
                }
                if lastCommit.url == text {
                    return true
                } else {
                    return false
                }
            default:
                return false
            }
        } else {
            return false
        }
    }
}

// MARK: - Network
extension DetailViewModel {
    func fetchFirstPageCommits() {
        let gistId = gist.id ?? ""
        currentPage = 1
        commits = []
        networkManager.getCommits(gistId: gistId, perPage: perPage, page: currentPage, completion: { commits, error in
            guard let commits = commits else {
                self.configureSections()
                return
            }
            self.commits = commits
            self.configureSections()
        })
    }
    
    func fetchNextPageCommits() {
        let gistId = gist.id ?? ""
        currentPage += 1
        networkManager.getCommits(gistId: gistId, perPage: perPage, page: currentPage, completion: { commits, error in
            guard let commits = commits else {
                self.configureSections()
                return
            }
            self.commits += commits
            self.configureSections()
        })
    }
}

// MARK: - Data source
extension DetailViewModel {
    enum ItemModel {
        case avatar(avatarUrl: String)
        case empty(height: CGFloat)
        case text(text: String, textSize: CGFloat, alignment: NSTextAlignment = .left)
        case file(file: File)
    }
}

