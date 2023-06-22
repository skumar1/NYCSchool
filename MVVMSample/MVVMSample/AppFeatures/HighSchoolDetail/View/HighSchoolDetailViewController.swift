//
//  HighSchoolDetailViewController.swift
//  MVVMSample
//
//  Created by Santosh Kumar on 6/21/23.
//

import Foundation
import UIKit
class HighSchoolDetailViewController: BaseViewController {
    //MARK: - Local Variables
    var viewModel: HighSchoolDetiailViewModel!
    var schoolListObj: schoolData!
    var schoolDetailObj: HighSchoolDetailData!
    //MARK: - IBOutlets
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var readingScore: UILabel!
    @IBOutlet weak var writingScore: UILabel!
    @IBOutlet weak var mathScore: UILabel!

    
    //MARK: - App life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HighSchoolDetiailViewModel(delegate: self,data: schoolListObj)
        viewModel.getHighSchoolDetailList()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension HighSchoolDetailViewController:HighSchoolDetailDelegates{
    func updateDetails() {
        DispatchQueue.main.async { [self] in
            // Update screen with detail object
            self.schoolName.text = viewModel.detailData?.school_name
            self.overview.text = schoolListObj?.overview_paragraph
            if (viewModel.detailData?.sat_critical_reading_avg_score) != nil{
                readingScore.text = "Reading Score : " + (viewModel.detailData?.sat_critical_reading_avg_score ?? "")
            }
            if (viewModel.detailData?.sat_writing_avg_score) != nil{
                writingScore.text = "Writing Score : " + (viewModel.detailData?.sat_writing_avg_score ?? "")
            }
            if (viewModel.detailData?.sat_math_avg_score) != nil{
                mathScore.text = "Math Score : " + (viewModel.detailData?.sat_math_avg_score ?? "")
            }
        }
    }
    func success(response: String) {
        self.schoolDetailObj = viewModel.detailData
    }
}
