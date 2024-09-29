//
//  ListGistsViewModel.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 26.09.2024.
//

import Foundation

protocol ListGistsViewModelDelegate: AnyObject {
    func dataSourceDidChange(rows: [ListGistsViewModel.ItemModel])
}

final class ListGistsViewModel {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    var rows: [ItemModel] {
        didSet {
            delegate?.dataSourceDidChange(rows: rows)
        }
    }
    
    var gists: [Gist] = []
    private var currentPage = 1
    private var perPage = 15
    
    weak var delegate: ListGistsViewModelDelegate?

    init() {
        self.rows = []
        
        getGistsFirstPage()
    }
    
    // MARK: - Functions
    private func configureSections() {
        var items: [ItemModel] = []
        self.gists.forEach { gist in
            items.append(.gist(avatarUrl: gist.owner?.avatarURL ?? "", title: gist.description ?? "", nameOwner: gist.owner?.login ?? ""))
        }

        rows = items
    }
}

// MARK: - Network
extension ListGistsViewModel {
    func getGistsFirstPage() {
        currentPage = 1
        gists = []
        networkManager.getNewGists(perPage: perPage, page: currentPage) { gists, error in
            guard let gists = gists else { return }
            self.gists = gists
            self.configureSections()
        }
    }
    
    func getNextPage() {
        currentPage += 1
        networkManager.getNewGists(perPage: perPage, page: currentPage) { gists, error in
            guard let gists = gists else { return }
            self.gists += gists
            self.configureSections()
        }
    }
}

// MARK: - Data source
extension ListGistsViewModel {
    enum ItemModel {
        case gist(avatarUrl: String, title: String, nameOwner: String)
    }
}
