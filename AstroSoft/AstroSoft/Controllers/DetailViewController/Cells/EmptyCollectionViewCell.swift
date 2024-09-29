//
//  EmptyCollectionViewCell.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 28.09.2024.
//

import UIKit

final class EmptyCollectionViewCell: ASCollectionViewCell {
    func configure(color: UIColor = .clear, height: CGFloat) {
        contentView.backgroundColor = color
        contentView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
