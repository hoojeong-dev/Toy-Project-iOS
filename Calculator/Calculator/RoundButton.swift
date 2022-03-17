//
//  RoundButton.swift
//  Calculator
//
//  Created by 김후정 on 2022/03/17.
//

// 버튼에 적용할 속성 코드
import UIKit

// 값이 변경되면, 스토리보드 상에서 실시간으로 확인할 수 있도록 함
// 하지만 이를 남용하면 스토리보드를 열 때마다 빌드가 되어서 버벅일 수 있음
@IBDesignable
class RoundButton: UIButton {

    // @IBInspectable 어노테이션은 스토리보드에서도 isRound의 설정 값을 변경시킬 수 있도록 함
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                // cornerRadius 값을 버튼 높이를 2로 나눈 값으로 설정
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }

}
