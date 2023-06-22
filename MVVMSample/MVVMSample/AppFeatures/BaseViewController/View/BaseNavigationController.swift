//
//  BaseNavigationController.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setRootViewController()

    }
    
    func setRootViewController() {
        let ViewController = UIStoryboard(name: StoryBoard.main, bundle: nil).instantiateViewController(withIdentifier: ViewControllers.highSchoolListController) as! HighSchoolListController
        
        self.setViewControllers([ViewController], animated: false)
    }
}
