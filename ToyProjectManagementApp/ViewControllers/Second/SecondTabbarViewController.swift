//
//  SecondTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/07.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import KakaoSDKUser
import KakaoSDKAuth

enum CalendarMode {
    case week // 주 단위 일때
    case halfMonth // 월 단위 일때 (화면에 리스트와 달력 표시)
    case fullMonth // 월 단위 일때 (화면 전체를 달력으로 표시)
}

class SecondTabbarViewController: UIViewController {
    
    var ref: DatabaseReference! = Database.database().reference() // realtime DB
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var collectionView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var previousButton = UIButton()
    private lazy var nextButton = UIButton()
    private lazy var todayButton = UIButton()
    private lazy var weekStackView = UIStackView()
    private lazy var calendarView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var betweenImageView = UIImageView()
    private lazy var scheduleView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date()
    
    private var daysMonthMode = [String]() // 달력에 표시될 날짜 배열 (calendarMode가 full, halfMode 일때 사용) // ex. [" ", " ", " ", "1", "2", "3",....]
    private var daysWeekMode = [[String]]() // 달력에 표시될 날짜 배열 (calendarMode가 weekMode일때 사용), (한달 배열을 7개씩 나눠서 저장
    //ex. [["""","1","2"..."6"""],["7","8","9"..."13"]...["28","29","30","31","",""]])
    
    var project = [Project]() // projectID를 저장할 배열, second tabbar가 열리면 db에서 데이터를 읽어와 저장
    var projectContent = [ProjectContent]()
    var scheduleProjectContent = [Schedule]() // scheduleView에 띄우기 위한 모델(projecetContent모델에서 정제)
    var emailUid: String?
    var kakaoUserId = ""
    var calendarMode: CalendarMode = .halfMonth // 기본으로 halfMonth모드
    var showIndex: Int = 0
    var dayDate: String = "" //현재 날짜(일) ex. 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.configure() // 뷰 구성
        self.configureWeekLabel() // weekStackView에 월~일 label 넣기
        self.swipeView()
        self.setData()
        
    }
    
    override func viewWillLayoutSubviews() {
        // viewWillLayourSubviews
    }
    
    
}

//collectionView 함수
extension SecondTabbarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    


//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        <#code#>
//    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch calendarMode {
        case .halfMonth, .fullMonth:
            return self.daysMonthMode.count
            
        case .week: return self.daysWeekMode[showIndex].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.identifier, for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
        cell.update(day: self.daysMonthMode[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.weekStackView.frame.width / 7
        
        switch calendarMode {
        case .halfMonth, .week:
            return CGSize(width: width, height: width)
        case .fullMonth:
            return CGSize(width: width, height: width * 1.5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    // cell 세로 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
}

extension SecondTabbarViewController: UIScrollViewDelegate {
    
}

// update 함수
extension SecondTabbarViewController {
    
    //현재 날짜 구하기
    private func koreanDate() -> Int!{
        let current = Date()
        
        let formatter = DateFormatter()
        let date = self.dateFormatter.string(from: self.calendarDate)
        //한국 시간으로 표시
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        //형태 변환
        formatter.dateFormat = "yyyyMMdd"
        guard let currentDate = Int(formatter.string(from: current)) else { return 1 }
        
        // 현재 날짜의 date를 따로 저장
//        self.dateLabeltext = date
        // 날짜 day만(일) 따로 구하기
        self.dayDate = String(String(currentDate).dropFirst(6))
        return currentDate
    }
    
    private func swipeView() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(changeMonth(_:)))
        swipeLeft.direction = .left
        self.calendarView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(changeMonth(_:)))
        swipeRight.direction = .right
        self.calendarView.addGestureRecognizer(swipeRight)
    }
    
    
    private func configureCalendar() {
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.today()
    }
    
    private func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.calendarDate) - 1
    }
    
    private func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }
    
    private func updateCalendar() {
        self.updateTitle()
        self.updateMonthMode()
        self.updateWeekMode()
    }
    
    private func updateTitle() {
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.titleLabel.text = date
    }
    
    private func updateMonthMode() {
        self.daysMonthMode.removeAll()
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let totalDays = startDayOfTheWeek + self.endDate()
        
        for day in Int()..<totalDays {
            if day < startDayOfTheWeek {
                self.daysMonthMode.append(String())
                continue
            }
            self.daysMonthMode.append("\(day - startDayOfTheWeek + 1)")
        }
        
        self.calendarView.reloadData()
    }
    
    private func updateWeekMode() {
        print("updateWeekMode 실행1")
        self.daysWeekMode.removeAll()
        
        var week = [String]()
        
        for i in self.daysMonthMode {
            
            // 만약 선택된 날짜가 있다면 선택된 날짜가 있는 배열index가 showIndex에 들어감
            //if let _ = selectDate { self.showIndex = index }
            
            week.append(i)
            // 7개씩 daysWeekMode 배열에 저장
            if week.count == 7 || endDate() == Int(i)  {
                self.daysWeekMode.append(week)
                week.removeAll()
            }
        }
        self.calendarView.reloadData()
    }
    
    private func findcurrentIndex() {
        print("현재날짜 index 구해짐")
        if let firstIndex = self.daysMonthMode.firstIndex(of: String(dayDate)) {
            self.showIndex = firstIndex / 7
        }
    }
    
    private func minusMonth() {
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: -1), to: self.calendarDate) ?? Date()
        self.updateCalendar()
    }
    
    private func plusMonth() {
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: 1), to: self.calendarDate) ?? Date()
        self.updateCalendar()
    }
    
    private func today() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        print(calendarDate,"오늘")
        self.updateCalendar()
    }
    

    
}

