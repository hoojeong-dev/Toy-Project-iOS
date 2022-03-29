//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by 김후정 on 2022/03/29.
//

import UIKit

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    // 타이머에 설정된 시간을 초로 저장하는 프로퍼티
    var duration = 60
    
    // 타이머의 상태를 저장하는 프로퍼티
    var timerStatus: TimerStatus = .end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }

    
    
    // 타이머의 상태에 따라 toggleButton을 바꾸는 메서드
    func configureToggleButton() {
        // 초기에는 시작 버튼
        self.toggleButton.setTitle("시작", for: .normal)
        // 시작 버튼을 누른 이후라면, 일시정지 버튼
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    

    
    // 시작 버튼을 눌렀을 때 호출되는 메서드
    @IBAction func tapToggleButton(_ sender: Any) {
        // countDownDuration은 datePiker에서 선택한 시간을 초로 전달함
        self.duration = Int(self.datePicker.countDownDuration)
        
        switch self.timerStatus {
        case .end:
            self.timerStatus = .start
            // 타이머가 끝났다면, timerLabel, progressView를 안 보이게 하고, datePicker를 보이게 변경
            self.setTimerInfoViewVisvle(isHidden: false)
            self.datePicker.isHidden = true
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
        
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
        }
    }
    
    // 타이머의 상태에 따라 timerLabel, progressView를 보이게/안 보이게 하는 메서드
    func setTimerInfoViewVisvle(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    
    
    // 취소 버튼을 눌렀을 때 호출되는 메서드
    @IBAction func tapCancelButton(_ sender: Any) {
        switch self.timerStatus {
        case .start, .pause:
            self.timerStatus = .end
            self.cancelButton.isEnabled = false
            self.setTimerInfoViewVisvle(isHidden: true)
            self.datePicker.isHidden = false
            self.toggleButton.isSelected = false
        
        default:
            break
        }
    }
}

