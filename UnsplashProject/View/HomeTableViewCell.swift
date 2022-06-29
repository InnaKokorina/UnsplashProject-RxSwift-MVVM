//
//  HomeTableViewCell.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {
    static var cellId = "HomeTableViewCell"
    var saveButtonTap: (() -> Void)?
    private let photoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        return image
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        return label
    }() 
    
    private lazy var stackView = UIStackView(arrangedSubviews: [photoImage, descriptionLabel], axis: .vertical, spacing: 8)
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray5
        button.alpha = 0.5
        button.tintColor = .black
        if #available(iOS 15.0, *) {
            button.configuration?.cornerStyle = .dynamic
            button.layer.cornerRadius = 5
        }
       // button.
        return button
    }()
    func setupViews() {
        contentView.addSubview(stackView)
        contentView.backgroundColor = .black
        stackView.addSubview(favoriteButton)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
        selectionStyle = .none
        favoriteButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(image: ImageRealm) {
        descriptionLabel.text = image.user
        favoriteButton.setImage(UIImage(systemName: image.isSaved ? "bookmark.fill": "bookmark"), for: .normal)
        let url = URL(string:image.imageUrl)
        photoImage.kf.setImage(with: url)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.image = nil
    }
    @objc func savePressed() {
        saveButtonTap?()
    }
}
// MARK: - constraints
extension HomeTableViewCell {
    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(8)
        }
        photoImage.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(stackView)
            make.width.height.equalTo(400)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(stackView)
        }
        favoriteButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.top.equalTo(stackView).offset(10)
            make.right.equalTo(stackView).offset(-10)
        }
    }
}