/// @objc 함수
extension SecondTabbarViewController {
    
    @objc private func didPreviousButtonTouched(_ sender: UIButton) {
        self.minusMonth()
    }
    
    @objc private func didNextButtonTouched(_ sender: UIButton) {
        self.plusMonth()
    }
    
    @objc private func didTodayButtonTouched(_ sender: UIButton) {
        self.today()
    }
    
    // swipe시 생기는 이벤트(up, down)
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        
        if swipe.direction == .up, self.calendarMode == .halfMonth {
            print("week 모드")
            self.calendarMode = .week
            //self.updateWeekMode()
            
        } else if swipe.direction == .up, self.calendarMode == .fullMonth {
            print("half 모드")
            self.calendarMode = .halfMonth

        } else if swipe.direction == .down, self.calendarMode == .week {
            print("half 모드")
            self.calendarMode = .halfMonth

        }  else if swipe.direction == .down, self.calendarMode == .halfMonth {
            print("full 모드")
            self.calendarMode = .fullMonth

        } else if swipe.direction == .up, self.calendarMode == .week {
            return
        } else if swipe.direction == .down, self.calendarMode == .fullMonth {
            return
        }
        
        self.updateCalendar()
        self.moveView(self.calendarMode)
        
        DispatchQueue.main.async {
            self.calendarView.reloadData()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    // swipe시 달 바뀜 (left, right)
    @objc func changeMonth(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .left {
            print("left swipe")
            self.plusMonth()
            
        } else {
            print("right swipe")
            self.minusMonth()
        }
    }
    
}


extension SecondTabbarViewController {
    
    private func setData(){
        
        if (AuthApi.hasToken()) {
            UserApi.shared.me() {(user, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("me() success.")
                    if let userId = user?.id {
                        self.kakaoUserId = "kakao\(userId)"
                    }
                    
                    print(self.kakaoUserId)
                    self.emailUid = String(FirebaseAuth.Auth.auth().currentUser?.uid ?? self.kakaoUserId)
                }
            }
        } else {
            self.emailUid = FirebaseAuth.Auth.auth().currentUser?.uid ?? "아"
            
        }

        
    }
    
    private func emailToString(_ email: String) -> String {
        let emailToString = email.replacingOccurrences(of: ".", with: ",")
        return emailToString
    }
    
    // second탭바에 들어오면 projectID만 따로 배열로 저장
    private func readProjectId() {
        
        self.ref.child("\(emailUid)/project/").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            
            for (key,val) in value {
                let id = key
                
                guard let val = val as? Dictionary<String, Any> else { return }
                guard let projectTitle = val["projectTitle"] as? String else { return }
                guard let important = val["important"] as? Bool else { return }
                guard let currentTime = val["currentTime"] as? Int else { return }
                guard let prograss = val["prograss"] as? Bool else { return }
                
                let p_id = Project(id: id, projectTitle: projectTitle, important: important, currentTime: currentTime, prograss: prograss)
                
                self.project.append(p_id)
            }
            
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    //project id선택하면 project내용 db에서 읽어오기
    private func readProjectContent(_ id: String) {
        
        self.projectContent.removeAll()

        self.ref.child("\(emailUid)/project//\(id)/content").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else { return }
            
            for list in value {
                var count = 0
                for (key, val) in list {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: val)
                        let projectContentData = try JSONDecoder().decode([ProjectDetailContent].self, from: jsonData)
                        self.projectContent.append(ProjectContent(listTitle: key, index: count, detailContent: projectContentData))
                        count += 1
                    }
                    catch {
                        print("Error JSON Parsing \(error.localizedDescription)")
                    }
                }
            }
            
//            self.changeProjectTitleLabel(id)
//            self.organizeProjectContent()
            
