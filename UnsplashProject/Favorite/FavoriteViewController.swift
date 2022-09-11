//
//  FavoriteViewController.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import UIKit
import RealmSwift


class FavoriteViewController: UIViewController {
    private var collectionView: UICollectionView?
    private var didSetupConstraints = false
    var viewModel: FavoriteViewModelProtocol?
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.setNeedsUpdateConstraints()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        setupNavItems()
        loadPosts()
    }
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCollectionViewCell.cellId)
        view.addSubview(collectionView!)
        collectionView?.backgroundColor = .black
    }
    func loadPosts() {
        viewModel?.reloadList = { [weak self] ()  in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.getFavoriteImagesCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.cellId, for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell() }
        if let images = viewModel?.favoriteImages {
            cell.configure(image: images[indexPath.row])
            cell.deleteButtonTap = {
                self.viewModel?.deleteFavorite(index: indexPath.row) {
                    collectionView.reloadItems(at: [indexPath])
                }
            }
        }
            return cell
    }
    // MARK: - collectionView set layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2)/2
        return CGSize(width: width, height: width)
    }
}

// MARK: - updateViewConstraints
extension FavoriteViewController {
    override func updateViewConstraints() {
        if !didSetupConstraints {
            collectionView?.snp.makeConstraints { make in
                make.edges.equalTo(view)
            }
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}
// MARK: - navigationItems
extension FavoriteViewController {
    func setupNavItems() {
        navigationItem.title = "Saved"
    }
}

