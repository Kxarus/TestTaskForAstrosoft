//
//  FileViewModel.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 28.09.2024.
//

import Foundation
import PDFKit

protocol FileViewModelDelegate: AnyObject {
    func didUpdate(with file: String)
}

final class FileViewModel {
    private let networkManager: NetworkManager = NetworkManager()
    
    weak var delegate: FileViewModelDelegate?

    init(fileUrl: String) {
        guard let url = URL(string: fileUrl) else { return }
        fetchPDF(url: url)
    }
    
    private func fetchPDF(url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url), let file = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.delegate?.didUpdate(with: file)
                }
            }
        }
    }
}
