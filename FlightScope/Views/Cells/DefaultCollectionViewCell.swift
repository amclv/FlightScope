//
//  DefaultCollectionViewCell.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/26/21.
//

import UIKit

class DefaultCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "DefaultCollectionViewCell"
    
    let locationName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        constraints()
    }
}

extension DefaultCollectionViewCell {
    private func constraints() {
        contentView.addSubview(locationImageView)
        locationImageView.addConstraintsToFillView(contentView)
        
        contentView.addSubview(locationName)
        locationName.anchor(bottom: contentView.bottomAnchor,
                            leading: contentView.leadingAnchor,
                            trailing: contentView.trailingAnchor)
    }
}
