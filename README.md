# 토이 - 개인 프로젝트 관리 앱

![Untitled](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/Untitled.png)

![Untitled](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/Untitled%201.png)

### 토이 - 개인프로젝트 관리앱

> 김정태
> 

> 프로젝트 기간 : 2022.06.01 ~ 2022.12.06
> 

### 1. 개발 환경

- xcode 14.1
- swift 5.7.0

### 2. 라이브러리

- Firebase/Auth, GoogleSignIn, Firebase/Database
- Toast-Swift
- MaterialComponents/BottomSheet
- DropDown
- lottie-io
- KakaoSDKCommon, KakaoSDKAuth, KakaoSDKUser

### 3. 앱 소개

- Splash 화면
<img width="30%" src="https://user-images.githubusercontent.com/53727139/205867839-cc2aa264-2a0f-4c93-b9dc-22292c572aa0.gif"/>

[splash.mp4](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/splash.mp4)

- 로그인

[login.mp4](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/login.mp4)

- 프로젝트 관리
1. 다양한 카드를 만들어 프로젝트를 관리할 수 있다.
2. 카드마다 나만의 라벨을 만들어 효율적으로 관리 가능
3. 만든 리스트들은 리스트 관리창 에서 따로 관리 가능

![projectContent.png](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/projectContent.png)

![colorLabel.png](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/colorLabel.png)

![listManagement.png](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/listManagement.png)

카드 생성, 카드 이동

[createCard.mp4](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/createCard.mp4)

[moveCard.mp4](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/moveCard.mp4)

- 알림 창, 마이 페이지, 프로필 관리창

![alert.png](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/alert.png)

![userInformation.png](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/userInformation.png)

![mypage.png](%E1%84%90%E1%85%A9%E1%84%8B%E1%85%B5%20-%20%E1%84%80%E1%85%A2%E1%84%8B%E1%85%B5%E1%86%AB%20%E1%84%91%E1%85%B3%E1%84%85%E1%85%A9%E1%84%8C%E1%85%A6%E1%86%A8%E1%84%90%E1%85%B3%20%E1%84%80%E1%85%AA%E1%86%AB%E1%84%85%E1%85%B5%20%E1%84%8B%E1%85%A2%E1%86%B8%208a6f52a82d9a4383a108a8d58d80c1f9/mypage.png)
