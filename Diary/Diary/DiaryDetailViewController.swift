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
    
    
    
    // 수정 버튼을 누르면, 일기 작성 페이지로 이동
    @IBAction func tapEditButton(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        
        // WriteDiaryViewController로 넘어가기 전에 수정모드로 indexPath, diary 값을 넘겨줌
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        viewController.diaryEditorMode = .edit(indexPath, diary)

        // 수정 버튼을 눌렀을 때 editDiary Notification을 관찰하는 옵저버 추가
        // WriteDiaryViewController에서 수정된 객체가 NotificationCenter를 통해서 호스트 될 때 editDiaryNotification 메서드가 호출 됨
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: NSNotification.Name("editDiary"), object: nil)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // NotificationCenter를 통해 수정되었을 때 일기 상세보기를 갱신함
    @objc func editDiaryNotification(_ notification: Notification){
        guard let diary = notification.object as? Diary else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary
        self.configureView()
    }
    
    
    
    // 삭제 버튼을 눌렀을 때 실행되는 메서드
    @IBAction func tapDeleteButton(_ sender: Any) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
