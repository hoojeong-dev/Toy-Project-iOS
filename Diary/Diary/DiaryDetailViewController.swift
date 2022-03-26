//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 김후정 on 2022/03/25.
//

import UIKit

// 일기장 삭제를 위한 delegate
protocol DiaryDetailViewDelegate: AnyObject {
    func didSelectDelete(indexPath: IndexPath)
}

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // 일기장 리스트에서 전달받을 일기를 저장하는 프로퍼티
    var diary: Diary?
    var indexPath: IndexPath?
    
    weak var delegate: DiaryDetailViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    // 일기장 리스트에서 선택한 일기로 화면 설정
    private func configureView() {
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @IBAction func tapEditButton(_ sender: Any) {
        
    }
    
    // 삭제 버튼을 눌렀을 때 실행되는 메서드
    @IBAction func tapDeleteButton(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)

    }
}