            DispatchQueue.main.async {
                self.scheduleView.reloadData()
            }

        })
        
        { error in
            print(error.localizedDescription)
        }
    }

    
    private func moveView(_ calendarMode: CalendarMode) {
    
        
        
        switch calendarMode {
            
        case .fullMonth:
            self.betweenImageView.isHidden = true
            NSLayoutConstraint.activate([
                self.calendarView.heightAnchor.constraint(equalToConstant: 500)
            ])
            
        case .halfMonth:
            self.betweenImageView.isHidden = false
            NSLayoutConstraint.activate([
                self.calendarView.heightAnchor.constraint(equalToConstant: 200)
            ])

            
        case .week:
            self.betweenImageView.isHidden = false
            NSLayoutConstraint.activate([
                self.calendarView.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    
    }
    
}


// MARK: - 뷰 구성
extension SecondTabbarViewController {
    
    private func configure() {
        self.configureScrollView()
        self.configureContentView()
        self.configureTitleLabel()
        self.configurePreviousButton()
        self.configureNextButton()
        self.configureTodayButton()
        self.configureWeekStackView()
        self.configureCalendarView()
        self.configureCalendar()
        self.configureImageView()
        self.findcurrentIndex()
    }
    
    // titleLabe, previousButton, nextButton, weekStackView가 포함된 뷰
    private func configureContentView() {
        self.view.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.backgroundColor = .green
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.contentView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // 현재 날자 표시 label
    private func configureTitleLabel() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.text = "2000년 01월"
        self.titleLabel.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
    
    // 전 달로 이동
    private func configurePreviousButton() {
        self.contentView.addSubview(self.previousButton)
        self.previousButton.tintColor = .label
        self.previousButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        self.previousButton.addTarget(self, action: #selector(self.didPreviousButtonTouched), for: .touchUpInside)
        self.previousButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.previousButton.widthAnchor.constraint(equalToConstant: 44),
            self.previousButton.heightAnchor.constraint(equalToConstant: 44),
            self.previousButton.trailingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor, constant: -5),
            self.previousButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
        ])
    }
    
    // 다음 달로 이동
    private func configureNextButton() {
        self.contentView.addSubview(self.nextButton)
        self.nextButton.tintColor = .label
        self.nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        self.nextButton.addTarget(self, action: #selector(self.didNextButtonTouched), for: .touchUpInside)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.nextButton.widthAnchor.constraint(equalToConstant: 44),
            self.nextButton.heightAnchor.constraint(equalToConstant: 44),
            self.nextButton.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 5),
            self.nextButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
        ])
    }
    
    private func configureTodayButton() {
        self.contentView.addSubview(self.todayButton)
        self.todayButton.setTitle("Today", for: .normal)
        self.todayButton.setTitleColor(.systemBackground, for: .normal)
        self.todayButton.backgroundColor = .label
        self.todayButton.layer.cornerRadius = 5
        self.todayButton.addTarget(self, action: #selector(self.didTodayButtonTouched), for: .touchUpInside)
        self.todayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.todayButton.widthAnchor.constraint(equalToConstant: 60),
            self.todayButton.heightAnchor.constraint(equalToConstant: 30),
            self.todayButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.todayButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
        ])
    }
    
    private func configureWeekStackView() {
        self.contentView.addSubview(self.weekStackView)
        self.weekStackView.distribution = .fillEqually
        self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.weekStackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40),
            self.weekStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            self.weekStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            self.weekStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureWeekLabel() {
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            label.textAlignment = .center
            self.weekStackView.addArrangedSubview(label)
        }
    }
    
    // calendarView, scheduleView 포함
    private func configureScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false

        self.scrollView.contentOffset = CGPoint(x: 0, y: 20)
        self.scrollView.backgroundColor = .blue
        NSLayoutConstraint.activate([
//            self.scrollView.topAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 15),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)

        ])
    }

    private func configureCollectionView() {
        self.scrollView.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.backgroundColor = .brown
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 15),
            self.collectionView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.collectionView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 15)
        ])
    }
    
    private func configureCalendarView() {
        self.collectionView.addSubview(self.calendarView)
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.calendarView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.calendarView.backgroundColor = .yellow
        NSLayoutConstraint.activate([
            self.calendarView.topAnchor.constraint(equalTo: self.collectionView.topAnchor, constant: 10),
            self.calendarView.leadingAnchor.constraint(equalTo: self.collectionView.leadingAnchor),
            self.calendarView.trailingAnchor.constraint(equalTo: self.collectionView.trailingAnchor),
            self.calendarView.heightAnchor.constraint(equalToConstant: self.view.frame.width * 5/7)
        ])
    }
    
    private func configureImageView() {
        self.collectionView.addSubview(self.betweenImageView)
        self.betweenImageView.translatesAutoresizingMaskIntoConstraints = false
        self.betweenImageView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            self.betweenImageView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 1),
            self.betweenImageView.heightAnchor.constraint(equalToConstant: 1),
            self.betweenImageView.trailingAnchor.constraint(equalTo: self.collectionView.trailingAnchor),
            self.betweenImageView.leadingAnchor.constraint(equalTo: self.collectionView.leadingAnchor)
        ])
    }
    
}
