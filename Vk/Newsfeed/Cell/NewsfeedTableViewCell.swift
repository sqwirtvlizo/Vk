//
//  NewsFeedTableViewCell.swift
//  Vk
//
//  Created by Евгений Кононенко on 18.11.2022.
//

import UIKit

protocol FeedCellViewModel {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var photoAttachments: [FeedCellPhotoAttachmentViewModel] { get }
    var sizes: FeedCellSizes { get }
} 

protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomView: CGRect { get }
    var totalHieght: CGFloat { get }
    var moreTextButtonFrame: CGRect { get }
}

protocol FeedCellPhotoAttachmentViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

protocol NewsfeedCellDelegate: AnyObject {
    func revealPost(cell: NewsfeedTableViewCell)
}

class NewsfeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sharesView: UIView!
    
    @IBOutlet weak var imageCellView: WebImageView!
    
    @IBOutlet weak var postImageCellView: WebImageView!
    
    @IBOutlet weak var trailingLikeImageConstraintToLabel: NSLayoutConstraint!
    
    @IBOutlet weak var trilingShareImageConstraintToLabel: NSLayoutConstraint!
    @IBOutlet weak var trailingCommentImageConstraintToLabel: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var countViewLabel: UILabel!
    @IBOutlet weak var countSharesLabel: UILabel!
    @IBOutlet weak var countCommentsLabel: UILabel!
    @IBOutlet weak var countLikesLabel: UILabel!
    static let reuseId = "NewsfeedCell"
    
    weak var delegate: NewsfeedCellDelegate?
    
    let moreTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 15)
        button.setTitleColor(UIColor(red: 0.161, green: 0.459, blue: 0.8, alpha: 1), for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Показать полностью...", for: .normal)
        return button
    }()
    
    var galleryCollectionView = GalleryCollectionView()
    
    override func prepareForReuse() {
        imageCellView.set(imageUrl: nil)
        postImageCellView.set(imageUrl: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 15
        countViewLabel.textColor = UIColor(red: 0.506, green: 0.549, blue: 0.6, alpha: 1)
        countSharesLabel.textColor = UIColor(red: 0.506, green: 0.549, blue: 0.6, alpha: 1)
        countCommentsLabel.textColor = UIColor(red: 0.506, green: 0.549, blue: 0.6, alpha: 1)
        countLikesLabel.textColor = UIColor(red: 0.506, green: 0.549, blue: 0.6, alpha: 1)
        dateLabel.textColor = UIColor(red: 0.506, green: 0.549, blue: 0.6, alpha: 1)
        sharesView.layer.backgroundColor = UIColor(red: 0, green: 0.11, blue: 0.239, alpha: 0.05).cgColor
        likesView.layer.backgroundColor = UIColor(red: 0, green: 0.11, blue: 0.239, alpha: 0.05).cgColor
        commentsView.layer.backgroundColor = UIColor(red: 0, green: 0.11, blue: 0.239, alpha: 0.05).cgColor
        commentsView.layer.cornerRadius = 12
        likesView.layer.cornerRadius = 12
        sharesView.layer.cornerRadius = 12
        imageCellView.layer.cornerRadius = imageCellView.frame.width / 2
        selectionStyle = .none
        self.contentView.addSubview(galleryCollectionView)
        self.contentView.addSubview(moreTextButton)
        moreTextButton.addTarget(self, action: #selector(moreTextButtonTouch), for: .touchUpInside)
    }
    
    @objc
    private func moreTextButtonTouch() {
        delegate?.revealPost(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func set(viewModel: FeedCellViewModel) {
        imageCellView.set(imageUrl: viewModel.iconUrlString)
        print(viewModel)
        setLayoutOnBottomBlock(str: viewModel.likes, label: countLikesLabel, constr: trailingLikeImageConstraintToLabel)
        setLayoutOnBottomBlock(str: viewModel.comments, label: countCommentsLabel, constr: trailingCommentImageConstraintToLabel)
        setLayoutOnBottomBlock(str: viewModel.shares, label: countSharesLabel, constr: trilingShareImageConstraintToLabel)
        nameLabel.text = viewModel.name
        postLabel.text = viewModel.text
        dateLabel.text = viewModel.date
        countLikesLabel.text = viewModel.likes
        countSharesLabel.text = viewModel.shares
        countCommentsLabel.text = viewModel.comments
        countViewLabel.text = viewModel.views
        postLabel.frame = viewModel.sizes.postLabelFrame
        bottomView.frame = viewModel.sizes.bottomView
        moreTextButton.frame = viewModel.sizes.moreTextButtonFrame
        if let photoAttachment = viewModel.photoAttachments.first, viewModel.photoAttachments.count == 1 {
            postImageCellView.set(imageUrl: photoAttachment.photoUrlString)
            postImageCellView.isHidden = false
            galleryCollectionView.isHidden = true
            postImageCellView.frame = viewModel.sizes.attachmentFrame
        } else if viewModel.photoAttachments.count > 1 {
            galleryCollectionView.frame = viewModel.sizes.attachmentFrame
            postImageCellView.isHidden = true
            galleryCollectionView.isHidden = false
            galleryCollectionView.set(photos: viewModel.photoAttachments)
        } else {
            postImageCellView.isHidden = true
            galleryCollectionView.isHidden = true
        }
        
    }
    
    private func setLayoutOnBottomBlock(str: String?, label: UILabel, constr: NSLayoutConstraint) {
        if str == "0" {
            label.isHidden = true
            label.text = ""
            constr.constant = -7
        } else {
            constr.constant = 2
            label.isHidden = false
        }
    }
}
