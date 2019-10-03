//
//  StackOverFlowUserCellTableViewCell.swift
//  StackOverFlowTest
//
//  Created by Arbi Derhartunian on 9/28/19.
//  Copyright © 2019 com.green. All rights reserved.
//

import UIKit
import SDWebImage

enum badgeType: String {
    case gold
    case silver
    case bronze
    
    func color() -> UIColor {
        switch self {
        case .gold:
            return UIColor.orange
        case .bronze:
            return  UIColor.bronze
        case .silver:
            return   UIColor.sliver
        }
    }
}

class SOFUserCellTableViewCell: UITableViewCell {
    
    static let ReusableID = "StackOverFlowUserReuseId"
    var circles:[UIView] = [UIView]()
    
    private let circle: UIView = {
        let circle = UIView(frame: .zero)
        circle.layer.cornerRadius = 20
        circle.clipsToBounds = true
        return circle
    }()
    
    private let containerView = UIView.newAutoLayout()
    
    private let badgeStackView: UIStackView = {
        let badgeStackView = UIStackView()
        badgeStackView.alignment = .fill
        badgeStackView.axis = .horizontal
        badgeStackView.distribution = .fill
        badgeStackView.spacing = 4
        return badgeStackView
    }()
    
    private let gravatar: UIImageView = {
        let gravatar = UIImageView()
        gravatar.contentMode = .scaleAspectFit
        return gravatar
    }()
    
    private let reputationCountLabel: UILabel = {
        let repuationCountLabel = UILabel()
        repuationCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        repuationCountLabel.textAlignment = .left
        return repuationCountLabel;
    }()
    
    private let goldCountLabel: UILabel = {
        let goldBronzeCountLabel = UILabel()
        goldBronzeCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        goldBronzeCountLabel.textAlignment = .left
        return goldBronzeCountLabel;
    }()
    
    private let sliverCountLabel: UILabel = {
        let sliverCountLabel = UILabel()
        sliverCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        sliverCountLabel.textAlignment = .left
        return sliverCountLabel;
    }()
    
    private let bronzeCountLabel: UILabel = {
        let bronzeCountLabel = UILabel()
        bronzeCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        bronzeCountLabel.textAlignment = .left
        return bronzeCountLabel;
    }()
    
    private let displayName: UILabel = {
        let displayName = UILabel()
        displayName.font = UIFont.systemFont(ofSize: 12, weight: .light)
        displayName.textAlignment = .left
        return displayName;
    }()
    
    private func getCircle(color: badgeType) -> UIView {
        let circle = UIView(frame: .zero)
        circle.layer.cornerRadius = 5
        circle.clipsToBounds = true
        circle.layer.backgroundColor = color.color().cgColor
        circle.autoSetDimensions(to: CGSize(width: 10, height: 10))
        return circle
    }
    
    private func assembleCircles() {
        circles =  [getCircle(color: .bronze),bronzeCountLabel, getCircle(color: .gold), goldCountLabel, getCircle(color: .silver), sliverCountLabel]
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        containerView.addSubview(displayName)
        containerView.addSubview(reputationCountLabel)
        contentView.addSubview(gravatar)
        assembleCircles()
    circles.forEach({badgeStackView.addArrangedSubview($0)})
        containerView.addSubview(badgeStackView)
        contentView.addSubview(containerView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        gravatar.autoPinEdge(toSuperviewEdge: .leading)
        gravatar.autoSetDimension(.width, toSize: 50)
        gravatar.autoPinEdge(toSuperviewEdge: .top)
        gravatar.autoPinEdge(toSuperviewEdge: .bottom)
        
        containerView.autoPinEdge(.leading, to: .trailing, of:gravatar , withOffset: 12)
        containerView.autoPinEdge(toSuperviewEdge: .top)
        containerView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        
        displayName.autoPinEdge(toSuperviewEdge: .leading)
        displayName.autoPinEdge(toSuperviewEdge: .trailing)
        
        reputationCountLabel.autoPinEdge(.top, to: .bottom, of: displayName, withOffset: 8)
        reputationCountLabel.autoPinEdge(toSuperviewEdge: .leading)
        
        reputationCountLabel.autoPinEdge(toSuperviewEdge: .bottom)
        
        badgeStackView.autoPinEdge(.leading, to: .trailing, of: reputationCountLabel, withOffset: 12)
        badgeStackView.autoPinEdge(toSuperviewEdge: .bottom)
        badgeStackView.autoPinEdge(.top, to: .top, of: reputationCountLabel)
        badgeStackView.autoPinEdge(toSuperviewEdge: .bottom)
        badgeStackView.autoPinEdge(toSuperviewEdge: .trailing)
    }
}

private extension SOFUserCellTableViewCell {
    func storeImageToCache(with imageURL: URL, key: String) {
        SDWebImageManager.shared().imageDownloader?.downloadImage(with: imageURL, options: .continueInBackground, progress: nil, completed: { (image, data, error, didFinish) in
            SDImageCache.shared().storeImageData(toDisk: data, forKey: key)
        })
    }
}

extension SOFUserCellTableViewCell {
    
    func configureCell(userData: SOFUserData) {
        if let imageURL = URL(string: userData.imageURL) {
            storeImageToCache(with: imageURL, key: userData.displayName)
            self.gravatar.image = SDImageCache.shared().imageFromCache(forKey: userData.displayName)
            self.gravatar.setNeedsDisplay()
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let number = NSNumber(value: userData.reputation)
        let num = formatter.string(from: number)
        
        reputationCountLabel.text = num
        displayName.text = "\(userData.displayName)"
        goldCountLabel.text = "\(userData.badgeCounts.gold)"
        bronzeCountLabel.text = "\(userData.badgeCounts.bronzeCount)"
        sliverCountLabel.text = "\(userData.badgeCounts.silver)"
        
    }
}
