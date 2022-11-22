//
//  NewsfeedLayoutCalculator.swift
//  Vk
//
//  Created by Евгений Кононенко on 18.11.2022.
//

import Foundation
import UIKit

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, attachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes
}

struct Constants {
    //    static let inserts = UIEdgeInsets(top: <#T##CGFloat#>, left: <#T##CGFloat#>, bottom: <#T##CGFloat#>, right: <#T##CGFloat#>)
    static let topViewHeight = 42
    static let postLabelInserts = UIEdgeInsets(top: CGFloat(Constants.topViewHeight + 12), left: 11, bottom: 11, right: 8)
    static let postLabelFont = UIFont(name: "SFProDisplay-Medium", size: 15)
    static let bottomViewHeight: CGFloat = 42
    static let minifiedPostLimitLines: CGFloat = 8
    static let minifiedPostLines: CGFloat = 6
    static let moreTextButtonSize = CGSize(width: 170, height: 15)
    static let moreTextButtonInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    
}

struct Sizes: FeedCellSizes {
    var moreTextButtonFrame: CGRect
    var bottomView: CGRect
    var totalHieght: CGFloat
    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
}

final class NewsfeedLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, attachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes {
        var showMoreTextButton = false
        
        let viewWidth = screenWidth
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInserts.left, y: Constants.postLabelInserts.top), size: CGSize.zero)
        if let text = postText, !text.isEmpty {
            let width = viewWidth - Constants.postLabelInserts.left - Constants.postLabelInserts.right
            
            if let font = Constants.postLabelFont {
                
                
                var height = text.height(width: width, font: font)
                
                let limitHeight = font.lineHeight * Constants.minifiedPostLines
                
                if height > limitHeight && !isFullSizedPost {
                    height = font.lineHeight * Constants.minifiedPostLines
                    showMoreTextButton = true
                }
                postLabelFrame.size = CGSize(width: width, height: height)
            }
        }
        var moreTextButtonSize = CGSize.zero
        
        if showMoreTextButton  {
            moreTextButtonSize = Constants.moreTextButtonSize
        }
        
        let moreTextButtonOrigin = CGPoint(x: postLabelFrame.minX, y: postLabelFrame.maxY)
        
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInserts.top : moreTextButtonFrame.maxY + Constants.postLabelInserts.bottom
        
        var attachmentFrame = CGRect(origin: CGPoint(x: 5, y: attachmentTop), size: CGSize.zero)
        
        //        if let attachment = attachment  {
        //            let photoHeight: Float = Float(attachment.height)
        //            let photoWidth: Float = Float(attachment.width - 4)
        //            let ratio = CGFloat(photoHeight / photoWidth)
        //            attachmentFrame.size = CGSize(width: viewWidth - 8, height: viewWidth * ratio)
        //        }
        if let attachment = attachments.first {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width - 4)
            let ratio = CGFloat(photoHeight / photoWidth)
            if attachments.count == 1 {
                attachmentFrame.size = CGSize(width: viewWidth - 8, height: viewWidth * ratio)
            } else if attachments.count > 1 {
                attachmentFrame.size = CGSize(width: viewWidth - 8, height: viewWidth * ratio)
            }
        }
        
        let bottonViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottonViewTop), size: CGSize(width: viewWidth, height: Constants.bottomViewHeight))
        
        let totalheight = bottomViewFrame.maxY
        return Sizes(moreTextButtonFrame: moreTextButtonFrame, bottomView: bottomViewFrame, totalHieght: totalheight, postLabelFrame: postLabelFrame, attachmentFrame: attachmentFrame)
        
    }
    
}

