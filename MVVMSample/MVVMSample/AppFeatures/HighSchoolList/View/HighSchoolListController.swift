//
//  HighSchoolListController.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import Foundation
import UIKit
class HighSchoolListController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var highSchoolTableView: UITableView!
    
    //MARK: - Local Variables
    var listingData: [schoolData]?
    var viewModel: HighSchoolListViewModel!

    
    //MARK: - App life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        viewModel = HighSchoolListViewModel(delegate: self)
        highSchoolTableView.delegate = self
        highSchoolTableView.dataSource = self
        viewModel.getHighSchoolList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /*
     This method is to
     register table view cells
     */
    func registerXib(){
        highSchoolTableView.register(UINib(nibName: Constant.HighSchoolListConstants.highSchoolListingTableCell, bundle: nil), forCellReuseIdentifier: Constant.HighSchoolListConstants.highSchoolListingTableCell)
    }
}
//MARK: - TableView Delegates and DataSources
extension HighSchoolListController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.listingData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.HighSchoolListConstants.highSchoolListingTableCell, for: indexPath) as! HighSchoolListCell
        cell.setSchooldata(model: self.listingData?[indexPath.row])
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Implement logic for detail
        if let detailVC = UIStoryboard.init(name: StoryBoard.main, bundle: nil).instantiateViewController(withIdentifier:ViewControllers.highSchoolDetailController) as? HighSchoolDetailViewController{
            let schoolObj = self.listingData?[indexPath.row]
            detailVC.schoolListObj = schoolObj
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

//MARK: - Extensions for HIghSchoolList
extension HighSchoolListController: HighSchoolListDelegate{
    func tableReload() {
        DispatchQueue.main.async {
            self.highSchoolTableView.reloadData()
        }
    }
    
    func success(response: String) {
        self.listingData = viewModel.schoolListing
    }
}

