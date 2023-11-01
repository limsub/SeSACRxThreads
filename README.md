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
    3. 버튼 색(UIColor), 클릭 가능 여부 (Bool)
- Subscribe
    1. birthDayPicker.rx.date -> birthDay
    2. birthDay -> year, month, day
    3. birthDay vs. Date()-17years -> buttonColor, buttonEnabled
    4. year, month, day -> 각 Label
    5. buttonColor -> Button.rx.backgroundColor
    6. buttonEnabled -> Button.rx.isEnabled