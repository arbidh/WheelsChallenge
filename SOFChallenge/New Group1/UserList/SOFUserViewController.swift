//
//  SackOverFlowUserViewController.swift
//  StackOverFlowTest
//
//  Created by Arbi Derhartunian on 9/29/19.
//  Copyright © 2019 com.green. All rights reserved.
//

import UIKit
import PureLayout

class SOFUserViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    //count of pages to reload
    private static var count = 20
    
    @objc var userBlock:UserListBlock?
    private var notFromAPI: Bool = false
    private func configureView() {
        registerCell()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        setupRefreshControl()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUsers) )
    }
    
    @objc private func refreshData() {
        populateUserViewModel(limit: 20)
    }
    
    private func registerCell() {
        tableView.register(SOFUserCellTableViewCell.self, forCellReuseIdentifier: SOFUserCellTableViewCell.ReusableID)
    }
    
    @objc private func addUsers() {
        if let addVC = SOFAddViewController(vm: self.usersViewModel) {
            self.navigationController?.pushViewController(addVC , animated: true)
            addVC.userBlock = ({ userlistModel in
                if let userlistModel = userlistModel {
                    self.updateViewModel(viewModel: userlistModel)
                }
            })
            self.userBlock = addVC.userBlock
        }
    }
    
    @objc var usersViewModel: SOFUserViewModel = SOFUserViewModel()
    @objc var reload:Bool = false {
        didSet {
            if self.usersViewModel.users?.count != 0 {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc public func updateViewModel(viewModel: SOFUserViewModel) {
        self.usersViewModel = viewModel
        self.usersViewModel.chachedUsers = viewModel.users
      
        if(self.usersViewModel.chachedUsers?.count ?? 0 > 0){
            let chachedArray = self.usersViewModel.chachedUsers
            var newArray:[SOFUserData] = []
            chachedArray?.forEach({ data in
                newArray.append(data)
            })
            viewModel.users = newArray
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateUserViewModel(limit: 20)
    }
    
    override func loadView() {
        super.loadView()
        configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usersViewModel = SOFUserViewModel()
    }
}

extension SOFUserViewController  {
    func populateUserViewModel(limit: Int) {
        if(notFromAPI){
            return;
        }
        let requestService = SOFUserDataService()
        requestService.getUsers(with: SOFUserViewController.count + limit) { (users, error) in
            if let users = users {
                self.refreshControl.endRefreshing()
                self.updateViewModel(viewModel: SOFUserViewModel(users: users))
                self.reload = true
            }
            if let error = error {
                let viewModel = ErrorViewModel(title:"users Could not be found", message:error.errorMessage, buttonTitles: ["OK"])
                DispatchQueue.main.async {[weak self] in
                    self?.presentError(viewModel: viewModel)
                }
            }
        }
    }
}

private extension SOFUserViewController {
    
    func setupRefreshControl(){
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action:#selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = .white
    }
}

extension SOFUserViewController : UITableViewDataSource, ErrorPresenter {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersViewModel.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stackOverFlowUserCell: SOFUserCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: SOFUserCellTableViewCell.ReusableID, for: indexPath) as! SOFUserCellTableViewCell 
        if let users = self.usersViewModel.users {
            stackOverFlowUserCell.configureCell(userData: users[indexPath.row])
        }
        return stackOverFlowUserCell
    }
    
    //This is called to fetch more data and paginate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let data = usersViewModel.users{
            if indexPath.row == data.count - 1 {
                if let users = self.usersViewModel.users {
                    if users.count > Int(0){
                        populateUserViewModel(limit: 2)
                    }
                }
            }
        }
    }
}

extension SOFUserViewController  : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

