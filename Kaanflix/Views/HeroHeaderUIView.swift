//
//  HeroHeaderUIView.swift
//  Kaanflix
//
//  Created by Kaan Odabaş on 16.08.2023.
//



import UIKit

class HeroHeaderUIView: UIView {
    
    private var titles: [Title] = []
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Favs", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(FavButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(PlayButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()

    //Gradyan ekleyen fonksiyon.
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(titleLabel)
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
    //Ekranda gösterilecek olan ögelerin sınırlarını belirleyen fonksiyon.
    private func applyConstraints() {
        
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        let titleLabelConstraints = [
                titleLabel.leadingAnchor.constraint(equalTo:heroImageView.leadingAnchor, constant: 20), // heroImageView'ın solunda
                titleLabel.bottomAnchor.constraint(equalTo:heroImageView.bottomAnchor, constant: -10) // sol alt köşede
              ]
        
        //Bu sınırların aktif edildiği kısım.
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    
    //Bu işlev, başlık önizleme hücresinin görünümünü, belirli bir TitleViewModel verisiyle yapılandırır.
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = ""
    }
    
    @objc func FavButtonTapped() {
        print("Butona tıklandı!")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Favori içeriği veritabanına kaydetme işlemi
        let favoriteTitle = titleLabel.text ?? ""
        
        
        let model = Title(
            id: 0,  // Eğer id gerekmiyorsa uygun bir değeri verin
            media_type: "",
            original_name: "",
            original_title: favoriteTitle,
            poster_path: "",
            overview: "",
            vote_count: 0,
            release_date: "",
            vote_average: 0.0
        )
        
        //Veritabanına kaydeyme işlevi.
        DataPersistenceManager.shared.downloadTitleWith(model: model) { result in
            switch result {
            case .success:
                print("Favori içerik veritabanına kaydedildi.")
            case .failure(let error):
                print("Favori içerik kaydedilirken bir hata oluştu: \(error.localizedDescription)")
            }
        }
    }

    @objc func PlayButtonTapped() {
            // Bu fonksiyon, butona tıklandığında çağrılacak işlevi içerir
            print("Play Butona tıklandı!")
    }
    
}
