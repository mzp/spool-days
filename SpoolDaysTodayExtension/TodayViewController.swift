import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {

    let cellHeight = CGFloat(44.0)
    let maxCellNumber = 5
    var tableView: UITableView?
    var dates: [Dictionary<String, String>] = []

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDefaultsDidChange:",
            name: NSUserDefaultsDidChangeNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRectMake(0, 0, view.bounds.width - 100, view.bounds.height), style: UITableViewStyle.Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.layer.backgroundColor = UIColor.clearColor().CGColor
        view.addSubview(tableView!)
        dates = GroupData.getDates(maxCellNumber)
        preferredContentSize.height = cellHeight * CGFloat(dates.count)
    }

    override func viewWillAppear(animated: Bool) {
        dates = GroupData.getDates(maxCellNumber)
        preferredContentSize.height = cellHeight * CGFloat(dates.count)
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.backgroundColor = UIColor.clearColor().CGColor
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")

        cell.textLabel?.text = dates[indexPath.row]["title"]
        cell.textLabel?.textColor = UIColor.whiteColor()

        let date = NSDate.fromString(dates[indexPath.row]["date"]!)!
        let interval = date.dateIntervalFromDate(NSDate())
        let unit = NSLocalizedString("Days", comment: "")
        cell.detailTextLabel?.text = "\(interval) \(unit)"
        cell.detailTextLabel?.textColor = UIColor.whiteColor()

        return cell
    }

    func userDefaultsDidChange(notification: NSNotification) {
        dates = GroupData.getDates(maxCellNumber)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let url = GroupData.appURL {
            extensionContext?.openURL(url, completionHandler: nil)
        }
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
}
