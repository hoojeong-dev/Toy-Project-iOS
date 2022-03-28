//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 김후정 on 2022/03/25.
//

import UIKit

// 신규인지 수정인지를 구별하는 열거형
enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

// delegate를 통해 일기장 리스트 화면으로 작성한 일기, 즉 다이어리 객체를 전달
protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    // 날짜를 선택할 수 있도록!
    private let datePicker = UIDatePicker()
    // picker를 통해 선택한 날짜를 저장
    private var diaryDate: Date?
    
    // delegate 프로퍼티 선언
    weak var delegate: WriteDiaryViewDelegate?
    
    // 신규/수정 모드를 저장하는 프로퍼티
    var diaryEditorMode: DiaryEditorMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        // 일기 등록 버튼 비활성화 (처음에는 제목, 내용, 날짜 모두 등록이 안 되어있기 때문)
        self.confirmButton.isEnabled = false
        self.configureEditMode()
    }
    
    
    
    // 등록 버튼을 눌렀을 때 호출되는 메서드
    @IBAction func tapConfirmButton(_ sender: Any) {
        // 버튼을 누르면 다이어리 객체를 생성하고
        // didSelectRegister 메서드를 호출해 생성한 다이어리 객체를 매개변수로 전달
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        
        // NotificationCenter 를 이용해 수정이 일어나면, 수정된 객체를 전달하고 구독하고 있는 화면에 수정된 객체로 갱신함
        // 등록된 이벤트가 발생하면 해당 이벤트에 대한 행동을 취함
        // 아무데서나 메시지를 던져도, 아무데서나 받을 수 있음 -> 이벤트 버스같은 역할
        switch self.diaryEditorMode {
        case .new:
            let diary = Diary(title: title, contents: contents, date: date, isStar: false)
            self.delegate?.didSelectRegister(diary: diary)
            
        // 이렇게 하면 수정버튼을 눌렀을 때 NotificationCenter가 editDiary라는 Notification 키를 옵저빙하는 곳에 수정된 객체를 전달
        case let .edit(indexPath, diary):
            let diary = Diary(title: title, contents: contents, date: date, isStar: diary.isStar)
            NotificationCenter.default.post(name: NSNotification.Name("editDiary"), object: diary, userInfo: ["indexPath.row": indexPath.row])
        }

        self.navigationController?.popViewController(animated: true)
    }
    

    
    // 수정 모드일 때 기존해 작성했던 일기를 띄우고, 수정할 수 있도록 하는 메서드
    private func configureEditMode() {
        switch self.diaryEditorMode {
        case let .edit(_, diary):
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = self.dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
        
        default:
            break
        }
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    
    
    // 내용 입력 필드에 경계를 설정하는 함수
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        // layer 컬러를 설정할 때는 UI가 아니라 cgColor로 설정해야 한다
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    
    
    // 날짜 선택창 생성 함수
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        // UI 컨트롤러 객체가 이벤트에 응답하는 방식을 설정하는 메서드
        // target: self(해당 뷰 컨트롤러 이므로), action: 이벤트가 발생했을 때 호출되는 메서드, for: 어떤 이벤트가 발생할 때 메서드를 호출할 것인지 설정(값이 변경될 때)
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        self.dateTextField.inputView = self.datePicker
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        // DateFormatter()는 데이트 타입 <=> 문자열 타입으로 변경
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 (EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        // date를 formater에 지정한 문자열로 변경 (yyyy년 MM월 dd일 (EEEEE))
        self.dateTextField.text = formatter.string(from: datePicker.date)
        
        // dateTextField는 키보드로 입력받지 않기 때문에 editingChanged 이벤트가 발생하지 않음
        // 즉, dateTextFieldDidChange()가 호출되지 않아서 등록 버튼의 활성화 여부를 판단할 수 없음
        // 해결하기 위해서는, 사용자가 datePicker로 날짜를 변경할 때마다 .editingChanged 이벤트를 발생시키면 됨
        self.dateTextField.sendActions(for: .editingChanged)
    }
    
    // 사용자가 빈 화면을 터치할 때마다 키보드나 datePicker가 사라진다
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    // 제목, 날짜 field에 내용이 입력될 때마다 호출되는 메서드
    private func configureInputField() {
        self.contentsTextView.delegate = self
        // titleTextField에 변경사항이 있을 때마다 titleTextFieldDidChande() 호출
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChande(_:)), for: .editingChanged)
        // dateTextField에 변경사항이 있을 때마다 titleTextFieldDidChande() 호출
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChande(_ textField: UITextField) {
        self.vaildateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        self.vaildateInputField()
    }
    
    // 등록 버튼의 활성화 여부를 판단하는 메서드
    private func vaildateInputField() {
        // 모든 input field가 비어있지 않으면 true로 변경
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !(self.contentsTextView.text.isEmpty)
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    // 텍스트 뷰에 텍스트가 입력될 때마다 호출되는 메서드
    // 즉, 내용 텍스트 뷰에 입력될 때만 호출됨 (제목과 날짜는 field이므로 부가적으로 구현해야 함)
    func textViewDidChange(_ textView: UITextView) {
        // 텍스트가 입력될 때마다 메서드를 호출해 활성화 여부를 판단
        self.vaildateInputField()
    }
}
