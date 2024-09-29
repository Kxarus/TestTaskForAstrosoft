//
//  FileViewController.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 28.09.2024.
//

import UIKit

final class FileViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var label: UILabel!
    
    private let viewModel: FileViewModel
    
    init(viewModel: FileViewModel) {
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

extension FileViewController: FileViewModelDelegate {
    func didUpdate(with file: String) {
        label.text = file
    }
}

private extension FileViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        label = UILabel()
        label.textColor = UIColor.label
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        scrollView.addSubview(label)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
        ])
    }
}

