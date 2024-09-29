//
//  GistCell.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 27.09.2024.
//

import UIKit

final class GistCell: UITableViewCell, Reusable {
    private let avatar: ImageLoader = {
        let imageView = ImageLoader()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameOwner: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = nil
    }
}

// MARK: - Private methods
private extension GistCell {
    private func makeUI() {
        backgroundColor = .clear
        
        contentView.addSubview(avatar)
        contentView.addSubview(nameOwner)
        contentView.addSubview(title)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 50),
            avatar.heightAnchor.constraint(equalToConstant: 50),
            
            nameOwner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameOwner.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            nameOwner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 37),
            title.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
}

// MARK: - Public methods
extension GistCell {
    func configure(avatarUrl: String, title: String, nameOwner: String) {
        self.nameOwner.text = nameOwner
        self.title.text = title 
        
        guard let imageUrl = URL(string: avatarUrl) else { return }
        avatar.loadImageWithUrl(imageUrl)
    }
}
