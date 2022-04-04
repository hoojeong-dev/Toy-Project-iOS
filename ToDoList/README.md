# ToDo List 앱

## *Introduce*

간단하게 할일을 등록하고, 수행 여부를 기록할 수 있습니다.

주요 기능은 다음과 같습니다.
- 할일 등록
- 할일 삭제
- 순서 변경
- 로컬 저장소에 데이터 저장

</br>

TableView를 사용하여 추가한 일정을 각 셀에 등록하고, UserDefaults를 사용해 데이터를 자신의 디바이스에 저장합니다.
> UserDefaults는 디바이스의 임시 저장소로, 앱을 종료하면 저장되어 있는 데이터를 지운다. 이를 방지하기 위해서 ``key``, ``value`` 형태로 저장하여, key 값을 통해 데이터에 접근한다.

</br>

다음은 UserDefaults를 사용하여 디바이스 저장소에 저장하는 예제입니다.
```swift
var tasks = [Task]()

let data = self.tasks.map {
[
    "title": $0.title,
    "done": $0.done
    ]
}
        
let userDefaults = UserDefaults.standard
userDefaults.set(data, forKey: "tasks")
```

</br>

할 일을 입력받을 때에는 Alert 함수를 사용합니다.
다음은 Alert 창 구현 예제입니다.
```swift
// UIAlertController 객체 생성
let alert = UIAlertController(title: "할 일 등록", message: "할 일을 입력해주세요", preferredStyle: .alert)

// 버튼 생성
let registerButton = UIAlertAction(title: "등록", style: .default, handler: nil)
let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)

// 생성한 버튼을 추가
alert.addAction(cancelButton)
alert.addAction(registerButton)
alert.addTextField(configurationHandler: { textField in
    textField.placeholder = "할 일을 입력해주세요."
})

// present를 통한 팝업
self.present(alert, animated: true, completion: nil)
```

</br>

## *Demo*

<p align="center"><img src="./asset/toDoList.GIF" height="500px" width="250px"><p>

---

## *변경사항*

__03.19__  할일 완료 시 글자 색 변경 및 취소선
