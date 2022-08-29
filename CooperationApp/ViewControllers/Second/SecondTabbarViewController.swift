//
//  SecondTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/07.
//

import UIKit
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth

enum CalendarMode {
    case fullMonth
    case halfMonth
    case week
}

class SecondTabbarViewController: UIViewController {
    
    var ref: DatabaseReference! = Database.database().reference() // realtime DB

    private let calendar = Calendar.current // 달력 구조체
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date() // 달력에 표시할 날짜를 저장할 배열 (달이 바뀌면 바뀐 달이 포함된 날짜를 가지고 있음)
    private var daysMonthMode = [String]() // 달력에 표시될 날짜 배열 (calendarMode가 full, halfMode 일때 사용)
    private var daysWeekMode = [[String]]() // 달력에 표시될 날짜 배열 (calendarMode가 weekMode일때 사용), (한달 배열을 7개씩 나눠서 저장
    //ex. [["""","1","2"..."6"""],["7","8","9"..."13"]...["28","29","30","31","",""]])
    
    var currentDate: Int = 0 // 현재날짜를 저장할 변수 (년, 월) ex. 202210
    var dateLabeltext: String? // 현재 날짜 일때 dateLabel에 저장된 변수 저장 ex. 2022년 10월
    var dayDate: String = "" //현재 날짜(일) ex. 10
    var calendarMode: CalendarMode = .halfMonth // 기본으로 halfMonth모드
    var selectDate: String? // 선택한 cell 날짜
    var showIndex: Int = 0 {
        didSet{
            print(showIndex,"showIndex")
        }
    } // week모드일때 보여줄 배열, 현재날짜가 포함된 주를 보여줌(선택한 cell이 있으면 선택한 cell이 포함된 주를 보여줌)
    
    var project = [Project]() // projectID를 저장할 배열, second tabbar가 열리면 db에서 데이터를 읽어와 저장
    var projectContent = [ProjectContent]()
    var scheduleProjectContent = [Schedule]() // scheduleView에 띄우기 위한 모델(projecetContent모델에서 정제)
    var id: String?
    
    @IBOutlet weak var dateLabel: UILabel! // 상단에 년과 월을 표시하는 label
    @IBOutlet weak var dateStackView: UIStackView! // dateLabel + 옆에 v버튼
    @IBOutlet weak var weekStackView: UIStackView! // 일~토를 표시하는 label stackView
    @IBOutlet weak var calendarView: UICollectionView! // calendar collectionView
    @IBOutlet weak var betweenCaledarScheduleView: UIView! // calendarView와 scheduleview 사이 이미지뷰
    @IBOutlet weak var projectTitie: UILabel! // project 이름
    @IBOutlet weak var scheduleView: UICollectionView! // schedule collectionView
   
    override func viewWillAppear(_ animated: Bool) {
        self.readProjectId()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("second tabbar viewWillDisppear 실행")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCalendarView()
        self.configureScheduleView()

        self.swipeView()
    }
    
    @IBAction func showProjectIdPopupButton(_ sender: UIButton) {
        
        let projectIDPopup = ProjectIDPopupViewController(nibName: "ProjectIdPopup", bundle: nil)
        
        projectIDPopup.selectIdDelegate = self
        
        projectIDPopup.project = self.project

        projectIDPopup.modalPresentationStyle = .overCurrentContext
        projectIDPopup.modalTransitionStyle = .crossDissolve
        self.present(projectIDPopup, animated: true, completion: nil)
    }
    
    // swipe 정의
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
    
    // month모드가 바뀔떄마다 뷰 변경
    private func moveView(_ calendarMode: CalendarMode) {
        
            self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
            self.dateStackView.translatesAutoresizingMaskIntoConstraints = false
            self.calendarView.translatesAutoresizingMaskIntoConstraints = false
            self.betweenCaledarScheduleView.translatesAutoresizingMaskIntoConstraints = false
            self.projectTitie.translatesAutoresizingMaskIntoConstraints = false
            self.scheduleView.translatesAutoresizingMaskIntoConstraints = false
        
        switch calendarMode {
        case .fullMonth:
            self.projectTitie.isHidden = true
            self.scheduleView.isHidden = true
            self.betweenCaledarScheduleView.isHidden = true
            
            self.dateStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
            self.weekStackView.topAnchor.constraint(equalTo: self.dateStackView.bottomAnchor, constant: 15).isActive = true
            self.calendarView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 15).isActive = true
            self.calendarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 15).isActive = true
            //self.betweenCaledarScheduleView.topAnchor.constraint(equalTo: self.calendarView.bottomAnchor, constant: 15).isActive = true
            
        case .halfMonth:
            self.projectTitie.isHidden = false
            self.scheduleView.isHidden = false
            self.betweenCaledarScheduleView.isHidden = false
            
