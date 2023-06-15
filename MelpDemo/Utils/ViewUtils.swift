//
//  ViewUtils.swift
//  MelpDemo
//
//  Created by Bomidyala Swathi on 15/06/23.
//

import Foundation
import UIKit

extension UIView {
    //Good to have: We can maintain tag in constants and show some text to the loader
    func showLoader(show: Bool) {
        let activityIndicatorView: UIActivityIndicatorView = self.viewWithTag(1000) as? UIActivityIndicatorView ?? UIActivityIndicatorView(style: .large)
        
        if show {
            activityIndicatorView.frame = self.frame
            activityIndicatorView.tag = 1000
            activityIndicatorView.center = self.center
            self.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
        }
        else {
            activityIndicatorView.stopAnimating()
        }
    }
}
