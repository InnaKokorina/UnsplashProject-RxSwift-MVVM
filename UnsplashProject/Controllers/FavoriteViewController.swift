//
//  FavoriteViewController.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import UIKit
import RealmSwift

protocol FavoriteViewControllerDelegate: AnyObject {
    func deteleFromFavorite()
}

class FavoriteViewController: UIViewController {
    private var collectionView: UICollectionView?
    private var didSetupConstraints = false
    private var favoriteImages: Results<ImageRealm>?
    private let realm = try! Realm()
    weak var delegate: FavoriteViewControllerDelegate?
    
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
        collectionView?.reloadData()
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let images = favoriteImages {
            return images.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCollectionViewCell.cellId, for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell() }
        if let images = favoriteImages {
            cell.configure(image: images[indexPath.row])
            cell.deleteButtonTap = {
               print("сработало")
                do {
                    try self.realm.write {
                        images[indexPath.row].isSaved.toggle()
                        collectionView.reloadItems(at: [indexPath])
                        self.delegate?.deteleFromFavorite()
                    }
                } catch {
                    print("Error saving Data context \(error)")
                }
                
            }
        }
            return cell
    }
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
// MARK: - HomeViewControllerDelegate
extension FavoriteViewController: HomeViewControllerDelegate {
    func saveFavoriteImages(favorite: Results<ImageRealm>?) {
        favoriteImages = favorite?.filter("isSaved=%@", true)
        loadPosts()
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
        let logOutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOutButtonPressed))
        logOutButton.tintColor = .white
        navigationItem.rightBarButtonItem  = logOutButton
        navigationItem.title = "Saved"
    }
    @objc func logOutButtonPressed(_ sender: Any) {
        do {
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
}

