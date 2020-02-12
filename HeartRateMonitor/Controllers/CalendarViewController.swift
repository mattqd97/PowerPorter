import UIKit
import JTAppleCalendar

var moodarray : [Int] = [];
let moodcolors : [UIColor] = [UIColor(named: "NoStress")!, UIColor(named: "LowStress")!, UIColor(named: "MediumStress")!, UIColor(named: "HighStress")!];

class ViewController: UIViewController {
    @IBOutlet weak var monthLabel: UILabel!
    override func viewDidLoad() {
        moods()
        monthLabel.text = "October"
        super.viewDidLoad()
    }
    
    func moods() -> Void {
        for _ in 1...20{
            moodarray.append(Int(arc4random_uniform(4)))
        }
        
    }
    let n = Int(arc4random_uniform(42))
    
  func configureCell(view: JTACDayCell?, cellState: CellState) {
        
        let da = Int(cellState.text)!
        let currdata = Date();
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        if  ((cellState.dateBelongsTo == .thisMonth) && (cellState.date.timeIntervalSinceNow<0)) {
            cell.contentView.backgroundColor = moodcolors[moodarray[da%20]]
        }
        
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
}

extension ViewController: JTACMonthViewDataSource {
  func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2019 10 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension ViewController: JTACMonthViewDelegate {
  func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
  func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
}




