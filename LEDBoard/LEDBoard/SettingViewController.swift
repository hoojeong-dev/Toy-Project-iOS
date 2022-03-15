//
//  SettingViewController.swift
//  LEDBoard
//
//  Created by 김후정 on 2022/03/15.
//

import UIKit

protocol LEDBoardSettingDelegate: AnyObject {
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor)
}

class SettingViewController: UIViewController {

    
    @IBOutlet weak var textField: UITextField!
    
    // 사용자가 색상 버튼을 선택하면, 선택한 버튼의 알파 겂은 1로, 나머지의 알파 값은 0.2로 변경
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    
    // delegate 프로퍼티 추가
    weak var delegate: LEDBoardSettingDelegate?
    
    // 사용자가 입력한 문자를 저장하는 프로퍼티
    var ledText: String?
    
    // 설정된 값을 changedSetting 메서드에 전달하기 위해 텍스트와 배경 컬러 프로퍼티를 추가
    // 사용자가 버튼을 선택할 때마다 이 프로퍼티에 색이 저장됨
    // 기본 값은 각각 yellow, black로 초기화
    var textColor: UIColor = .yellow
    var backgroundColor: UIColor = .black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    // 전달 받은 값으로 뷰를 초기화
    // 색을 바꾸고 전광판으로 돌아갔다가 설정창으로 오면, 내가 바꿔놨던 색으로 선택되어있지 않기 때문
    private func configureView() {
        if let ledText = self.ledText {
            self.textField.text = ledText
        }
        self.changeTextColor(color: self.textColor)
        self.changeBackgroundColor(color: self.backgroundColor)
    }
    // 액션 함수를 하나만 설정해놓고, 다른 것들을 우클릭으로 연결해주면 됨
    // 누가 클릭했는지는 sender 파라미터로 알 수 있음. (선택하면 선택한 버튼의 인스턴스를 전달하기 때문 )
    @IBAction func tapTextColorButton(_ sender: UIButton) {
        // 먼저 어떤 버튼을 선택했는지 알아야 한다.
        // sender와 버튼 아울렛 변수를 비교하면 된다.
        if sender == self.yellowButton {
            self.changeTextColor(color: .yellow)
            self.textColor = .yellow
        } else if sender == self.purpleButton {
            self.changeTextColor(color: .purple)
            self.textColor = .purple
        } else {
            self.changeTextColor(color: .green)
            self.textColor = .green
        }
    }
    
    @IBAction func tapBackgroundColorButton(_ sender: UIButton) {
        if sender == self.blackButton {
            self.changeBackgroundColor(color: .black)
            self.backgroundColor = .black
        } else if sender == self.blueButton {
            self.changeBackgroundColor(color: .blue)
            self.backgroundColor = .blue
        } else {
            self.changeBackgroundColor(color: .orange)
            self.backgroundColor = .orange
        }
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
        // 저장 버튼을 누르면, changedSetting 메서드를 호출하여 선택된 색상을 넘겨줌
        self.delegate?.changedSetting(text: self.textField.text,
                                      textColor: textColor,
                                      backgroundColor: backgroundColor)
        
        // 설정한 뒤, 이전 화면으로 이동
        self.navigationController?.popViewController(animated: true)
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
