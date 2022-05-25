//
//  ContentCollectionViewCell.swift
//  NetflixStyleApp
//
//  Created by 김후정 on 2022/06/13.
//

import UIKit
import SnapKit

class ContentCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(imageView)
        
        // imageView에 AutoLayout 설정
        imageView.snp.makeConstraints {
            // 상하좌우가 모든 엣지에 맞도록 설정
            $0.edges.equalToSuperview()
        }
    }
}
