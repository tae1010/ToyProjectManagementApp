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
    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        let calendarViewCellNib = UINib(nibName: "DateCell", bundle: nil)
        self.calendarView.register(calendarViewCellNib, forCellWithReuseIdentifier: "DateCell")
    }
    
}

extension SecondTabbarViewController: UICollectionViewDelegate {
    
}

extension SecondTabbarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 10

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCollectionViewCell else {
                    return UICollectionViewCell()
                }
        print("cell이 리턴됐나?")
        return cell

    }
}