            self.dateStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
            self.weekStackView.topAnchor.constraint(equalTo: self.dateStackView.bottomAnchor, constant: 15).isActive = true
            self.calendarView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 15).isActive = true
            self.betweenCaledarScheduleView.topAnchor.constraint(equalTo: self.calendarView.bottomAnchor, constant: 15).isActive = true
            self.scheduleView.topAnchor.constraint(equalTo: self.projectTitie.bottomAnchor, constant: 15).isActive = true
            self.scheduleView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 15).isActive = true
            
        case .week:
            self.projectTitie.isHidden = false
            self.scheduleView.isHidden = false
            self.betweenCaledarScheduleView.isHidden = false
            
            self.dateStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
            self.weekStackView.topAnchor.constraint(equalTo: self.dateStackView.bottomAnchor, constant: 15).isActive = true
            self.calendarView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 15).isActive = true
            self.betweenCaledarScheduleView.topAnchor.constraint(equalTo: self.calendarView.bottomAnchor, constant: 15).isActive = true
            self.scheduleView.topAnchor.constraint(equalTo: self.projectTitie.bottomAnchor, constant: 15).isActive = true
            self.scheduleView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 15).isActive = true
        }
        
        dateStackView.setNeedsLayout()
        weekStackView.setNeedsLayout()
        calendarView.setNeedsLayout()
        betweenCaledarScheduleView.setNeedsLayout()
        projectTitie.setNeedsLayout()
        scheduleView.setNeedsLayout()
    }
    
    // left right swipe시 달 바뀜
    @objc func changeMonth(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .left {
            print("left swipe")
            self.plusMonth()
            
        } else {
            print("right swipe")
            self.minusMonth()
        }
    }
    
    // swipe할시 생기는 이벤트
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        
        if swipe.direction == .up, self.calendarMode == .halfMonth {
            print("week 모드")
            self.calendarMode = .week
            self.updateWeekMode()
            self.moveView(.week)
        } else if swipe.direction == .up, self.calendarMode == .fullMonth {
            print("half 모드")
            self.calendarMode = .halfMonth
            self.moveView(.halfMonth)
        } else if swipe.direction == .down, self.calendarMode == .week {
            print("half 모드")
            self.calendarMode = .halfMonth
            self.moveView(.halfMonth)
        }  else if swipe.direction == .down, self.calendarMode == .halfMonth {
            print("full 모드")
            self.calendarMode = .fullMonth
            self.moveView(.fullMonth)
            
        } else if swipe.direction == .up, self.calendarMode == .week {
            return
        } else if swipe.direction == .down, self.calendarMode == .fullMonth {
            return
        }
        
        self.calendarView.performBatchUpdates({
            self.calendarView.reloadSections(IndexSet(integer: 0))
        }, completion: { [weak self]_ in
            self?.updateCalendar()
        })

    }
}

extension SecondTabbarViewController: UICollectionViewDelegate {
    
    //collectionView select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarView {
            if let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell {
                cell.selectCell(true)
            }
        } else {
            // ...
        }
    }
}

extension SecondTabbarViewController: UICollectionViewDataSource {
    
    //cell return 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calendarView {
            switch calendarMode {
            case .halfMonth, .fullMonth:
                return self.daysMonthMode.count
            case .week: return self.daysWeekMode[showIndex].count
            }
        } else {
            return self.scheduleProjectContent.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // calendarView cell 설정
        if collectionView == calendarView {
            guard let calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
            
            switch calendarMode {
            case .fullMonth:
                
                calendarCell.update(day: self.daysMonthMode[indexPath.row])
                calendarCell.checkCurrentDate(false)
                if dateLabel.text == dateLabeltext && daysMonthMode[indexPath.row] == dayDate {
                    calendarCell.checkCurrentDate(true)
                    calendarCell.dateLabel.textColor = .white
                }
                return calendarCell
                
            case .halfMonth:
                calendarCell.update(day: self.daysMonthMode[indexPath.row])
                calendarCell.checkCurrentDate(false)
                if dateLabel.text == dateLabeltext && daysMonthMode[indexPath.row] == dayDate {
                    calendarCell.checkCurrentDate(true)
                    calendarCell.dateLabel.textColor = .white
                }
                return calendarCell
                
            case .week:
                calendarCell.update(day: self.daysWeekMode[showIndex][indexPath.row])
                calendarCell.checkCurrentDate(false)
                if dateLabel.text == dateLabeltext && daysWeekMode[showIndex][indexPath.row] == dayDate {
                    calendarCell.checkCurrentDate(true)

                }
                return calendarCell
            }
            
        // scheduleView cell 설정
        } else {
            guard let scheduleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCollectionViewCell else { return UICollectionViewCell() }
            
            guard let startTime = self.scheduleProjectContent[indexPath.row].startTime else { return scheduleCell }
            guard let endTime = self.scheduleProjectContent[indexPath.row].endTime else { return scheduleCell }
            
            scheduleCell.cardlabel.text = self.scheduleProjectContent[indexPath.row].card
            scheduleCell.cardDateLabel.text = "\(startTime) ~ \(endTime)"
            scheduleCell.listName.text = self.scheduleProjectContent[indexPath.row].list
            
            return scheduleCell
        }
        
    }
}


