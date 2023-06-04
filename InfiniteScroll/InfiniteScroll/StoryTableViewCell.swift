//
//  StoryTableViewCell.swift
//  InfiniteScroll
//
//  Created by 이중엽 on 2023/05/19.
//

import UIKit
import SnapKit

class StoryTableViewCell: UITableViewCell {
    let thumbnailImage = UIImageView()
    let myLabel = UILabel()
    
    func initialSetup() {
        self.contentView.addSubview(thumbnailImage)
        self.contentView.addSubview(myLabel)
    }
    
    func makeUI() {
        thumbnailImage.snp.makeConstraints {
            $0.height.width.equalTo(100)
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
            $0.trailing.equalTo(myLabel.snp.leading).offset(-10)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
        myLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.leading.equalTo(thumbnailImage.snp.trailing).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-10)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
}
