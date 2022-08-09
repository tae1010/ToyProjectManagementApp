//
//  SecondTabbarViewController.swift
//  CooperationApp
//
//  Created by 김정태 on 2022/04/07.
//

import UIKit



class SecondTabbarViewController: UIViewController {
    
    let calendar = Calendar.current
    
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var weekStackView: UIStackView!
    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        
        let calendarViewCellNib = UINib(nibName: "DateCell", bundle: nil)
        self.calendarView.register(calendarViewCellNib, forCellWithReuseIdentifier: "DateCell")
    }
    
    private func configureCalendarView() {
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.calendarView.showsVerticalScrollIndicator = false
        self.calendarView.showsHorizontalScrollIndicator = false
        //self.calendarHeight.constant = self.view.bounds.height / 2
        
        if let flowLayout = calendarView.collectionViewLayout as? UICollectionViewFlowLayout {
                    flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                }
    }
    
}

extension SecondTabbarViewController: UICollectionViewDelegate {
    
}

extension SecondTabbarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCollectionViewCell else {
                    return UICollectionViewCell()
                }
        cell.dateString = "good"
        print("cell이 리턴됐나?")
        return cell

    }
}


extension SecondTabbarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.weekStackView.frame.width / 7
        print(width,"스택뷰")
        print(self.view.bounds.height)
        return CGSize(width: width, height: width)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
            return .zero
        }

}
