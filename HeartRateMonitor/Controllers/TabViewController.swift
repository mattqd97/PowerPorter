// View Controller for Tab view
// Really just sets the index to the middle


import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.selectedIndex = 2
    }
  
}
