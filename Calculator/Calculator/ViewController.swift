//
//  ViewController.swift
//  Calculator
//
//  Created by 김후정 on 2022/03/17.
//

import UIKit

enum Operation {
    case Add
    case Subtract
    case Divide
    case Multiply
    case unknown
}
class ViewController: UIViewController {
    
    @IBOutlet weak var numberOutputLabel: UILabel!
    
    // 계산기 버튼을 누를 때마다 numberOutputLabel에 표시될 프로퍼티
    var displayNumber = ""
    // 이전 계산 값을 저장하는 프로퍼티 (첫번째 피연산자)
    var firstOperand = ""
    // 새롭게 입력된 값을 저장되는 프로퍼티 (두번째 피연산자)
    var secondOperand = ""
    // 계산의 결과 값을 저장하는 프로퍼티
    var result = ""
    // 사용자가 누른 연산자를 저장하는 프로퍼티
    var currentOperation: Operation = .unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapNumberButton(_ sender: UIButton) {
        // 사용자가 숫자 버튼을 누를 때마다 numberOutputLabel에 표시되어야 함
        guard let numberValue = sender.title(for: .normal) else { return }
        // 숫자는 9자리까지만 입력할 수 있도록 함
        if self.displayNumber.count < 9 {
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) {
        // 사용자가 AC 버튼을 누르면 모든 프로퍼티를 초기화 하고, numberOutputLabel에는 0을 표시함
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.numberOutputLabel.text = "0"
    }
    
    @IBAction func tapDotButton(_ sender: UIButton) {
        // 사용자가 .버튼을 누르면 소수점을 추가함
        // 총 8자리보다 작고, 소수점이 없을 때만 추가할 수 있도록 한다
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            // 삼항연산자를 사용해 displayNumber가 비어있다면 0.을, 아니라면 .을 추가한다
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    
    @IBAction func tapMultiplyButton(_ sender: UIButton) {
        self.operation(.Multiply)
    }
    
    @IBAction func tapSubtractButton(_ sender: UIButton) {
        self.operation(.Subtract)
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        self.operation(.Add)
    }
    
    @IBAction func tapEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    func operation(_ operation: Operation) {
        // 3 + 4 라고 한다면, firstOperand = 3, currentOperation = "+", secondOperand = 4
        if self.currentOperation != .unknown { // 첫번째와 두번째 피연산자 연산
            if !self.displayNumber.isEmpty {
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                
                guard let firstOperand = Double(self.firstOperand) else { return }
                guard let secondOperand = Double(self.secondOperand) else { return }
                
                switch self.currentOperation {
                case .Add:
                    self.result = "\(firstOperand + secondOperand)"
                case .Subtract:
                    self.result = "\(firstOperand - secondOperand)"
                case .Multiply:
                    self.result = "\(firstOperand * secondOperand)"
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                default:
                    break
                }
                
                // result를 1로 나눴을 때 0이라면 정수로 변환한다.
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))"
                }
                
                // 연산이 끝난 뒤, 다시 연산을 할 수 있으므로 결과를 첫번째 피연산자에 넣기
                self.firstOperand = self.result
                self.numberOutputLabel.text = self.result
            }
            
            self.currentOperation = operation
            
        } else { // 사용자가 첫번째 피연산자와 연산자를 입력한 상태
            self.firstOperand = self.displayNumber
            self.currentOperation = operation
            self.displayNumber = ""
        }
    }
}

