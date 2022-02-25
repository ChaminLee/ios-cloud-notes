<img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&width=100%&height=300&section=header&text=📝%20동기화%20메모장&fontSize=90" width=100%>

# 📝 동기화 메모장 프로젝트

- 팀 프로젝트 (2인)
- 구현 기간 : 2022.02.07 ~ 02.25 (3 weeks)

## 목차 
- [구현](#구현)
- [STEP1](#STEP1)
    - [고민했던 점](#STEP1-1)
    - [학습 키워드](#STEP1-2)
- [STEP2](#STEP2)
    - [고민했던 점](#STEP2-1)
    - [학습 키워드](#STEP2-2)
- [STEP3](#STEP3)
    - [고민했던 점](#STEP3-1)
    - [학습 키워드](#STEP3-2)
- [STEP4](#STEP4)
    - [고민했던 점](#STEP4-1)
    - [학습 키워드](#STEP4-2)
    
---
<a name="구현"></a>

# 📱 구현 

|메모 생성|메모 편집|
|:---:|:---:|
|![Simulator Screen Recording - iPad Pro (12 9-inch) (5th generation) - 2022-02-25 at 17 58 54](https://user-images.githubusercontent.com/45652743/155686005-1e7edf73-f780-4778-beb6-555415403385.gif)|![Simulator Screen Recording - iPad Pro (12 9-inch) (5th generation) - 2022-02-25 at 18 00 15](https://user-images.githubusercontent.com/45652743/155686182-42b7e90a-3995-4bc4-a66a-ffe8edaea3d3.gif)|


|메모 삭제|메모 검색|
|:---:|:---:|
|![Simulator Screen Recording - iPad Pro (12 9-inch) (5th generation) - 2022-02-25 at 18 02 03](https://user-images.githubusercontent.com/45652743/155686446-f7955663-b926-4186-85aa-f0e99f77de70.gif)|![Simulator Screen Recording - iPad Pro (12 9-inch) (5th generation) - 2022-02-25 at 18 15 03](https://user-images.githubusercontent.com/45652743/155688523-e5f5e129-0810-4483-bf2d-67ea8f66c94f.gif)|

|메모 공유|Dropbox 로그인|
|:---:|:---:|
|![Simulator Screen Recording - iPad Pro (12 9-inch) (5th generation) - 2022-02-25 at 18 12 03](https://user-images.githubusercontent.com/45652743/155687956-495e510f-2468-42b5-9615-6ad63232ddd0.gif)|![Simulator Screen Recording - iPad Pro (12 9-inch) (5th generation) - 2022-02-25 at 18 09 18](https://user-images.githubusercontent.com/45652743/155687629-f52d29f4-228f-4927-9354-74f4e8d7debd.gif)|


---

<a name="STEP1"></a>

# 🤔 STEP 1

<a name="STEP1-1"></a>

## 🔥 고민했던 점

### 1️⃣ 다크모드 대응 

- App이 light mode와 dark mode에 대응할 수 있도록 구현하였습니다.
- 두 mode에서 각 UI 요소들의 시각적인 부분에서 불편함이 없는지 전반적으로 확인 후  색상을 선택하여 구현하였습니다. 

|light mode|dark mode|
|:---:|:---:|
|![](https://i.imgur.com/ACzf8p6.png)|![](https://i.imgur.com/pXxuGDa.png)|

<br>

### 2️⃣ 키보드가 화면을 가리지 않도록 구현

- `UITextView`를 터치하여 키보드가 올라올 때 일부 컨텐츠를 가리는 현상이 있었습니다.
- `UIResponder`의 `keyboardWillShowNotification`, `keyboardWillHideNotification` notification을 받아 키보드가 등장하고 사라질 때 실행될 메서드를 각각 구현했습니다. 
- 우선 키보드가 완전히 등장했을 때의 높이를 notification의 userInfo를 통해 얻었습니다. 이후 키보드의 높이 값을 `UITextView`의 `contentInset.bottom`에 할당하여 키보드의 높이만큼 `UITextView`의 inset을 조정해주어 보고자 하는 컨텐츠가 가려지는 문제를 해결했습니다. 

<p align="left"><img src="https://i.imgur.com/MSQX7Bt.gif" width="50%"></p>

<br>

### 3️⃣ App 을 처음 실행했을 때 보이는 화면

- App을 처음 실행했을 때, secondary view에 빈 화면이 보이는 것이 아니라 tableView의 가장 첫 번째 cell에 해당하는 데이터의 내용이 보이도록 구현했습니다.
- 빈 화면이나, 별도의 안내 문구보다는 첫 데이터의 내용을 보여주는 것이 자연스럽다고 판단하여 이와 같이 구현했습니다.

<br>

### 4️⃣ 멀티태스킹 대응

- Multitasking 을 하게 되면 `UISplitViewController`가 collapsed되어 `single container`가 되는데, 이 때 초기에 secondary view가 우선적으로 보이게 되는 현상이 있었습니다. 
- 이러한 현상이 문제는 아니지만, 메모의 내용이 보이는 것 보다 primary에 해당하는 메모 리스트인 tableView가 보이는 것이 조금 더 적합할 것 같다고 판단하여 `UISplitViewControllerDelegate`의 메서드를 활용하여 collapsed 되었을 때 primary view가 우선적으로 보이도록 구현해주었습니다.
- 또한 collapsed 유무를 확인하기 위해 `isCollapsed`를 사용하여 상황에 맞게 메서드를 실행할 수 있도록 구분해주었습니다. 

<p align="left"><img src="https://i.imgur.com/wha0IMw.gif" width="50%"></p>

```swift
extension NotesSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
```

<br>

### 5️⃣ TableView extension 구현

- UITableView를 구성하기 위해 cell의 identifier를 알고 있어야 한다는 점이 부담스러울 수 있다고 판단하여 이를 몰라도 cell을 사용할 수 있도록 UITableView extension을 구현하여 사용해주었습니다.
- 아래와 같이 구현하는 경우 두 가지 이점을 얻을 수 있는 것 같습니다. 
  - cell의 identifier를 신경쓰지 않아도 된다.
  - 반환되는 cell이 optional 타입이 아니다.

```swift
extension UITableView {
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("cell을 dequeue하는데 실패했습니다.")
        }
        
        return cell
    }
}
```

<a name="STEP1-2"></a>

## 🔑 학습 키워드 

- SwiftLint
- UISplitViewController
- DateFormatter
- Localization
- UITextView
- Multitasking

<a name="STEP2"></a>

# 🤔 STEP 2

<a name="STEP2-1"></a>

## 🔥 고민했던 점

### 1️⃣ 메모 삭제에 따른 selectedIndexPath 이동 
`UITableView`의 swipeAction 혹은 더보기 버튼을 선택하여 메모를 삭제했을 때 현재 보여질 메모를 나타내기 위한 selectedIndexPath를 업데이트하기 위한 로직을 고민해봤습니다.

- selectedIndexPath 보다 앞의 indexPath에 해당하는 메모를 지우는 경우
    - 현재 보여지는 화면이 유지되어야 하기 때문에 selectedIndexPath의 row를 1만큼 빼주고 업데이트
- selectedIndexPath에 해당하는 메모를 지우는 경우 
    - 데이터의 개수와 비교하여 마지막에 해당한다면 row를 1만큼 빼주고 업데이트
    - 데이터의 개수와 비교하여 마지막이 아니라면 indexPath를 유지하고 화면만 업데이트
- selectedIndexPath 보다 뒤의 indexPath에 해당하는 메모를 지우는 경우
    - 기존의 화면이 보이도록 selectedIndexPath 유지 

위의 로직을 구성하여 코드에 반영하여, 사용자가 메모를 삭제했을 때 자연스럽게 주변 메모로 이동하여 보여줄 수 있도록 구현했습니다. 

### 2️⃣ CoreData CRUD 구현 

CoreData를 관리하는 `MemoStorage`라는 타입을 별도로 생성하여 내부에 CRUD를 각각 구현해두었습니다. `MemoStorage`를 소유하는 `MemoSplitviewController`가 CRUD를 활용하여 전반적인 데이터 관리를 할 수 있도록 도왔습니다.

`MemoStorage` 타입은 Singleton의 단점(테스트가 어렵고, 아무 객체나 쉽게 데이터에 접근하여 변경할 수 있는 등)을 고려하여 구현해주었습니다. 


### 3️⃣ UITextView 변경에 따른 UITableView 화면 동기화 

`UITextView`에 사용자가 텍스트를 입력할 때에 `textViewDidChange()`를 통해 데이터를 업데이트 하도록 해주었습니다.(현재는 core data 접근을 하지 않습니다) 이에 데이터가 변경되었기 때문에 `UITableView` 의 뷰 또한 업데이트가 필요하여 `reloadRows()`를 사용하여 tableView 전체를 업데이트하기 보다는 해당하는 부분만 업데이트 하도록 구현해주었습니다. 

또한 편집을 마치게 되면 `textViewDidEndEditing()` 메서드가 호출되는데, 이 때 편집이 완료된 데이터를 기준으로 먼저 변경이 있는지 여부를 확인해주었습니다. 변경 여부를 확인하기 위해 `textViewDidBeginEditing()`에서 기존 텍스트를 저장하고 비교하는 식으로 구현했습니다. 이에 변경 사항이 있을 때만 core data에 update를 요청하도록 구현해주었습니다. 

텍스트가 변경되는 매 순간 core data에 접근하여 업데이트 하는 것은 비용적으로 비효율적이라고 판단하여 위와 같이 최종 편집 완료시 core data에 업데이트 되도록 구현해주었습니다.

뿐만 아니라, cell의 미리보기 label에 표시 될 때 내용에 줄바꿈이 많은 경우 공백으로 보이는 현상이 있었습니다. 이에 cell의 미리보기 label에 텍스트를 전달해줄 때에는 `trimmingCharacters()`를 사용하여 앞뒤의 줄바꿈을 모두 제거한 상태로 전달해주어 줄바꿈을 무시하고 제목 이후에 등장하는 첫 텍스트를 보여주도록 구현했습니다. 

### 4️⃣ 앱 최초 실행 시 초기 메모를 세팅 

앱을 최초로 실행했을 때에 별도 처리를 하지 않으면 우측의 `UITextView`만 보이게 됩니다. 이에 편집을 제한하지 않으면 텍스트 입력이 가능해지는 데, 이러한 상황을 막기 위해 편집을 제한하기 보다는 최초 1개의 메모를 미리 세팅해두는 방식을 선택했습니다. 

이에 무조건 적으로 메모는 1개 이상 존재하도록 로직을 구현하였습니다. 이 때문에 앱을 최초 실행했을 때는 제목과 내용이 비어있기 때문에 각각 매칭하여 "새로운 메모", "추가 텍스트 없음"을 노출시켜주도록 구현했습니다. 

### 5️⃣ 항상 lastModified를 기준으로 데이터를 정렬

`Memo` 타입의 데이터 배열을 항상 마지막 편집일자인 `lastModified`를 기준으로 내림차순 정렬해주었습니다. 해당 데이터 배열에 접근하여 값을 변경할 때 마다 매번 정렬하도록 property observer를 사용해주었습니다. 

```swift
private var memos = [Memo]() {
    didSet {
        memos.sort { $0.lastModified > $1.lastModified }
    }
}
```

또한 항상 마지막에 편집한 메모가 상단에 노출되도록 하기 위해 편집을 마치면 `moveRow()`를 통해 상단으로 이동하도록 구현해주었습니다. 

### 6️⃣ UITextView내 제목/내용의 폰트를 서로 다르게 구현 

제목과 내용을 육안으로도 구분할 수 있도록 서로 폰트를 다르게 구현해주었습니다. 데이터를 가져와서 `UITextView`에 보여줄 때 `attributedString`을 활용하여 각각 다른 attribute를 가지도록 구현했습니다. 

또한 편집하는 도중에도 첫 번째 줄은 제목이 되고, 그 다음 줄부터는 내용이 되어야 하기 때문에 이를 위해 `textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)`를 사용하여 range의 location과 줄바꿈 부호로 구분했을 때 얻을 수 있는 range의 location을 비교하여 첫 번째 줄은 `.largeTitle`, 그 다음부터는 `.title2`로 보여지도록 구현했습니다

```swift
func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let textAsNSString = textView.text as NSString
    let replacedString = textAsNSString.replacingCharacters(in: range, with: text) as NSString
    let titleRange = replacedString.range(of: .lineBreak)

    if titleRange.location > range.location {
        textView.typingAttributes = TextAttribute.title
    } else {
        textView.typingAttributes = TextAttribute.body
    }

    return true
}
```
<img src="https://user-images.githubusercontent.com/45652743/154242847-ad91eab8-4b11-4016-b0fe-75b647d4755b.gif" width=50%> 


### 7️⃣ Delegate Pattern 적용

기존에 `MemoSplitViewController`를 거쳐 `MemoTableViewController`와 `MemoDetailViewController` 간 소통을 도왔던 구조에서 delegate pattern을 적용하였습니다. 

이에 기존에 하위 컨트롤러인 `MemoTableViewController`가 `splitViewController` 프로퍼티를 사용하여 상위 컨트롤러를 알지 못하더라도 delegate를 통해 필요로 하는 기능들을 사용할 수 있도록 구현했습니다. 이를 통해 자식 컨트롤러가 부모 컨트롤러를 아는 부적절한 의존 관계를 제거할 수 있었습니다. 

Delegate pattern 구현을 위해 생성한 프로토콜은 다음과 같습니다. 

- `MemoStorageManageable`: `MemoStorage`의 CRUD를 직접적으로 사용하여 데이터를 관리하는 역할
- `MemoSplitViewManageable` : 전반적인 `UISplitViewController`의 메서드나 하위 뷰컨 간 소통을 위한 역할
- 위 두 프로토콜을 typealias 사용하여 `MemoManageable`를 생성하고 delegate의 타입으로 사용하도록 해주었습니다. 

<a name="STEP2-2"></a>

## 🔑 학습 키워드

- Core Data
- CRUD
- UIAlertViewController
- Pull-Down Buttons
- UISwipeActionsConfiguration
- NSMutableAttributedString
- Delegate Pattern
- Data synchronization


<a name="STEP3"></a>

# 🤔 STEP 3

<a name="STEP3-1"></a>

## 🔥 고민했던 점

### 1️⃣ App단에서 데이터를 관리하기 위한 방법

Dropbox를 연동함에 따라 데이터를 어느 계층에서 관리해줘야 할지에 대해서 고민했습니다. 기존에는 `MemoSplitViewController`가 가지도록 해줬으나, 데이터는 앱의 전반적인 부분과 관련이 있다고 판단했습니다. 

이에 Core Data를 관리하는 `MemoStorage`와 Dropbox를 관리하는 `DropboxManager`를 `AppDelegate`에 위치하도록 변경해주었습니다. 추가적으로 메모를 전반적으로 관리하는 것은 `MemoStorage`이기 때문에, Dropbox와의 연동에 대한 역할도 가져야 한다고 생각하여 내부에 `DropboxManager` 인스턴스를 생성해주었습니다. 

### 2️⃣ Core Data <-> Dropbox 동기화 시점

Core Data를 중심으로 앱의 데이터가 관리되고 있다보니, 어느 시점에 Dropbox에 동기화되어야 하는지 고민했습니다. 최대한 비효율적이고 불필요한 요청을 줄이고자 필요한 상황에만 Dropbox API를 요청하도록 했습니다. 

- Core Data -> Dropbox
    - AppDelegate의 `applicationWillTerminate()`
        - 앱이 종료됨에 따라 비동기 실행을 보장받지 못해 `Thread.sleep(5)`을 하여 실행을 보장해주었습니다. 
    - SceneDelegate의 `sceneDidEnterBackground()`
        - 앱을 백그라운드로 보낼 때에도 Dropbox로 데이터를 보내도록 했습니다.
    - UITextView의 `textViewDidEndEditing()`
        - 텍스트 편집을 마치는 시점에 Core data에서 dropbox로 데이터를 보내도록 했습니다. 
- Dropbox -> Core Data
    - Dropbox 연동 성공시
        - Dropbox에 연동 성공하는 시점에 Dropbox의 최신 데이터를 core data에 동기화합니다.
    - 앱이 실행될 때, Dropbox 연동 정보가 true인 경우
        - `UserDefaults`에 Dropbox 연동 정보를 Bool타입으로 저장하여, 앱이 실행될 때 해당 key에 대한 값이 true인 경우 Dropbox의 데이터를 core data로 받도록 구현했습니다.

앱이 종료되는 경로를 최대한 고민하여 3가지의 경우에 Dropbox로 데이터를 보내도록 했습니다.

> 피드백 및 여러 상황을 고려하여 `applicationWillTerminate()` 애서는 비동기 작업이 보장되지 않기 때문에 업로드 되는 시점에서 제외시켰습니다. 

### 3️⃣ 사용자의 선택적 Dropbox 연동

앱을 실행할 때 바로 Dropbox 연동 여부를 묻는 것이 아니라, 버튼을 두어 선택적으로 연동할 수 있도록 했습니다. 

네트워크가 불가능한 상황에는 core data를 사용해서만 메모를 관리할 수 있도록 해주고, 가능한 경우에만 Dropbox 연동에 따른
동기화를 지원해주었습니다. 

또한 연동 성공/실패 여부에 따라 alert를 띄워 사용자에게 연동 성공/실패 여부를 보여주도록 구현했습니다. 

<a name="STEP3-2"></a>

## 🔑 학습 키워드 

- SwiftyDropbox
- Data Flow
- App/Scene Life Cycle

<a name="STEP4"></a>

# 🤔 STEP 4

<a name="STEP4-1"></a>

## 🔥 고민했던 점 

### 1️⃣ 검색 결과를 선택한 후 다시 리스트로 돌아갈 때 

검색을 한 이후 검색 결과에서 메모를 선택하고 다시 메인 메모 리스트로 돌아갔을 때 select가 유지되지 않거나, 다른 메모가 선택되어있는 문제가 있었습니다. 

UISearchController가 dismiss 될 때 가장 마지막으로 선택된 indexPath 및 선택된 메모에 대한 정보를 가지고 있기에 이를 기준으로 하여 memoDetail, memoTableView가 가지는 indexPath를 업데이트 해주었습니다. 

이를 `UISearchControllerDelegate`의 `func willDismissSearchController(_ searchController: UISearchController)` 메서드를 통해 적합한 시점에 전달해주도록 구현했습니다.

<img src="https://i.imgur.com/RzAQNla.gif" width=50%>

### 2️⃣ 검색 조건

제목만을 가지고 검색하는 것보다는 내용까지 검색 대상에 포함시키는 것이 더 다양한 검색 결과를 보여줄 수 있을 것이라 생각했습니다.

이에 `NSPredicate`를 활용하여 원하는 조건을 request에 넣어주고자 했습니다. 제목 혹은 내용에 검색된 키워드가 포함되어 있으면 검색 결과로 반환시켜주고자 했기에 아래와 같이 구현했습니다.

```swift
func search(for keyword: String) -> [Memo] {
    let request = Memo.fetchRequest()
    var predicates = [NSPredicate]()
    predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", keyword))
    predicates.append(NSPredicate(format: "body CONTAINS[cd] %@", keyword))
    request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
    let searchedMemos = try? context.fetch(request)

    return searchedMemos ?? []
}
```

### 3️⃣ 지역화

지역화를 지원하기 위해 우선 다양한 국가에서 사용하는 언어인 영어를 base 언어로 설정해주었습니다. 이외에도 한국어, 일본어를 지원하여 사용자가 작성한 메모를 제외한 모든 텍스트가 지역화 되도록 구현했습니다!

`Localizable.strings` 파일을 생성하여 key, value 매칭하는 방식으로 구현했습니다

|🇰🇷|🇺🇸|🇯🇵|
|:---:|:---:|:---:|
|![](https://i.imgur.com/7m5wUjV.png)|![](https://i.imgur.com/TV11qna.png)|![](https://i.imgur.com/R6GKzs1.png)|

### 4️⃣ 접근성 

기존에 다른 UI요소들은 다이나믹 텍스트 지원이 되었으나 `UITextView`는 크기가 변경되지 않는 이슈가 있었습니다. 

이에 명시적으로 `adjustsFontForContentSizeCategory` 프로퍼티 값을 true로 주어 정상작동하도록 해주었습니다. 

<img src="https://i.imgur.com/cwkBB5V.gif" width=50%>

<a name="STEP4-2"></a>

## 🔑 학습 키워드 

- Dark Mode
- Dynamic Types
- UISearchController
- Localization
- Accessibilty
