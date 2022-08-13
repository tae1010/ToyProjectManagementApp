//
//  SecondTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/07.
//

import UIKit

enum CalendarMode {
    case fullMonth
    case halfMonth
    case week
}

class SecondTabbarViewController: UIViewController {

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
    var showIndex: Int = 0 // week모드일때 보여줄 배열, 현재날짜가 포함된 주를 보여줌(선택한 cell이 있으면 선택한 cell이 포함된 주를 보여줌)
    
    @IBOutlet weak var dateLabel: UILabel! // 상단에 년과 월을 표시하는 label
    @IBOutlet weak var dateStackView: UIStackView! // dateLabel + 옆에 v버튼
    @IBOutlet weak var weekStackView: UIStackView! // 일~토를 표시하는 label stackView
    @IBOutlet weak var calendarView: UICollectionView! // calendar collectionView
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint! // calendarView 높이
    @IBOutlet weak var betweenCaledarScheduleView: UIView! // calendarView와 scheduleview 사이 이미지뷰
    @IBOutlet weak var scheduleView: UICollectionView! // schedule collectionView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCalendarView()
        self.configureScheduleView()
        
        self.betweenCaledarScheduleView.translatesAutoresizingMaskIntoConstraints = false
        self.scheduleView.translatesAutoresizingMaskIntoConstraints = false

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
    }
    
    private func moveView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.dateLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
            self.dateLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 15).isActive = true
            
            self.betweenCaledarScheduleView.topAnchor.constraint(equalTo: self.calendarView.bottomAnchor, constant: 0).isActive = true
            self.scheduleView.topAnchor.constraint(equalTo: self.betweenCaledarScheduleView.bottomAnchor, constant: 0).isActive = true
            //self.betweenCaledarScheduleView.transform = CGAffineTransform(translationX: 0, y: -200)
            
        })
    }
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        
        if swipe.direction == .up, self.calendarMode == .halfMonth {
            self.calendarMode = .week
            self.updateWeekMode()
        } else if swipe.direction == .up, self.calendarMode == .fullMonth {
            self.calendarMode = .halfMonth
        } else if swipe.direction == .down, self.calendarMode == .week {
            self.calendarMode = .halfMonth
        }  else if swipe.direction == .down, self.calendarMode == .halfMonth {
            self.calendarMode = .fullMonth
        } else if swipe.direction == .up, self.calendarMode == .week {
            return
        } else if swipe.direction == .down, self.calendarMode == .fullMonth {
            return
        }
        
        self.calendarView.performBatchUpdates({
            self.calendarView.reloadSections(IndexSet(integer: 0))
        }, completion: { [weak self]_ in
            DispatchQueue.main.async {
                self?.calendarView.reloadData()
                self?.moveView()
            }
            
           
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
            
        }
    }
}

extension SecondTabbarViewController: UICollectionViewDataSource {
    
    //cell return 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calendarView {
            switch calendarMode {
            case .halfMonth, .fullMonth: return self.daysMonthMode.count
            case .week: return 7
            }
        } else {
            return 3
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
            scheduleCell.cardlabel.text = "card1"
            scheduleCell.cardDateLabel.text = "2022.08.01 - 2022.08.10"
            
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
            // halfMonth, week모든 가로 새로의 길이가 같다.
            case .halfMonth, .week:
                return CGSize(width: width, height: width)
                
            //fullMonth는 view를 꽉채워야 하기 떄문에 새로의 길이가 길어져야 함
            case .fullMonth:
                self.calendarViewHeight.constant = UIScreen.main.bounds.height - 70
                let height = UIScreen.main.bounds.height / 5 - 70
                return CGSize(width: width, height: height)
            }
        } else {
            
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height / 10
            
            return CGSize(width: width, height: height)
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
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
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
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.dateFormatter.locale = Locale(identifier: "ko_kr")
        self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.currentDate = koreanDate()
        self.updateCalendar()
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
    
    // 달에 총 몇일이 있는지 계산
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
    
    // 날짜 업데이트 (week 모드)
    func updateWeekMode() {
        print("updateWeekMode 실행")
        self.daysWeekMode.removeAll()
        var count = 0
        var index = 0
        var week = [String]()
        
        for i in self.daysMonthMode {
            // 현재 날짜가 있는 2차원 배열에 index에 배열
            print(i, currentDate, type(of: i), type(of: currentDate))
            if i == String(dayDate) { self.showIndex = index }
            
            // 만약 선택된 날짜가 있다면 선택된 날짜가 있는 배열index가 showIndex에 들어감
            if let _ = selectDate { self.showIndex = index }

            week.append(i)
            
            // 7개씩 daysWeekMode 배열에 저장
            if count == 6 {
                self.daysWeekMode.append(week)
                week.removeAll()
                count = 0
                index += 1
            } else { count += 1 }
        }
    }
    
    // 달력 업데이트
    func updateCalendar() {
        self.updateTitle()
        self.updateMonthMode()
        self.updateWeekMode()
    }
}

/// scheduleView 관련 함수
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

