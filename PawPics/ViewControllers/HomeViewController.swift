//
//  HomeViewController.swift
//  PawPics
//
//  Created by Kapil Khedkar on 20/07/24.
//

import UIKit
import SnapKit
import SDWebImage
import Reachability

class HomeViewController: UIViewController {
    
    private let headerView = UIView()
    private let headerLabel = UILabel()
    
    private var activityIndicator: UIActivityIndicatorView!
    
    private var reachability: Reachability!
    
    private let noInternetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let noInternetLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .appSecondary
        label.font = .headingLabel()
        return label
    }()

    private let viewModel = HomeViewModel()
    
    private let mainView = UIView()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.placeholder = "Enter a no. between 1 & 10"
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 4.0
        return stack
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Previous", for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupActions()
        setupReachability()
    }
    
    func setupReachability() {
        reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            // Reachable via WiFi
            triggerNoInternetUI(noInternet: false)
        case .cellular:
            // Reachable via Cellular
            triggerNoInternetUI(noInternet: false)
        case .unavailable:
            // Network not reachable
            triggerNoInternetUI(noInternet: true)
        }
    }
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    func triggerNoInternetUI(noInternet: Bool) {
        if noInternet {
            noInternetImageView.isHidden = false
            noInternetLabel.isHidden = false
            mainView.isHidden = true
        } else {
            noInternetImageView.isHidden = true
            noInternetLabel.isHidden = true
            mainView.isHidden = false
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        let iconImage = UIImage(named: "no_internet")
        noInternetImageView.image = iconImage
        noInternetLabel.text = "No Internet"
        view.addSubview(noInternetImageView)
        view.addSubview(noInternetLabel)
        
        headerView.backgroundColor = .appPrimary
        view.addSubview(headerView)
        
        headerLabel.text = "Paw Pics"
        headerLabel.font = UIFont.headingLabel()
        headerLabel.textColor = .appSecondary
        headerLabel.textAlignment = .center
        headerView.addSubview(headerLabel)
        
        view.addSubview(mainView)
        mainView.addSubview(textField)
        mainView.addSubview(submitButton)
        mainView.addSubview(imageView)
        
        mainView.addSubview(bottomStack)
        bottomStack.addArrangedSubview(previousButton)
        bottomStack.addArrangedSubview(nextButton)
        
        submitButton.themifyButton(title: "Submit")
        previousButton.themifyButton(title: "Previous")
        nextButton.themifyButton(title: "Next")
        
        textField.themifyTextField()
        
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            // Fallback on earlier versions
            activityIndicator = UIActivityIndicatorView(style: .gray)
        }
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        noInternetImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        noInternetLabel.snp.makeConstraints { make in
            make.top.equalTo(noInternetImageView.snp.bottom).offset(16)
            make.centerX.equalTo(noInternetImageView)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(submitButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        bottomStack.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupActions() {
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
    }
    
    @objc private func handleSubmit() {
        guard let numberText = textField.text, let number = Int(numberText), number > 0, number <= 10 else {
            return
        }
        
        viewModel.fetchImages(number: number) {
            DispatchQueue.main.async {
                let gridVC = GridViewController(images: self.viewModel.images)
                gridVC.modalPresentationStyle = .fullScreen
                self.present(gridVC, animated: true)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}