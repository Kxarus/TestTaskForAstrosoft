//
//  TextCollectionViewCell.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 28.09.2024.
//

import UIKit

final class TextCollectionViewCell: ASCollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    override func initialSetup() {
        makeUI()
    }
    
    func configure(text: String, textSize: CGFloat, alignment: NSTextAlignment = .left) {
        label.text = text
        label.font = .systemFont(ofSize: textSize)
        label.textAlignment = alignment
    }
}

private extension TextCollectionViewCell {
    func makeUI() {
        contentView.addSubview(label)
       
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}
