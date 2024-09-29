//
//  AppRouter.swift
//  AstroSoft
//
//  Created by Roman Kiruxin on 26.09.2024.
//

import UIKit

enum AppRouter {
    case detailVC(gist: Gist)
    case fileVC(fileUrl: String)
}

extension AppRouter {
    func push(from navigationController: UINavigationController?, animated: Bool = true) {
        switch self {
        case .detailVC(let gist):
            let vc = DetailViewController(viewModel: DetailViewModel(gist: gist))
            navigationController?.pushViewController(vc, animated: animated)
        default:
            break
        }
    }
    
    func present(from viewController: UIViewController, animated: Bool = true) {
        switch self {
        case .fileVC(let fileUrl):
            let vc = FileViewController(viewModel: FileViewModel(fileUrl: fileUrl))
            viewController.present(vc, animated: animated)
        default:
            break
        }
    }
}
