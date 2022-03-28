//
//  StarViewController.swift
//  Diary
//
//  Created by 김후정 on 2022/03/25.
//

import UIKit

class StarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadStarDiaryList()
        
        // 수정 버튼을 눌렀을 때 editDiary Notification을 관찰하는 옵저버 추가
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: NSNotification.Name("editDiary"), object: nil)
        
        // 즐겨찾기 버튼을 눌렀을 때 starDiary Notification을 관찰하는 옵저버 추가
        NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNotification(_:)), name: NSNotification.Name("starDiary"), object: nil)
        
        // 삭제 버튼을 눌렀을 때 deleteDiary Notification을 관찰하는 옵저버 추가
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDiaryNotification(_:)), name: NSNotification.Name("deleteDiary"), object: nil)
    }
 
    
    
    // collectionView의 속성(모양!)을 설정하는 메서드
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    
    // 즐겨찾기 한 다이어리 객체만(isStar == true) 불러오기
    private func loadStarDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        
        self.diaryList = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else  { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }.filter({
            $0.isStar == true
        }).sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
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
        guard let diary = starDiary["diary"] as? Diary else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let indexPath = starDiary["indexPath"] as? IndexPath else { return }
        
        // 즐겨찾기를 해제했을 때는 diaryList와 collectionView에서 제거
        if isStar {
            self.diaryList.append(diary)
            self.diaryList = self.diaryList.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            
            self.collectionView.reloadData()
            
        } else {
            self.diaryList.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
        }
    }
    
    // 삭제 버튼을 눌렀을 때 diaryList를 갱신함
    @objc func deleteDiaryNotification(_ notification: Notification) {
        guard let indexPath = notification.object as? IndexPath else { return }
        self.diaryList.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
    }
    
    
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}



// CollectionView에 일기장 목록을 띄우기 위해 셀을 준비하는 익스텐션
extension StarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCell", for: indexPath) as? StarCell else { return UICollectionViewCell() }
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

// collection view에 일기를 띄우기 위한 익스텐션
extension StarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 80)
    }
}



// StarViewController에서 DiaryDetailViewController로 넘어가기 위한 익스텐션
extension StarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
