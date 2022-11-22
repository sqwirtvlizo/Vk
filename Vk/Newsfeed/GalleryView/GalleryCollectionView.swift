//
//  GalleryCollectionView.swift
//  Vk
//
//  Created by Евгений Кононенко on 22.11.2022.
//

import Foundation
import UIKit

class GalleryCollectionView: UICollectionView{
    
    var photos = [FeedCellPhotoAttachmentViewModel]()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.collectionView?.isPagingEnabled = true
        super.init(frame: .zero, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        backgroundColor = .green
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
        reloadData()
    }
    
    fileprivate var sectionInsets: UIEdgeInsets {
            return .zero
        }

        fileprivate var itemsPerRow: CGFloat {
            return 2
        }

        fileprivate var interitemSpace: CGFloat {
            return 5.0
        }

}


extension GalleryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as! GalleryCollectionViewCell
        cell.set(imageUrl: photos[indexPath.row].photoUrlString)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


        var width = CGFloat()
        var height = CGFloat()
//        switch photos.count {
//        case 2:
//            width = frame.width / 2
//            height = CGFloat(photos[indexPath.row].height) / 2
//        case 3:
//
//            if indexPath.row == 0 {
//                width = frame.width / 2
//                height = frame.height / 2
//            } else {
//                width = frame.width / 2
//                height = frame.height / 4
//            }
//        default:
//            width = 200
//            height = 200
//        }

        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)

    }
//    func collectionView(_ collectionView: UICollectionView,
//                          layout collectionViewLayout: UICollectionViewLayout,
//                          sizeForItemAt indexPath: IndexPath) -> CGSize {
//          let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
//          let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
//          let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
//          let widthPerItem = availableWidth / itemsPerRow
//
//          return CGSize(width: widthPerItem, height: widthPerItem)
//      }
//
//      func collectionView(_ collectionView: UICollectionView,
//                          layout collectionViewLayout: UICollectionViewLayout,
//                          insetForSectionAt section: Int) -> UIEdgeInsets {
//          return sectionInsets
//      }
//
//      func collectionView(_ collectionView: UICollectionView,
//                          layout collectionViewLayout: UICollectionViewLayout,
//                          minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//          return 0.0
//      }
//
//      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//          return interitemSpace
//      }
    
    
    
}