extension SecondTabbarViewController: UICollectionViewDelegateFlowLayout {
    
    //cell 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == calendarView {
        
            // halfMonth, week모드는 가로의 길이는 동일
            let width = self.weekStackView.frame.width / 7

            switch self.calendarMode {
                
            case .week:
                return CGSize(width: width, height: width)

            case .halfMonth:
                if daysWeekMode.count >= 6 {
                    return CGSize(width: width, height: (width * 5) / 6)
                } else {
                    return CGSize(width: width, height: width)
                }

            //fullMonth는 view를 꽉채워야 하기 떄문에 새로의 길이가 길어져야 함
            case .fullMonth:
                //self.calendarViewHeight.constant = UIScreen.main.bounds.height - 70
                let height = (UIScreen.main.bounds.height - 140) / 7
                print(UIScreen.main.bounds.height)
                return CGSize(width: width, height: height)
            }
            
        } else {
            
            let width = UIScreen.main.bounds.width
            let estimatedHeight: CGFloat = 100.0

            return CGSize(width: width, height: estimatedHeight)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return .zero
        }

}


/// calendarView 관련 함수
extension SecondTabbarViewController {
    
    //calendarView 초기 설정
    private func configureCalendarView() {
        
        // caledarView ui 설정
        self.calendarView.translatesAutoresizingMaskIntoConstraints = true
//        self.calendarView.showsVerticalScrollIndicator = false // 가로 스크롤 안 보이게 하기
//        self.calendarView.showsHorizontalScrollIndicator = false // 세로 스크롤 안 보이게 하기
        self.calendarView.isScrollEnabled = false // scroll x
        self.calendarView.collectionViewLayout = UICollectionViewFlowLayout()
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        
        // calendarView nib 설정
        let calendarViewCellNib = UINib(nibName: "DateCell", bundle: nil)
        self.calendarView.register(calendarViewCellNib, forCellWithReuseIdentifier: "DateCell")
        
        // calendarView 날짜 설정
        let components = self.calendar.dateComponents([.weekOfYear, .year, .month], from: Date())
        print(components, "???????")
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.locale = Locale(identifier: "ko_kr")
        self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.currentDate = koreanDate()
        self.updateCalendar()
        self.findcurrentIndex()
    }
    
    //현재 날짜 구하기
    func koreanDate() -> Int!{
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
        self.dateLabeltext = date
        // 날짜 day만(일) 따로 구하기
        self.dayDate = String(String(currentDate).dropFirst(6))
        return currentDate
    }
    
    // 1일이 시작되는 날짜 구하기
    func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.calendarDate) - 1
    }
    
    // 달에 마지막 날짜를 return
    func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }

    // 맨위에 날짜 label 설정
    func updateTitle() {
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.dateLabel.text = date
    }
    
    // 날짜 업데이트 (halfMonth, fullMonth 모드)
    func updateMonthMode() {
        self.daysMonthMode.removeAll()
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let totalDays = startDayOfTheWeek + self.endDate()
        
        // 만약에 1일이 화요일부터 시작된다고 하면 ["", "", "1", "2" ....] 이런식으로 저장됨
        for day in Int()..<totalDays {
            if day < startDayOfTheWeek {
                self.daysMonthMode.append("")
                continue
            }
            self.daysMonthMode.append("\(day - startDayOfTheWeek + 1)")
        }
        
        self.calendarView.reloadData()
    }
    
    // 현재 날짜가 있는 showIndex 구하기
    func findcurrentIndex() {
        print("현재날짜 index 구해짐")
        if let firstIndex = self.daysMonthMode.firstIndex(of: String(dayDate)) {
            self.showIndex = firstIndex / 7
        }
    }
    
    // 날짜 업데이트 (week 모드)
    func updateWeekMode() {
        print("updateWeekMode 실행")
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
        print("흠",daysWeekMode.count,daysWeekMode)
        self.calendarView.reloadData()
    }
    
    // 달력 업데이트
    func updateCalendar() {
        self.updateTitle()
        self.updateMonthMode()
        self.updateWeekMode()
    }
    
    // 이전 달 이동
    func minusMonth() {
        
        switch calendarMode {
            
        case .fullMonth, .halfMonth:
            self.calendarDate = self.calendar.date(byAdding: DateComponents(month: -1), to: self.calendarDate) ?? Date()
            
        case .week:
            
            if self.showIndex > 0 {
                print("이거실행3")
                self.showIndex -= 1
            } else {
                print("이거실행4")
                self.calendarDate = self.calendar.date(byAdding: DateComponents(month: -1), to: self.calendarDate) ?? Date()
                print(daysWeekMode,"daysWeekMode")
                self.updateCalendar()
                self.showIndex = self.daysWeekMode.count - 1
            }
        }
        
        self.updateCalendar()
    }
    
    // 다음 달 이동
    func plusMonth() {
        switch calendarMode {
            
        case .fullMonth, .halfMonth:
            self.calendarDate = self.calendar.date(byAdding: DateComponents(month: 1), to: self.calendarDate) ?? Date()
            
        case .week:
           
            if daysWeekMode.count - 1 > self.showIndex {
                print("이거실행1")
                self.showIndex += 1
            } else {
                print("이거실행2")
                self.calendarDate = self.calendar.date(byAdding: DateComponents(month: 1), to: self.calendarDate) ?? Date()
                self.showIndex = 0
            }
        }
        
        self.updateCalendar()
        
    }
}

