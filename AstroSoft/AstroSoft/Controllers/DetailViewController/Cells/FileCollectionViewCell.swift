//
//  FileCollectionViewCell.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 28.09.2024.
//

import UIKit

protocol FileCollectionViewCellDelegate: AnyObject {
    func didTapFile(_ fileUrl: String)
}

final class FileCollectionViewCell: ASCollectionViewCell {
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var file: File?
    weak var delegate: FileCollectionViewCellDelegate?
    
    // MARK: - Lifecycle
    override func initialSetup() {
        makeUI()
    }
    
    func configure(with file: File) {
        self.file = file
        button.setTitle(file.filename, for: .normal)
    }
}

private extension FileCollectionViewCell {
    func makeUI() {
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(didTapFile), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            button.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    @objc
    private func didTapFile() {
        delegate?.didTapFile(file?.rawURL ?? "")
    }
}
