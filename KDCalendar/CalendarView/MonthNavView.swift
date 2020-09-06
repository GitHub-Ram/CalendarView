//
//  MonthNavView.swift
//  CalendarView
//
//  Created by Ram on 07/02/20.
//  Copyright © 2020 Karmadust. All rights reserved.
//

import UIKit

@IBDesignable
open class MonthNavView: UIView {

    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var previousBtn: UIButton!
    //let calendarView : UIView
    @IBAction func nextBtnClicked(_ sender: Any) {
    }
    @IBAction func previousBtnClicked(_ sender: Any) {
        //CalendarView.goToPreviousMonth()
    }
    @IBOutlet weak var monthLabel: UILabel!
    var view: UIView!
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //loadViewFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        //loadViewFromNib()
    }

    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String("MonthNavigation"), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        addSubview(view)
        
        self.view = view
    }
    
}

