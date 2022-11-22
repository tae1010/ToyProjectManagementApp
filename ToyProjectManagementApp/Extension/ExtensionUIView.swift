//
//  ExtensionUIView.swift
//  ToyProjectManagementApp
//
//  Created by 김정태 on 2022/10/17.
//

import UIKit

extension UIView {
    static func animateCurveEaseOut(withDuration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: withDuration,
            delay: 0,
            usingSpringWithDamping: 1.1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: animations,
            completion: completion)
    }
//
//
//    func loadXib() {
//        // 1
//        let identifier = String(describing: type(of: self))
//        // 2
//        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
//        // 3
//        guard let customView = nibs?.first as? UIView else { return }
//        // 4
//        customView.frame = self.bounds
//        // 5
//        self.addSubview(customView)
//    }
    
    
    // cell 이동 애니메이션 효과
    func snapshotCellStyle() -> UIView {
        let image = snapshot()
        let cellSnapshot = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }

    // cell 이동 위치조정?
    private func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        return image
    }
}

