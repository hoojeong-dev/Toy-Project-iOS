//
//  ViewController.swift
//  LEDBoard
//
//  Created by 김후정 on 2022/03/15.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 초기 글자 색을 노란색으로 설정
        self.contentsLabel.textColor = .yellow
    }


}

