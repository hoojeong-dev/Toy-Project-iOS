//
//  ViewController.swift
//  ToDoList
//
//  Created by 김후정 on 2022/03/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    // weak로 하면, done로 바꾸면 메모리에서 해제되어버림
    @IBOutlet var editButton: UIBarButtonItem!
    
    var doneButton: UIBarButtonItem?
    
    // task 구조체에 맞게 할 일들을 저장하는 배열
    var tasks = [Task]() {
        // 배열에 할 일이 추가될 때마다 UserDefaults을 사용해 기본 저장소에 저장
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        // task 에 저장되어 있는 할 일을 테이블 뷰에 나타내기 위해 UITableViewDataSource 프로토콜을 채택해야 함
        self.tableView.dataSource = self
        // 할 일을 완료하면 체크하기 위해 UITableViewDelegate 채택하기
        self.tableView.delegate = self
        // 저장된 할일 불러오기
        self.loadTasks()
    }

    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        // preferredStyle에서 actionSheet는 하단에, alert은 앱 중앙에
        let alert = UIAlertController(title: "할 일 등록", message: "할 일을 입력해주세요", preferredStyle: .alert)
        // handler에는 클로저를 선언한다. 사용자가 버튼을 눌렀을 때 클로저가 실행된다.
        // 클로저에서 [] 선언부 안에 weak self(캡처목록)을 정의한 이유는, 클로저는 참조타입이기 때문에 self를 사용하면 강한 순환 참조가 발생할 수 있기 때문이다. -> 메모리 누수 발생 => 이를 해결하기 위해 클로저의 선언부에 캡처목록 정의하기
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            // textFields에 입력된 값 가져오기. textFields는 배열의 형태로, 우리는 하나밖에 안 만들었으니 0번째임
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            // tableView에 셀이 추가될 때마다 새로고침
            self?.tableView.reloadData()
        })
        // 취소하면 별다른 일을 할게 없으므로 handler을 nil로 설정
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        // alert에 텍스트필드 띄우기. configurationHandler은 alert을 표시하기 전에 텍스트필드를 설정하는 클로저
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해주세요."
        })
        // Add 버튼을 눌렀을 때 화면에 나타나도록!
        self.present(alert, animated: true, completion: nil)
    }
    
    // UserDefaults에 저장해서 추가한 할 일 유지하기
    // UserDefaults를 사용하면 기본 저장소에 접근할 수 있음
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            
            return Task(title: title, done: done)
        }
    }
}

// 코드의 가독성을 위해 UITableViewDataSource를 익스텐션으로 빼기!
// UITableViewDataSource 프로토콜을 채택할 때 아래의 두 함수는 무조건 선언해야 한다
extension ViewController: UITableViewDataSource {
    // 각 섹션에 표시할 행의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    // 특정 로우를 그리기 위해 필요한 섹션 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeueReusableCell 메서드는 지정된 재사용 식별자(withIdentifier)에 대한, 재사용 가능한 테이블 뷰 셀 객체를 반환하고 테이블 뷰에 추가함
        // withIdentifier를 통해 받은 Identifier 값으로 재사용 할 셀을 찾는다.
        // for에 indexPath을 넘겨주는 이유는, indexPath 위치에 해당 셀을 재사용하기 위함
        // 즉, 큐를 사용해 셀을 재사용하는데, 셀을 재사용함으로써 메모리 낭비를 줄임
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.textLabel?.font = UIFont.systemFont(ofSize:18)
        
        if task.done {
            cell.accessoryType = .checkmark
            // 완료되면 취소선 긋고 글자 색 회색으로!
            cell.textLabel?.attributedText = cell.textLabel?.text?.strikeThrough()
            cell.textLabel?.textColor = UIColor.gray
            
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // 편집모드에서 삭제를 눌렀을 때, 누른 셀이 어떤 셀인지 알려줌
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if self.tasks.isEmpty {
            self.doneButtonTap()
        }
    }
    
    // 각 셀별로 움직이기 위해서는 아래의 두 메서드를 사용해야 한다!
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 정렬을 하면, 저장된 목록도 재정렬 해야함
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        // 원래 위치에 있던 할 일을 삭제
        tasks.remove(at: sourceIndexPath.row)
        // 지운 할 일을 이동한 위치에 추가
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
    }
}

extension ViewController: UITableViewDelegate {
    // 어떤 셀이 선택되었는지 알려주는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// 글자 취소선을 위한 확장 코드
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
