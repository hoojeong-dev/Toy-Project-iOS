//
//  ViewController.swift
//  Diary
//
//  Created by 김후정 on 2022/03/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // 선언한 구조체 Diary 타입의 배열 생성
    private var diaryList = [Diary](){
        // didSet() 메서드를 통해 일기가 추가되거나 변경될 때마다 saveDiaryList() 메서드를 호출
        didSet {
            self.saveDiaryList()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDiaryList()
        
        // 수정 버튼을 눌렀을 때 editDiary Notification을 관찰하는 옵저버 추가
        // WriteDiaryViewController에서 수정된 객체가 NotificationCenter를 통해서 호스트 될 때 editDiaryNotification 메서드가 호출 됨
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: NSNotification.Name("editDiary"), object: nil)
        
        // 즐겨찾기 버튼을 눌렀을 때 starDiary Notification을 관찰하는 옵저버 추가
        NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNotification(_:)), name: NSNotification.Name("starDiary"), object: nil)
        
        // 삭제 버튼을 눌렀을 때 deleteDiary Notification을 관찰하는 옵저버 추가
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDiaryNotification(_:)), name: NSNotification.Name("deleteDiary"), object: nil)
    }
    
    // 수정 버튼을 눌렀을 때 diaryList를 갱신함
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diaryList[row] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        
        self.collectionView.reloadData()
    }

    // 즐겨찾기를 눌렀을 때 diaryList를 갱신함
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let indexPath = starDiary["indexPath"] as? IndexPath else { return }
        
        self.diaryList[indexPath.row].isStar = isStar
    }
    
    // 삭제 버튼을 눌렀을 때 diaryList를 갱신함
    @objc func deleteDiaryNotification(_ notification: Notification) {
        guard let indexPath = notification.object as? IndexPath else { return }
        self.diaryList.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
    }
    
    
    
    // 일기를 기기 저장소에서 저장하는 메서드
    private func saveDiaryList() {
        let data = self.diaryList.map {
            [
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "diaryList")
    }
    
    // 일기를 기기 저장소에서 불러오는 메서드
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        
        // 불러온 데이터를 diaryList에 넣기
        self.diaryList = data.compactMap{
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }
        
        // 불러온 일기, 최신순으로 정렬
        self.diaryList = self.diaryList.sorted(by: {
            // 날짜를 비교해서 내림차순으로 정렬 -> 최신순으로 정렬됨
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}



// WriteDiaryViewController 에서 ViewController로 넘어올 때 필요한 익스텐션
extension ViewController: WriteDiaryViewDelegate {
    func didSelectRegister(diary: Diary) {
        // 전달받은 diary 객체를 diaryList에 추가
        self.diaryList.append(diary)
        // 저장한 일기, 최신순으로 정렬
        self.diaryList = self.diaryList.sorted(by: {
            // 날짜를 비교해서 내림차순으로 정렬 -> 최신순으로 정렬됨
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
}



// CollectionView에 일기장 목록을 띄우기 위해 셀을 준비하는 익스텐션
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

// collection view에 일기를 띄우기 위한 익스텐션
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
    }
}



// ViewController에서 DiaryDetailViewController로 넘어가기 위한 익스텐션
extension ViewController: UICollectionViewDelegate {
    // 특정 셀이 선택되었음을 알리는 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
