//
//  StackOverFlowUserCellTableViewCell.swift
//  StackOverFlowTest
//
//  Created by Arbi Derhartunian on 9/28/19.
//  Copyright © 2019 com.green. All rights reserved.
//

import UIKit

enum badgeType: String {
    
    case gold
    case silver
    case bronze
    
    func color() -> UIColor {
        switch self {
        case .gold:
            return UIColor.orange
        case .bronze:
            return  UIColor(red: 205 / 255.0, green: 127 / 255.0, blue: 50 / 255.0, alpha: 1)
        case .silver:
            return  UIColor(red: 192 / 255.0, green: 192 / 255.0, blue: 192 / 255.0, alpha: 1)
        }
    }
}

class StackOverFlowUserCellTableViewCell: UITableViewCell {
    
    static let ReusableID = "StackOverFlowUserReuseId"
    
    let gravatar: UIImageView = {
        let gravatar = UIImageView()
        gravatar.contentMode = .scaleAspectFit
        return gravatar
    }()
    
    let reputationCountLabel: UILabel = {
        let repuationCountLabel = UILabel()
        repuationCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        repuationCountLabel.textAlignment = .left
        return repuationCountLabel;
    }()
    
    let goldCountLabel: UILabel = {
        let goldBronzeCountLabel = UILabel()
        goldBronzeCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        goldBronzeCountLabel.textAlignment = .left
        return goldBronzeCountLabel;
    }()
    
    let sliverCountLabel: UILabel = {
        let sliverCountLabel = UILabel()
        sliverCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        sliverCountLabel.textAlignment = .left
        return sliverCountLabel;
    }()
    
    let bronzeCountLabel: UILabel = {
        let bronzeCountLabel = UILabel()
        bronzeCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        bronzeCountLabel.textAlignment = .left
        return bronzeCountLabel;
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension StackOverFlowUserCellTableViewCell {
    
    func configureCell() {
        
    }

}
