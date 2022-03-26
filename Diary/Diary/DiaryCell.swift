//
//  DiaryCell.swift
//  Diary
//
//  Created by 김후정 on 2022/03/25.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // 이 생성자는 UI뷰가 생성될 때, 이를 통해 객체가 생성된다.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
}
