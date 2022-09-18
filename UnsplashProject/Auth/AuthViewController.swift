//
//  AuthViewController.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 29.06.2022.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class AuthViewController: UIViewController {
    private var didSetupConstraints = false
   
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "unsplash2")
        return image
    }()
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Unsplash Album!"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    private let loginButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.configuration?.cornerStyle = .dynamic
        button.layer.cornerRadius = 5
        return button
    }()
    private var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    var viewModel: AuthViewModelProtocol?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AuthViewModel()
        addViews()
        view.setNeedsUpdateConstraints()
        webView.navigationDelegate = self
        setupRx()
    }
    
    private func addViews() {
        view.addSubview(webView)
        view.addSubview(logoImage)
        view.addSubview(welcomeLabel)
        view.addSubview(loginButton)
        webView.isHidden = true
    }
    
    private func setupRx() {
    loginButton.rx.tap
        .bind {
            self.webView.isHidden = false
            self.welcomeLabel.isHidden = true
            self.loginButton.isHidden = true
            self.logoImage.isHidden = true
            self.viewModel?.webWiewLoad { request in
                self.webView.load(request)
            }
        }.disposed(by: disposeBag)
    
    }
}
// MARK: - setConstraints
extension AuthViewController {
    override func updateViewConstraints() {
        if !didSetupConstraints {
            webView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            logoImage.snp.makeConstraints { make in
                make.width.height.equalTo(200)
                make.centerX.equalTo(view)
                make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            }
            welcomeLabel.snp.makeConstraints { make in
                make.top.equalTo(logoImage.snp.bottom).offset(30)
                make.left.equalTo(view).offset(20)
                make.right.equalTo(view).offset(-20)
            }
            loginButton.snp.makeConstraints { make in
                make.top.equalTo(welcomeLabel.snp.bottom).offset(40)
                make.width.equalTo(200)
                make.height.equalTo(60)
                make.centerX.equalTo(view)
            }
           
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}
// MARK: - WKNavigationDelegate
extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard
            let currentURL = webView.url?.absoluteString,
            let code = viewModel?.getQueryStringParameter(url: currentURL, param: "code")
        else {return}
        
        viewModel?.fetchToken(code: code) { [weak self] data in
            let tabBarController = TabBarController()
            tabBarController.viewModel.token = data
            tabBarController.modalPresentationStyle = .fullScreen
            self?.present(tabBarController, animated: true)
        }
    }
}

