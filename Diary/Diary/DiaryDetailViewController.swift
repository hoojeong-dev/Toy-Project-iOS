//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 김후정 on 2022/03/25.
//

import UIKit

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // 일기장 리스트에서 전달받을 일기를 저장하는 프로퍼티
    var diary: Diary?
    var indexPath: IndexPath?
    
    // 우측 상단의 즐겨찾기 버튼
    var starButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        // 즐겨찾기를 눌렀을 때 starDiary Notification을 관찰하는 옵저버 추가
        // 즐겨찾기 탭의 일기1을 상세보기 한 뒤, 일기장 목록 탭의 일기1을 상세보기하여 즐겨찾기를 해제한다.
        // 이후, 하단의 즐겨찾기 탭을 누르면 아까 띄워놨던 일기1의 상세보기가 나타나는데, 이때 즐겨찾기가 등록되어 있는 상태로 나타난다.
        // 바로 일기장 목록과 즐겨찾기의 싱크가 안 맞기 때문이다!
        NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNotification(_:)), name: NSNotification.Name("starDiary"), object: nil)
    }
    
    // 즐겨찾기를 눌렀을 때 collectionView를 갱신함
    @objc func starDiaryNotification(_ notification: Notification){
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let diary = starDiary["diary"] as? Diary else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        
        if diary.uuidString == uuidString {
            self.diary?.isStar = isStar
            self.configureView()
        }
    }
    
    
    
    // 일기장 리스트에서 선택한 일기로 화면 설정
    private func configureView() {
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
        
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
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
        self.diary = diary
        self.configureView()
    }
    
    
    
    // 삭제 버튼을 눌렀을 때 실행되는 메서드
    @IBAction func tapDeleteButton(_ sender: Any) {
        guard let uuidString = self.diary?.uuidString else { return }
        
        // self.delegate?.didSelectDelete(indexPath: indexPath)
        // 원래는 delegate를 사용해 위처럼 구현했지만, delegate를 사용하면 1:1 밖에 안됨
        // 그래서 어디에서 이벤트가 발생해도 알아챌 수 있는 NotificationCenter를 사용
        NotificationCenter.default.post(name: NSNotification.Name("deleteDiary"), object: uuidString, userInfo: nil)
        
        self.navigationController?.popViewController(animated: true)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // 즐겨찾기 버튼을 눌렀을 때 아이콘을 변경하고, diary 객체의 isStar 값을 변경하는 메서드
    @objc func tapStarButton() {
        guard let isStar = self.diary?.isStar else { return }
        
        if isStar {
            self.starButton?.image = UIImage(systemName: "star")
        } else {
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        
        self.diary?.isStar = !isStar
        
        // self.delegate?.didSelectStar(indexPath: indexPath, isStar: self.diary?.isStar ?? false)
        // 원래는 delegate를 사용해 위처럼 구현했지만, delegate를 사용하면 1:1 밖에 안됨
        // 그래서 어디에서 이벤트가 발생해도 알아챌 수 있는 NotificationCenter를 사용
        NotificationCenter.default.post(
            name: Notification.Name("starDiary"),
            object:
                [
                    "diary": self.diary,
                    "isStar": self.diary?.isStar ?? false,
                    "uuidString": diary?.uuidString
                ],
            userInfo: nil
        )
    }
}
