//
//  SmallListHeader.swift
//  AppStore
//
//  Created by 김후정 on 2022/06/24.
//

import UIKit

class SmallListHeader: UICollectionReusableView {

    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var btnAll: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureHeader()
    }
    
    private func configureHeader() {
        tvTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        tvTitle.textColor = .black
        
        btnAll.backgroundColor = .clear
        btnAll.setTitle("모두보기", for: .normal)
    }
    
    func setHeader(header: String) {
        tvTitle.text = header
    }
}
