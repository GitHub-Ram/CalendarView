/*
 * CalendarHeaderView.swift
 * Created by Michael Michailidis on 07/04/2015.
 * http://blog.karmadust.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

open class CalendarHeaderView: UIView {
    
    var style: CalendarView.Style = CalendarView.Style.Default {
        didSet {
            updateStyle()
        }
    }
    
    var monthLabel: UILabel!
    var dayLevelView: UIView!
    var navView: MonthNavView!
    var dayLabels = [UILabel]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        monthLabel = UILabel()
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.backgroundColor = UIColor.clear
        self.addSubview(monthLabel)
        
        navView = MonthNavView()
        navView.translatesAutoresizingMaskIntoConstraints = true
        //navView.backgroundColor = UIColor.black
        self.addSubview(navView)
        
        dayLevelView = UIView()
        dayLevelView.translatesAutoresizingMaskIntoConstraints = false
        dayLevelView.backgroundColor = UIColor.lightGray
        self.addSubview(dayLevelView)
        
        for _ in 0..<7 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = UIColor.clear
            
            dayLabels.append(label)
            self.addSubview(label)
        }
    }
    
    public func updateStyle() {
        self.monthLabel.textAlignment = NSTextAlignment.center
        self.monthLabel.font = UIFont(name:"Arial-BoldMT", size: 18)
        self.monthLabel.textColor = UIColor.white
        self.monthLabel.backgroundColor = UIColor.orange
        
        let formatter = DateFormatter()
        formatter.locale = style.locale
        formatter.timeZone = style.calendar.timeZone
        
        let start = style.firstWeekday == .sunday ? 0 : 1
        var i = 0
        
        for index in start..<(start+7) {
            let label = dayLabels[i]
            label.font = UIFont(name:"Arial-BoldMT", size: 18)
            label.text = formatter.veryShortWeekdaySymbols[(index % 7)].capitalized
            label.textColor = style.weekdaysTextColor
            label.textAlignment = .center
            
            i = i + 1
        }

        self.backgroundColor = style.weekdaysBackgroundColor
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        var isRtl = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        
        if #available(iOS 10.0, *) {
            isRtl = self.effectiveUserInterfaceLayoutDirection == .rightToLeft
        }
        else if #available(iOS 9.0, *) {
            isRtl = UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft
        }
        
        self.monthLabel?.frame = CGRect(
            x: 3,
            y: style.headerTopMargin-3,
            width: self.bounds.size.width-6,
            height: self.bounds.size.height
                - style.headerTopMargin
                - style.weekdaysHeight
                - style.weekdaysBottomMargin
                - style.weekdaysTopMargin
                - style.monthNavHeight
                + 3
        )
        
        self.navView?.frame = CGRect(
            x: 3,
            y: self.monthLabel.frame.height + 4,
            width: self.bounds.size.width-6,
            height: style.monthNavHeight
        )
        
        let labelViewFrame = CGRect(
            x: 3,
            y: self.bounds.size.height
                - style.weekdaysBottomMargin
                - style.weekdaysHeight,
            width: self.bounds.size.width - 6,
            height: style.weekdaysHeight
        )
        
        self.dayLevelView.frame = labelViewFrame
        
        var labelFrame = CGRect(
            x: 0.0,
            y: self.bounds.size.height
            - style.weekdaysBottomMargin
            - style.weekdaysHeight,
            width: (self.bounds.size.width) / 7.0,
            height: style.weekdaysHeight
        )
        
        if isRtl {
            labelFrame.origin.x = (self.bounds.size.width) - labelFrame.width
        }
        
        for lbl in self.dayLabels {
            lbl.frame = labelFrame
            
            labelFrame.origin.x += isRtl ? -labelFrame.size.width : labelFrame.size.width
        }
    }
}
