//
//  GridViewController.swift
//  PawPics
//
//  Created by Kapil Khedkar on 20/07/24.
//

import UIKit
import SnapKit
import SDWebImage

class GridViewController: UIViewController {
    
    private var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel = GridViewModel()
    
    private let headerView = UIView()
    private let backButton = UIButton()
    
    var imageCount: Int = 0
    
    init(imageCount: Int) {
        self.imageCount = imageCount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        setupViews()
        setupConstraints()
        getImages()
    }
    
    func getImages() {
        activityIndicator.startAnimating()
        viewModel.fetchImages(count: imageCount, completion: {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
            }
        })
    }
    
    private func setupViews() {
        headerView.backgroundColor = .appPrimary
        view.addSubview(headerView)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.tintColor = .appSecondary
        headerView.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(collectionView)
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
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-8)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
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

extension GridViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfImages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .lightGray
        
        
        let imageView = UIImageView()
        imageView.contentMode = .redraw
        if let image = viewModel.getImage(at: indexPath.row) {
            imageView.sd_setImage(with: URL(string: image))
        }
        cell.contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
