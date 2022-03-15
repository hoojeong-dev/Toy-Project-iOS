//
//  ViewController.swift
//  LEDBoard
//
//  Created by 김후정 on 2022/03/15.
//

import UIKit

class ViewController: UIViewController, LEDBoardSettingDelegate {

    @IBOutlet weak var contentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 초기 글자 색을 노란색으로 설정
        self.contentsLabel.textColor = .yellow
    }

    // Segue로 구현했기 때문에 prepare메서드 사용
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue.destination를 사용해 SettingViewController의 인스턴스를 가져온 뒤,
        // SettingViewController로 다운캐스팅
        if let settingViewController = segue.destination as? SettingViewController {
            // SettingViewController의 delegate로 위임받기
            settingViewController.delegate = self
            
            // 색을 변경한 뒤, 다시 설정 창으로 넘어갈 때 변경된 값으로 선택되어 있도록 변경한 값을 다시 넘겨줌
            settingViewController.ledText = self.contentsLabel.text
            settingViewController.textColor = self.contentsLabel.textColor
            // 만약 옵셔널이라면(nil) black로 설정
            settingViewController.backgroundColor = self.view.backgroundColor ?? .black
        }
    }
    
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor) {
        // 이전 화면에서 전달하는 색상 값들로 뷰를 초기화
        if let text = text {
            self.contentsLabel.text = text
        }
        
        self.contentsLabel.textColor = textColor
        self.view.backgroundColor = backgroundColor
        
        // 이렇게 하면 색상을 변경한 뒤, 저장을 하면 뷰에 정상적으로 표시되지만
        // 다시 설정 뷰로 돌아가면 바뀐 색상으로 나타나지 않음
        // 그래서 설정 뷰로 넘어갈 때 값을 변경해주는 코드가 필요함
    }
}
