//
//  ListGistsViewController.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 26.09.2024.
//

import UIKit

final class ListGistsViewController: UIViewController {
    // MARK: - UI
    private var tableView: UITableView!
    private var refControl: UIRefreshControl!
    
    private let viewModel: ListGistsViewModel
    
    init(viewModel: ListGistsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    deinit {
        let imageCache = NSCache<AnyObject, AnyObject>()
        imageCache.removeAllObjects()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

//MARK: - FirstViewModel Delegate
extension ListGistsViewController: ListGistsViewModelDelegate {
    func dataSourceDidChange(rows: [ListGistsViewModel.ItemModel]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - TableView Data Source
extension ListGistsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = viewModel.rows[indexPath.row]
        
        if indexPath.row == viewModel.rows.count - 1 {
            viewModel.getNextPage()
        }
        
        switch row {
            case .gist(let avatarUrl, let title, let nameOwner):
            let cell = tableView.dequeueReusableCell(of: GistCell.self)
            cell.configure(avatarUrl: avatarUrl, title: title, nameOwner: nameOwner)
            return cell
        }
    }
}

// MARK: - TableView Delegate
extension ListGistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let gist = viewModel.gists[indexPath.row]
        
        AppRouter.detailVC(gist: gist)
            .push(from: self.navigationController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = viewModel.rows[indexPath.row]
        
        switch row {
            case .gist(_ , let title, _):
            return title == "" ? 82 : UITableView.automaticDimension
        }
    }
}

private extension ListGistsViewController {
    func setupViews() {
        title = "List gists"
        
        tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellTypes: [GistCell.self])
        view.addSubview(tableView)
        
        refControl = UIRefreshControl()
        refControl.tintColor = UIColor.black
        refControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refControl)
        
        
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])
    }
    
    @objc
    func handleRefresh(refreshControl: UIRefreshControl) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            DispatchQueue.main.async {
                self.viewModel.getGistsFirstPage()
                refreshControl.endRefreshing()
            }
        }
    }
}

