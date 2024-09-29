//
//  AvatarCollectionViewCell.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 28.09.2024.
//

import UIKit

final class AvatarCollectionViewCell: ASCollectionViewCell {
    // MARK: - UI
    private let avatar: ImageLoader = {
        let imageView = ImageLoader()
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func initialSetup() {
        makeUI()
    }
}

extension AvatarCollectionViewCell {
    func configure(avatarUrl: String) {
        guard let imageUrl = URL(string: avatarUrl) else { return }
        avatar.loadImageWithUrl(imageUrl)
    }
}

private extension AvatarCollectionViewCell {
    func makeUI() {
        contentView.addSubview(avatar)
        NSLayoutConstraint.activate([
            avatar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 100),
            avatar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
