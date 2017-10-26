/*
 * CalendarView+Delegate.swift
 * Created by Michael Michailidis on 24/10/2017.
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

extension CalendarView: UICollectionViewDelegateFlowLayout {
    
    func deselectAllSelected() {
        if let indexPathsForSelectedItems = self.collectionView.indexPathsForSelectedItems {
            for indexPath in indexPathsForSelectedItems {
                self.collectionView.deselectItem(at: indexPath, animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard
            let dateBeingSelectedByUser = self.dateBeingSelectedByUser,
            let (firstDayIndex, _) = self.monthInfo[indexPath.section] else { return }
        
        // indexPath.item might be 26 (the number of the cell from top left) while the 'fromStart...' 20, the index from the cell with 1rst of month
        let fromStartOfMonthIndexPath = IndexPath(item: indexPath.item - firstDayIndex, section: indexPath.section)
        
        if let eventsForDaySelected = eventsByIndexPath[fromStartOfMonthIndexPath] {
            delegate?.calendar(self, didSelectDate: dateBeingSelectedByUser, withEvents: eventsForDaySelected)
        } else {
            delegate?.calendar(self, didSelectDate: dateBeingSelectedByUser, withEvents: [])
        }
        
        // Update model
        selectedIndexPaths.append(indexPath)
        selectedDates.append(dateBeingSelectedByUser)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let dateBeingSelectedByUser = dateBeingSelectedByUser else { return }
        
        delegate?.calendar(self, didDeselectDate: dateBeingSelectedByUser)
        
        guard let index = selectedIndexPaths.index(of: indexPath) else { return }
        
        selectedIndexPaths.remove(at: index)
        selectedDates.remove(at: index)
        
        if self.collectionView.allowsMultipleSelection {
            self.dateBeingSelectedByUser = selectedDates.last
        } else {
            self.dateBeingSelectedByUser = nil
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard let (firstDayInMonth, _) = self.monthInfo[indexPath.section] else { return false }
        
        var offsetComponents    = DateComponents()
        offsetComponents.month  = indexPath.section
        offsetComponents.day    = indexPath.item - firstDayInMonth
        
        guard let dateUserSelected = self.gregorian.date(byAdding: offsetComponents, to: startOfMonthCache) else { return false }
        
        dateBeingSelectedByUser = dateUserSelected
        
        if let delegate = self.delegate {
            return delegate.calendar(self, canSelectDate: dateUserSelected)
        }
   
        return true // default
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.updateAndNotifyScrolling()
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
  
        self.updateAndNotifyScrolling()
    }
    
    func updateAndNotifyScrolling() {
        
        guard let date = self.dateFromScrollViewPosition() else { return }
        
        self.displayDateOnHeader(date)
        self.delegate?.calendar(self, didScrollToMonth: date)
        
    }

    @discardableResult
    func dateFromScrollViewPosition() -> Date? {
        
        var page: Int = 0
        
        switch self.direction {
        case .horizontal:   page = Int(floor(self.collectionView.contentOffset.x / self.collectionView.bounds.size.width))
        case .vertical:     page = Int(floor(self.collectionView.contentOffset.y / self.collectionView.bounds.size.height))
        }
        
        page = page > 0 ? page : 0
        
        var monthsOffsetComponents = DateComponents()
        monthsOffsetComponents.month = page
        
        return self.gregorian.date(byAdding: monthsOffsetComponents, to: self.startOfMonthCache);
        
    }
    
    func displayDateOnHeader(_ date: Date) {
        
        let month = self.gregorian.component(.month, from: date) // get month
        
        let monthName = DateFormatter().monthSymbols[(month-1) % 12] // 0 indexed array
        
        let year = self.gregorian.component(.year, from: date)
        
        
        self.headerView.monthLabel.text = monthName + " " + String(year)
        
        self.displayDate = date
    }
}