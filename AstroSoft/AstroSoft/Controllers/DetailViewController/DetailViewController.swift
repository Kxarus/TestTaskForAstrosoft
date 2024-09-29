//
//  DetailViewController.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 26.09.2024.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - UI
    private var collectionView: UICollectionView!
    private var refControl: UIRefreshControl!
    
    private let viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: - DetailViewModel Delegate
extension DetailViewController: DetailViewModelDelegate {
    func dataSourceDidChange(rows: [DetailViewModel.ItemModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

//MARK: - CollectionView DataSource
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = viewModel.rows[indexPath.row]
        
        if indexPath.row == viewModel.rows.count - 1 {
            
            if viewModel.isLoadedNextPage(lastRow: row) {
                viewModel.fetchNextPageCommits()
            }
        }
        
        switch row {
        case .avatar(let avatarUrl):
            let cell = collectionView.dequeueReusableCell(withType: AvatarCollectionViewCell.self, for: indexPath)
            cell.configure(avatarUrl: avatarUrl)
            return cell
        case .empty(let height):
            let cell = collectionView.dequeueReusableCell(withType: EmptyCollectionViewCell.self, for: indexPath)
            cell.configure(height: height)
            return cell
        case .text(let text, let textSize, let textAligment):
            let cell = collectionView.dequeueReusableCell(withType: TextCollectionViewCell.self, for: indexPath)
            cell.configure(text: text, textSize: textSize, alignment: textAligment)
            return cell
        case .file(let file):
            let cell = collectionView.dequeueReusableCell(withType: FileCollectionViewCell.self, for: indexPath)
            cell.configure(with: file)
            cell.delegate = self
            return cell
        }
    }
}

extension DetailViewController: FileCollectionViewCellDelegate {
    func didTapFile(_ fileUrl: String) {
        AppRouter.fileVC(fileUrl: fileUrl)
            .present(from: self)
    }
}

private extension DetailViewController {
    func setupViews() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
        collectionView.setCollectionViewLayout(createListLayout(), animated: true)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(cellTypes: [AvatarCollectionViewCell.self,
                                            EmptyCollectionViewCell.self,
                                            TextCollectionViewCell.self,
                                            FileCollectionViewCell.self])
        view.addSubview(collectionView)
        
        refControl = UIRefreshControl()
        refControl.tintColor = UIColor.black
        refControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refControl)
        
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func createListLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.footerMode = .none
        config.backgroundColor = .clear
        config.headerMode = .supplementary
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    @objc
    func handleRefresh(refreshControl: UIRefreshControl) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            DispatchQueue.main.async {
                self.viewModel.fetchFirstPageCommits()
                refreshControl.endRefreshing()
            }
        }
    }
}
