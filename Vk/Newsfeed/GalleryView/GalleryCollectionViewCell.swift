//
//  GalleryCollectionViewCell.swift
//  Vk
//
//  Created by Евгений Кононенко on 22.11.2022.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    static let reuseId = "GalleryCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
    
    
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}