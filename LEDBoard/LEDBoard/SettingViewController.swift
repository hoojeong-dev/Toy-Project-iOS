//
//  SettingViewController.swift
//  LEDBoard
//
//  Created by 김후정 on 2022/03/15.
//

import UIKit

class SettingViewController: UIViewController {

    
    @IBOutlet weak var textField: UITextField!
    
    // 사용자가 색상 버튼을 선택하면, 선택한 버튼의 알파 겂은 1로, 나머지의 알파 값은 0.2로 변경한다.
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 액션 함수를 하나만 설정해놓고, 다른 것들을 우클릭으로 연결해주면 됨
    // 누가 클릭했는지는 sender 파라미터로 알 수 있음. (선택하면 선택한 버튼의 인스턴스를 전달하기 때문 )
    @IBAction func tapTextColorButton(_ sender: UIButton) {
        // 먼저 어떤 버튼을 선택했는지 알아야 한다.
        // sender와 버튼 아울렛 변수를 비교하면 된다.
        if sender == self.yellowButton {
            self.changeTextColor(color: .yellow)
        } else if sender == self.purpleButton {
            self.changeTextColor(color: .purple)
        } else {
            self.changeTextColor(color: .green)
        }
    }
    
    @IBAction func tapBackgroundColorButton(_ sender: UIButton) {
        if sender == self.blackButton {
            self.changeBackgroundColor(color: .black)
        } else if sender == self.blueButton {
            self.changeBackgroundColor(color: .blue)
        } else {
            self.changeBackgroundColor(color: .orange)
        }
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
        
    }
    
    private func changeTextColor(color: UIColor) {
        // 삼항연산자를 사용해, yellowButton의 알파 값을 만약 UIColor가 yellow 라면 1로, 아니라면 0.2로 설정한다.
        self.yellowButton.alpha = color == UIColor.yellow ? 1 : 0.2
        self.purpleButton.alpha = color == UIColor.purple ? 1 : 0.2
        self.greenButton.alpha = color == UIColor.green ? 1 : 0.2
    }
    
    private func changeBackgroundColor(color: UIColor) {
        self.blackButton.alpha = color == UIColor.black ? 1 : 0.2
        self.blueButton.alpha = color == UIColor.blue ? 1 : 0.2
        self.orangeButton.alpha = color == UIColor.orange ? 1 : 0.2
    }
}
