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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCalendarView()

                
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.calendarView.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.calendarView.addGestureRecognizer(swipeDown)
        
    }
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {

        // 달력이 반만 나와있을떄 위로 swipe
        if swipe.direction == .up, calendarMode == .halfMonth {
            print("week모드")
            calendarMode = .week
            self.updateWeekMode()
            self.calendarView.reloadData()
        }
        
        // 달력이 전체화면일때 위로 swipe
        else if swipe.direction == .up, calendarMode == .fullMonth {
            print("halfMonth모드")
            calendarMode = .halfMonth
            self.calendarView.reloadData()
        }
        
        // 달력이 week상태일때 아래로 swipe
        else if swipe.direction == .down, calendarMode == .week {
            print("halfMonth모드")
            calendarMode = .halfMonth
            self.calendarView.reloadData()
        }
        
        // 달력이 반만 나와있을떄 아래로 swipe
        else if swipe.direction == .down, calendarMode == .halfMonth {
            print("fullMonth모드")
            calendarMode = .fullMonth
            self.calendarView.reloadData()
            
        }
    }
}

extension SecondTabbarViewController: UICollectionViewDelegate {

}

extension SecondTabbarViewController: UICollectionViewDataSource {
    
    //cell return 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch calendarMode {
        case .halfMonth: return self.daysMonthMode.count
        case .fullMonth: return self.daysMonthMode.count
        case .week: return 7
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
        
        switch calendarMode {
            
        case .halfMonth:
            cell.update(day: self.daysMonthMode[indexPath.row])
            cell.checkCurrentDate(false)
            if dateLabel.text == dateLabeltext && daysMonthMode[indexPath.row] == dayDate {
                cell.checkCurrentDate(true)
                cell.dateLabel.textColor = .white
            }
            return cell
            
            
        case .fullMonth:
            cell.update(day: self.daysMonthMode[indexPath.row])
            cell.checkCurrentDate(false)
            if dateLabel.text == dateLabeltext && daysMonthMode[indexPath.row] == dayDate {
                cell.checkCurrentDate(true)
                cell.dateLabel.textColor = .white
            }
            
            return cell
            
        case .week:
            cell.update(day: self.daysWeekMode[showIndex][indexPath.row])
            cell.checkCurrentDate(false)
            if dateLabel.text == dateLabeltext && daysWeekMode[showIndex][indexPath.row] == dayDate {
                cell.checkCurrentDate(true)

            }
            return cell
        }
    }
}


extension SecondTabbarViewController: UICollectionViewDelegateFlowLayout {
    
    //cell 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.weekStackView.frame.width / 7
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return .zero
        }

}

// claendar 관련 함수
extension SecondTabbarViewController {
    
    //calendarView 초기 설정
    private func configureCalendarView() {
        
        // caledarView ui 설정
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.calendarView.showsVerticalScrollIndicator = false
        self.calendarView.showsHorizontalScrollIndicator = false
        self.calendarView.collectionViewLayout = UICollectionViewFlowLayout()
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        
        // calendarView nib 설정
        let calendarViewCellNib = UINib(nibName: "DateCell", bundle: nil)
        self.calendarView.register(calendarViewCellNib, forCellWithReuseIdentifier: "DateCell")
        
        // calendarView 날짜 설정
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        print(calendarDate,"rrrr")
        
        self.dateFormatter.locale = Locale(identifier: "ko_kr")
        self.dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.currentDate = koreanDate()
        print(currentDate,"kkk")
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
