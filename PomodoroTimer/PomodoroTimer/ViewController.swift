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
    
    // DispatchSourceTimer는 GCD에 포함되어 있어, 병렬처리를 위해 사용한다고 함
    var timer: DispatchSourceTimer?
    
    // 현재 카운트되고 있는 시간을 초로 저장하는 프로퍼티
    var currentSeconds = 0
    
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

    
    
    // 타이머를 설정하고 시작하는 메서드
    func startTimer() {
        if self.timer == nil{
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                self?.currentSeconds -= 1
                debugPrint(self?.currentSeconds)
                
                // 타이머의 시간이 다 되었을 경우
                if self?.currentSeconds ?? 0 <= 0 {
                    self?.stopTimer()
                }
            })
            
            self.timer?.resume()
        }
    }
    
    
    
    // 타이머를 종료하는 메서드
    func stopTimer() {
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        self.setTimerInfoViewVisvle(isHidden: true)
        self.datePicker.isHidden = false
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        
        // 종료하고 nil로 초기화하지 않으면 안됨
        // suspend() 메서드를 호출한 뒤에 nil로 초기화를 하게 되면
        // 아직 수행해야 하는 작업이 남았기 때문에 런타임 에러가 발생함
        // 때문에 만약 일시정지 상태라면, 먼저 resume() 메서드를 호출해야 함
        self.timer = nil
    }

    
    
    // 시작 버튼을 눌렀을 때 호출되는 메서드
    @IBAction func tapToggleButton(_ sender: Any) {
        // countDownDuration은 datePiker에서 선택한 시간을 초로 전달함
        self.duration = Int(self.datePicker.countDownDuration)
        
        switch self.timerStatus {
        case .end:
            self.currentSeconds = self.duration
            self.timerStatus = .start
            // 타이머가 끝났다면, timerLabel, progressView를 안 보이게 하고, datePicker를 보이게 변경
            self.setTimerInfoViewVisvle(isHidden: false)
            self.datePicker.isHidden = true
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            self.startTimer()
        
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            self.timer?.suspend()
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
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
            self.stopTimer()
            
        default:
            break
        }
    }
}

