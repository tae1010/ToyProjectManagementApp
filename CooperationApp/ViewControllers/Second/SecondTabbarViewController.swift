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
    private var days = [String]() // 달력에 표시될 날짜 배열
    var currentDate: Int = 0 // 현재날짜를 저장할 변수 (년, 월)
    var dateLabeltext: String? // 현재 날짜 일때 dateLabel에 저장된 변수 저장
    var dayDate: String = " " //현재 날짜(일)
    var calendarMode: CalendarMode = .halfMonth
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var weekStackView: UIStackView!
    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCalendarView()

                
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
    }
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {

        // 달력이 반만 나와있을떄 위로 swipe
        if swipe.direction == .up, calendarMode == .halfMonth {
            print("week모드")
            calendarMode = .week
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
    
    // 날짜 업데이트
    func updateDays() {
        self.days.removeAll()
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let totalDays = startDayOfTheWeek + self.endDate()
        
        // 만약에 1일이 화요일부터 시작된다고 하면 ["", "", "1", "2" ....] 이런식으로 저장됨
        for day in Int()..<totalDays {
            if day < startDayOfTheWeek {
                self.days.append("")
                continue
            }
            self.days.append("\(day - startDayOfTheWeek + 1)")
        }
        
        self.calendarView.reloadData()
    }
    
    // 달력 업데이트
    func updateCalendar() {
        self.updateTitle()
        self.updateDays()
    }
    
}

extension SecondTabbarViewController: UICollectionViewDelegate {
 
}

extension SecondTabbarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch calendarMode {
        case .halfMonth: return self.days.count
        case .fullMonth: return self.days.count
        case .week: return 7
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
        cell.update(day: self.days[indexPath.row])

        if dateLabel.text == dateLabeltext, days[indexPath.row] == dayDate {
            
            print("오늘 날짜 실행됨",indexPath.row)
            cell.check = true
            cell.dateLabel.textColor = .white
            cell.cellBackground.backgroundColor = UIColor.black
            cell.cellBackground.layer.cornerRadius = 5.0
        }
        return cell
    }
}


extension SecondTabbarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.weekStackView.frame.width / 7
        return CGSize(width: width, height: width)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
            return .zero
        }

}
