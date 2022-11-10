//
//  loading.swift
//  foreignpolicy
//
//  Created by Даниил on 10.11.2022.
//

import Foundation
import UIKit

class loading {
    
    // MARK: Properties
    var timer: Timer?
    
    let loadLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "Loading."
        return label
    }()
    
    // MARK: Selectors
    public func addToView(with view: UIView){
        view.addSubview(loadLabel)
        loadLabel.translatesAutoresizingMaskIntoConstraints = false
        loadLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        /// creating animation of loadLabel
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
            var string: String {
                switch self.loadLabel.text {
                    case "Loading.":       return "Loading.."
                    case "Loading..":      return "Loading..."
                    case "Loading...":     return "Loading."
                    default:               return "Loading"
                }
            }
            self.loadLabel.text = string
        }
    }
    
    public func removeFromView(with view: UIView){
        loadLabel.isHidden = true
        timer?.invalidate()
        loadLabel.removeFromSuperview()
    }
}