// MARK: - scheduleView
extension SecondTabbarViewController {
    
    private func configureScheduleView() {
        
        self.scheduleView.collectionViewLayout = UICollectionViewFlowLayout()
        self.scheduleView.delegate = self
        self.scheduleView.dataSource = self
        
        // scheduleView nib 설정
        let scheduleViewCellNib = UINib(nibName: "ScheduleCell", bundle: nil)
        self.scheduleView.register(scheduleViewCellNib, forCellWithReuseIdentifier: "ScheduleCell")
        
    }
}

// MARK: - DB관련
extension SecondTabbarViewController {
    
    private func emailToString(_ email: String) -> String {
        let emailToString = email.replacingOccurrences(of: ".", with: ",")
        return emailToString
    }
    
    // second탭바에 들어오면 projectID만 따로 배열로 저장
    private func readProjectId() {
        let email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")
        
        self.ref.child("\(email)/").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            
            for (key,val) in value {
                let id = key
                
                guard let val = val as? Dictionary<String, Any> else { return }
                guard let projectTitle = val["projectTitle"] as? String else { return }
                guard let important = val["important"] as? Bool else { return }
                guard let currentTime = val["currentTime"] as? Int else { return }
                
                let p_id = Project(id: id, projectTitle: projectTitle, important: important, currentTime: currentTime)
                self.project.append(p_id)
            }
            
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    //project id선택하면 project내용 db에서 읽어오기
    private func readProjectContent(_ id: String) {
        
        self.projectContent.removeAll()
        
        let email = self.emailToString(Auth.auth().currentUser?.email ?? "고객")

        self.ref.child("\(email)/\(id)/content").observeSingleEvent(of: .value, with: { snapshot in
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
            print(self.projectContent,"확인용용")
            
            self.changeProjectTitleLabel(id)
            self.organizeProjectContent()
            
            DispatchQueue.main.async {
                self.scheduleView.reloadData()
            }

        })
        
        { error in
            print(error.localizedDescription)
        }
    }
    
    // popup창에서 받아온 id값으로 title값 저장 후 projectTitle Label 변경
    private func changeProjectTitleLabel(_ id: String) {
        
        if let projectTitle = self.project.first(where: {$0.id == id}) {
           // it exists, do something
            print("projectTitle이 변경되었습니다.")
            projectTitie.text = projectTitle.projectTitle
            
        } else {
            print("id값이 존재하지 않습니다.")
            return
        }
    }
    
    // scheduleCollectionView에 projectContent값을 적용시키기 위해 projectContent 구조체를 하나의 배열로 정제
    private func organizeProjectContent() {
        print("organizeProjectcontent가 실행됨")
        
        self.scheduleProjectContent.removeAll()

        for projectContent in self.projectContent {
            let listTitle = projectContent.listTitle
            
            for detailContent in projectContent.detailContent {
                let cardName = detailContent.cardName ?? ""
                let startTime = detailContent.startTime ?? ""
                let endTime = detailContent.endTime ?? ""
                print(Schedule(list: listTitle, card: cardName, startTime: startTime, endTime: endTime),"엥?")
                self.scheduleProjectContent.append(Schedule(list: listTitle, card: cardName, startTime: startTime, endTime: endTime))
            }
        }
    }
    
}

extension SecondTabbarViewController: SelectIdDelegate {
    
    // popup창에서 id값 받아오기
    func sendId(_ id: String) {
        self.readProjectContent(id)
    }
}
