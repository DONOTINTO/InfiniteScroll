//
//  StoryTableViewCell.swift
//  InfiniteScroll
//
//  Created by 이중엽 on 2023/05/19.
//

import UIKit
import SnapKit

class StoryTableViewCell: UITableViewCell {
    let myLabel = UILabel()
    
    func initialSetup() {
        self.contentView.addSubview(myLabel)
    }
    
    func makeUI() {
        myLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView.snp.edges)
        }
    }
}
