//
//  DefaultCollectionViewCell.swift
//  FlightScope
//
//  Created by Aaron Cleveland on 1/26/21.
//

import UIKit

class DefaultCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String = "DefaultCollectionViewCell"
    let locationName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        constraints()
        
        locationName.font = .systemFont(ofSize: 16.0, weight: .semibold)
        locationName.textColor = .label
    }
}

extension DefaultCollectionViewCell {
    private func constraints() {
        contentView.addSubview(locationName)
        locationName.center(inView: contentView)
    }
}
