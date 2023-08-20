//
//  TitlePreviewViewController.swift
//  Kaanflix
//
//  Created by Kaan Odabaş on 16.08.2023.
//

import UIKit
import WebKit
import SDWebImage


protocol TitlePreviewViewControllerDelegate: AnyObject {
    func TitlePreviewViewControllerDidTapCell(_ cell: TitlePreviewViewController, viewModel: TitlePreviewViewModel)
}
class TitlePreviewViewController: UIViewController {
    
    var selectedIndexPath: IndexPath?
    static let identifier = "TitlePreviewViewController"
    
    private var titles: [Title] = [Title]()
    private var selectedTitle: String? // Correct data type
    
    private let titlesPosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds  = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let downloadButton: UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Add to Favorites", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(AddToFavButtonTapped), for: .touchUpInside)
        
        
        return button
    }()
    
    
    private let poster: UIImage = {
        let poster = UIImage()
        return poster
    }()
    
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)

        
        configureConstraints()
    }
    
    func configureConstraints() {
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 320)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        let titlesPosterUIImageViewConstraints = [
            titlesPosterUIImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titlesPosterUIImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            titlesPosterUIImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            titlesPosterUIImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        
    }
    
    //Poster verisini çekme fonksiyonu
    public func configure(with model: TitleViewModel) {

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        titlesPosterUIImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
    }
    
    
    
    
    public func configure(with model: TitlePreviewViewModel) {
        title = model.title
        selectedTitle = titleLabel.text
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        // Load the poster image using SDWebImage
        if let posterURL = URL(string: "https://image.tmdb.org/t/p/w500/\(model.poster)") {
            titlesPosterUIImageView.sd_setImage(with: posterURL, completed: nil)
        }

        let youtubeVideoId = model.youtubeView.id.videoId
        if !youtubeVideoId.isEmpty {
            if let url = URL(string: "https://www.youtube.com/embed/\(youtubeVideoId)") {
                webView.load(URLRequest(url: url))
            }
        }
    }

    @objc func AddToFavButtonTapped() {
        selectedTitle = titleLabel.text

        if let indexPath = selectedIndexPath {
            // indexPath.row ile ilgili işlemi gerçekleştirebilirsiniz
            print("Button tapped for cell at index: \(indexPath.row)")
    }
        print("Butona tıklandı!")

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        // Favori içeriği veritabanına kaydetme işlemi
        if let selectedTitle = selectedTitle {
            let model = Title(
                       id: 0,
                       media_type: "",
                       original_name: "",
                       original_title: selectedTitle,
                       poster_path: "",
                       overview: overviewLabel.text ?? "",
                       vote_count: 0,
                       release_date: "",
                       vote_average: 0.0
                   )

            
            DataPersistenceManager.shared.downloadTitleWith(model: model) { result in
                switch result {
                case .success:
                    print("Favori içerik veritabanına kaydedildi.")
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                    
                case .failure(let error):
                    print("Favori içerik kaydedilirken bir hata oluştu: \(error.localizedDescription)")
                }
            }
        } else {
            print("Seçili başlık bulunamadı.")
        }
    }
}

    
    
    
    

