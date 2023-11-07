# SeSACRxThreads


## 11/1
#### SignInVC
- UISwitch와 isOn(Subject) subscribe
  - 변수 값을 이용해서 Switch 상태 변경


#### PhoneVC
- Subject
    1. 텍스트필드에 입력한 String (phone) - String
    2. 색상 (buttonColor) - UIColor
    3. 버튼 클릭 가능 여부 (buttonEnabled) - Bool
- Subscribe
    1. phone -> TextField
    2. TextField.rx.text -> phone (formatting)
    3. buttonColor -> TextField tintColor, TextField borderColor, Button backgroundColor
    4. phone (count) -> buttonEnabled, buttonColor
    5. buttonEnabled -> Button.rx.isEnabled


#### BirthdayVC
- Subject
    1. DatePicker로 선택한 날짜 (birthDay) - Date
    2. 연, 월, 일 (year, month, day) - Int
    3. 버튼 색상 (buttonColor) - UIColor 
    4. 버튼 클릭 가능 여부 (buttonEnabled) - Bool
- Subscribe
    1. birthDayPicker.rx.date -> birthDay
    2. birthDay -> year, month, day
    3. birthDay vs. Date()-17years -> buttonColor, buttonEnabled
    4. year, month, day -> 각 Label
    5. buttonColor -> Button.rx.backgroundColor
    6. buttonEnabled -> Button.rx.isEnabled


#### NicknameVC
- Subject
    1. 텍스트필드에 입력한 문자열 (nicknameStr) - String
    2. 버튼 히든 여부 (buttonHidden) - Bool
- Subscribe
    1. nicknameStr -> TextField.rx.text
    2. TextField.rx.text -> nicknameStr
    3. nicknameStr (count) -> buttonHidden
    4. buttonHidden -> Button.rx.hidden

<br>
<br>

## 11/2
- ViewModel 분리

<br>
<br>

## 11/3
#### SearchVC
- cell의 prepareForReuse에서 disposeBag을 새로 생성
- tableView.rx.itemSelected와 tableView.rx.modelSelected를 zip 으로 묶어서 활용
- subject의 배열에 데이터를 추가하는 방법
    1. items.value() - try 구문 필요
    2. data 배열 수정 후, items.onNext(data)
- debounce를 이용하여 효율적인 실시간 검색 기능 (네트워크 콜 절약)

<br>
<br>

## 11/6
