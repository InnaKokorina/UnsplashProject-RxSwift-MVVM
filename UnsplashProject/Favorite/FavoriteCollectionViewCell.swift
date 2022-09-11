//
//  FavoriteCollectionViewCell.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import UIKit
import Kingfisher

class FavoriteCollectionViewCell: UICollectionViewCell {
    static var cellId = "FavoriteCollectionViewCell"
    var deleteButtonTap: (() -> Void)?
    private let favoriteImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        return image
    }()
    private let discriptionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    let favoriteDeleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray5
        button.alpha = 0.5
        button.tintColor = .black
        if #available(iOS 15.0, *) {
            button.configuration?.cornerStyle = .dynamic
            button.layer.cornerRadius = 5
        }
        
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(favoriteImage)
        favoriteImage.addSubview(discriptionLabel)
        contentView.addSubview(favoriteDeleteButton)
        setConstraints()
        favoriteDeleteButton.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(image: ImageRealm) {
        favoriteDeleteButton.setImage(UIImage(systemName: image.isSaved ? "bookmark.fill": "bookmark"), for: .normal)
        let url = URL(string:image.imageUrl)
        favoriteImage.kf.setImage(with: url)
        discriptionLabel.text = image.user
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteImage.image = nil
    }
    @objc func deletePressed() {
        deleteButtonTap?()
    }
}
// MARK: - setConstraints
extension FavoriteCollectionViewCell {
    private func setConstraints() {
        favoriteImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        discriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(favoriteImage).offset(-10)
            make.left.equalTo(favoriteImage).offset(10)
            make.height.equalTo(20)
        }
        favoriteDeleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalTo(favoriteImage).offset(10)
            make.right.equalTo(favoriteImage).offset(-10)
        }
    }
}


