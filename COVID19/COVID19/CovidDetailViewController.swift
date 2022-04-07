//
//  CovidDetailViewController.swift
//  COVID19
//
//  Created by 김후정 on 2022/04/04.
//

import UIKit

class CovidDetailViewController: UITableViewController {

    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var recoverdCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var resgionalOutbreakCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    
    var covidOverview: CovidOverView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        guard let covidOverview = self.covidOverview else { return }
        self.title = covidOverview.countryName
        self.newCaseCell.detailTextLabel?.text = "\(covidOverview.newCase)명"
        self.totalCaseCell.detailTextLabel?.text = "\(covidOverview.totalCase)명"
        self.recoverdCell.detailTextLabel?.text = "\(covidOverview.recovered)명"
        self.deathCell.detailTextLabel?.text = "\(covidOverview.death)명"
        self.percentageCell.detailTextLabel?.text = "\(covidOverview.percentage)%"
        self.resgionalOutbreakCell.detailTextLabel?.text = "\(covidOverview.newFcase)명"
        self.overseasInflowCell.detailTextLabel?.text = "\(covidOverview.newCcase)명"
    }
}
