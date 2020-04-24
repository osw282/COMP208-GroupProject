//
//  General.swift
//  COMP208-GroupProject
//
//  Created by Oscar Wong on 23/04/2020.
//  Copyright © 2020 Group36. All rights reserved.
//

import UIKit
import PKHUD
class Messenger {
    static func showMessage(title: String, content: String, completion: (() -> Void)? = nil) {
        let vc = UIAlertController(title: title, message: content, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        //present(vc, animated: true)
        UIApplication.topViewController()?.present(vc, animated: true)
    }
}

class Indicator {
    static func showLoading() {
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
    }
    static func hide() {
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
}


extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}




extension Date {
    init(dateString: String, format: String, locale: Locale = Locale(identifier: "en_US_POSIX")) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = format
        dateFormatter.calendar =  Calendar(identifier: Calendar.Identifier.iso8601)
        
        let d = dateFormatter.date(from: dateString)
        self.init(timeInterval:0, since:d!)
    }
}
