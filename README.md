# CoreDataAuth
## 📋 프로젝트 개요
### Clean Architecture 학습을 위한 회원가입 앱
- 프로젝트 목표 : **Clean Architecture 학습**
  - 1차 목표 : MVVM 아키텍처와 CoreData를 사용하여 회원가입과 로그인 기능을 구현한 앱 개발
  - 2차 목표 : 완성된 앱을 **Clean Architecture** 로 리팩토링
- 프로젝트 명 : CoreDataAuth
- 프로젝트 기간 : 2025.08.20 ~ 2025.09.05

---

## 🛠️ 기술 스택
- Language : Swift
- IDE : Xcode
- 버전 : iOS 16
- Architecture : MVVM -> 클린 아키텍처
- 라이브러리 : RxSwift, SnapKit
- DataBase : CoreData
- UI 구현 : UIKit
- UI 디자인 : Figma
- 디자인 패턴 : Observer 패턴, Singleton 패턴, Delegate 패턴
- 형상 관리 : Github

## 🎨 와이어 프레임
<!--<img width="566" height="877" alt="image" src="https://github.com/user-attachments/assets/54046082-577f-4fe3-bbf4-884ebc555c5b" />-->
<img width="566" height="838" alt="image" src="https://github.com/user-attachments/assets/fa2d45a3-0b20-4646-9023-1678fd440c5b" />

---

<!--
## 📱 주요 기능
### 1. 날씨 
#### 1-1. 현재 날씨
- 사용자 위치 기반 현재 날씨 데이터 표시
#### 1-2. 3시간 예보
- 3시간 단위의 기온과 날씨 표시
#### 1-3. 5일간 날씨
- 5일간의 하루 단위 최저, 최고 기온과 날씨, 강수량을 표시
### 2. 옷 추천
- 현재 날씨 데이터를 기반으로 어울리는 옷 추천 (예: 더운 날씨에는 반팔 반바지)
  - 비와 눈 예보을 먼저 확인 후 옷 추천
  - 각 온도에 맞는 옷차림 16가지 추천
### 3. 주소 검색 기능
- 검색 화면에서 주소를 검색기능
- 검색한 주소를 선택 시, 사용자의 위치가 선택한 주소로 변경
- 주소가 변경되면서, 변경된 주소의 날씨 데이터를 보여줌
### 4. 섭씨, 화씨 변경 기능
- 설정 화면에서 섭씨, 화씨 변경 가능
### 5. Pull to Refresh 기능
- 화면을 위로 잡아 당기면, 날씨 데이터가 새로고치 됨
---
-->

<!--
## 📁 디렉터리 구조
```
## 디렉터리 구조

CoreDataAuth
├── App
│ ├── AppDelegate.swift
│ └── SceneDelegate.swift
│
├── Common
│ ├── LocationManager
│ │ ├── Model
│ │ │ ├── ForwardGeocoding.swift
│ │ │ ├── ReverseGeocoding.swift
│ │ │ ├── LocationManager.swift
│ │ │ └── LocationNetworkManager.swift
│ │
│ ├── NetworkManager
│ │ └── NetworkManager.swift
│
├── Model
│ ├── CustomForecastList.swift
│ ├── OutfitRecommendation.swift
│ ├── WeatherForecast.swift
│ └── WeatherResponse.swift
│
├── View
│ ├── CollectionViewCell
│ │ ├── CellBackground.swift
│ │ ├── ClothesCell.swift
│ │ ├── ForecastListCell.swift
│ │ ├── MainCell.swift
│ │ ├── TempProgressBar.swift
│ │ └── TenDayForecastCell.swift
│ │
│ ├── Main
│ │ └── MainViewController.swift
│ │
│ ├── Search
│ │ ├── SearchResultCell.swift
│ │ └── SearchViewController.swift
│ │
│ └── Settings
│ └── SettingsViewController.swift
│
├── ViewModel
│ ├── Clothes
│ │ └── ClothesViewModel.swift
│ │
│ ├── Location
│ │ └── LocationViewModel.swift
│ │
│ └── Main
│ └── MainViewModel.swift
```
---
-->


## 📋 커밋 컨벤션 (PR 시 동일하게 적용)
- Commit Message 규칙
  - 💡 [Issue 종류] #Issue 번호 - 한 줄 정리
    - 예시) [Feat] #22 - 탭바 추가

---

## 📌 브렌치 룰 & 전략
- 브랜치 전략
    - github flow를 따르되, main과 개인 작업 브랜치 사이에 Develop를 만들어서 좀 더 안전하게 공동작업을 보호.
        - main: Develop 브랜치에서 하나의 Issue에 생성된 브랜치가 안전하게 머지 되었을 때 푸시
        - Develop: 새로운 Issue가 완료되었을 때 푸시 앤 머지
        - Issue 할당 브랜치: 개인 작업용
        
- 브랜치 룰
    - **`Block force pushes` : Force push 방지**
        
- 브랜치 네이밍
    - 이슈 종류/#이슈 번호
 
---

## 📦 설치 및 실행 방법
- 이 저장소를 클론
  ```bash
  https://github.com/mnh4140/First-party_Spr-summmer-fal-winnnter.git
  ```
- Xcode로 프로젝트 파일을 실행 후 빌드!
