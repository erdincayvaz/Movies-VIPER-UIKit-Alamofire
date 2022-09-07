//
//  Extensions.swift
//  Movies
//
//  Created by Erdinç Ayvaz on 17.08.2022.
//

import Foundation
import UIKit

extension UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
}

extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension Double {
    
    func format (sayi:Double, basamakSayisi:Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = basamakSayisi
        formatter.maximumFractionDigits = basamakSayisi
        formatter.generatesDecimalNumbers = true
        
        return formatter.string(from:NSNumber(value: sayi))!
    }
}

extension UILabel {
    
    func pointFormat(value:Double){
        var strValue = value.format(sayi: value, basamakSayisi: 1)
        strValue += "/10"
        let characterCount = strValue.count
        
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: strValue, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13, weight: .medium)])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: NSRange(location:characterCount-3,length:3))
        
        self.attributedText = myMutableString
    }
}

extension String {
    
    func dateFormatMovie() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        let movieFormat = DateFormatter()
        movieFormat.dateFormat = "dd.MM.yyyy"
        return movieFormat.string(from: date ?? Date())
    }
}
