//
//  SecondTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/07.
//

import UIKit
import FSCalendar

enum CalendarMode {
    case week // 주 단위 일때
    case halfMonth // 월 단위 일때 (화면에 리스트와 달력 표시)
    case fullMonth // 월 단위 일때 (화면 전체를 달력으로 표시)
}

class SecondTabbarViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar! // 달력
    @IBOutlet weak var calendarHeight: NSLayoutConstraint! // 달력의 높이
    let dateFormatter = DateFormatter()
    var events = [String]()
    var calendarMode: CalendarMode = .halfMonth
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCalendar()
        self.setEvents()
        
        calendarHeight.constant = self.view.bounds.height
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {

        // 달력이 반만 나와있을떄 위로 swipe
        if swipe.direction == .up, calendarMode == .halfMonth {
            print("week모드")
            calendarMode = .week
            calendar.setScope(.week, animated: true)
        }
        
        // 달력이 전체화면일때 위로 swipe
        else if swipe.direction == .up, calendarMode == .fullMonth {
            print("halfMonth모드")
            calendarMode = .halfMonth
            calendar.setScope(.month, animated: true)
        }
        
        // 달력이 week상태일때 아래로 swipe
        else if swipe.direction == .down, calendarMode == .week {
            print("halfMonth모드")
            calendarMode = .halfMonth
            calendar.setScope(.month, animated: true)
        }
        
        // 달력이 반만 나와있을떄 아래로 swipe
        else if swipe.direction == .down, calendarMode == .halfMonth {
            print("fullMonth모드")
            calendarMode = .fullMonth
            calendar.setScope(.month, animated: true)
            
        }
    }
    
    func configureCalendar() {
        
//        calendar.allowsMultipleSelection = true // 다중 선택
//
//        calendar.swipeToChooseGesture.isEnabled = true // 꾹 눌러서 드래그 동작으로 다중 선택
        
        calendar.locale = Locale(identifier: "ko_KR")
//        calendar.scope = .week   // 주간
//        calendar.scope = .month  // 월간
        
        calendar.appearance.eventDefaultColor = UIColor.green
        calendar.appearance.eventSelectionColor = UIColor.green
                
        //MARK: -상단 헤더 뷰 관련
        calendar.headerHeight = 66 // YYYY년 M월 표시부 영역 높이
        calendar.weekdayHeight = 41 // 날짜 표시부 행의 높이
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0 //헤더 좌,우측 흐릿한 글씨 삭제
        calendar.appearance.headerDateFormat = "YYYY년 M월" //날짜(헤더) 표시 형식
        calendar.appearance.headerTitleColor = .black //2021년 1월(헤더) 색
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24) //타이틀 폰트 크기
               
               
        //MARK: -캘린더(날짜 부분) 관련
        calendar.backgroundColor = .white // 배경색
        calendar.appearance.weekdayTextColor = .black //요일(월,화,수..) 글씨 색
        //calendar.appearance.selectionColor = .calendarSelectCircleGrey //선택 된 날의 동그라미 색
        calendar.appearance.titleWeekendColor = .black //주말 날짜 색
        calendar.appearance.titleDefaultColor = .black //기본 날짜 색
                
                
        //MARK: -오늘 날짜(Today) 관련
        //calendar.appearance.titleTodayColor = .seaweed //Today에 표시되는 특정 글자색
        calendar.appearance.todayColor = .clear //Today에 표시되는 선택 전 동그라미 색
        ///calendar.appearance.todaySelectionColor = .none  //Today에 표시되는 선택 후 동그라미 색
                // Month 폰트 설정
        calendar.appearance.headerTitleFont = UIFont(name: "NotoSansCJKKR-Medium", size: 16)
                
                
                // day 폰트 설정
        calendar.appearance.titleFont = UIFont(name: "Roboto-Regular", size: 14)
        
    }
    
    func setEvents() {
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // events
        let myFirstEvent = dateFormatter.date(from: "2022-01-01")
        let mySecondEvent = dateFormatter.date(from: "2022-01-31")
        
        let changeDate = dateFormatter.string(from: myFirstEvent!)
        let changeDate2 = dateFormatter.string(from: mySecondEvent!)
        
        events = [changeDate, changeDate,changeDate,changeDate,changeDate]

    }
    
    

}

extension SecondTabbarViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let dateString = self.dateFormatter.string(from: date)

        if self.events.contains(dateString) {
            return events.count
        }

        return 0
    }
    
    //달력 swipe시 애니메이션
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        if calendar.scope == .week {
            // 일주일 단위일 때는 높이를 맞게 설정
            calendarHeight.constant = bounds.height
        } else if calendar.scope == .month {
            // 한달 단위일 때는 높이를 전체화면으로 설정
            calendarHeight.constant = self.view.bounds.height
        }
            
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}
