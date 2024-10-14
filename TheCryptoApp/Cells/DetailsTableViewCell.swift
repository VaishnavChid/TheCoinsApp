
import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    // MARK: - Cell ReuseId
    
    static var reuseId: String {
        String(describing: self)
    }
    
    // MARK: - UI Properties
    
    private let newImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - INITIALIZER
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(coinImageView)
        contentView.addSubview(newImageView)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            coinImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            coinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coinImageView.heightAnchor.constraint(equalToConstant: 40),
            coinImageView.widthAnchor.constraint(equalToConstant: 40),
            
            newImageView.topAnchor.constraint(equalTo: coinImageView.topAnchor, constant: 0),
            newImageView.trailingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: -2),
            newImageView.heightAnchor.constraint(equalToConstant: 25),
            newImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    // MARK: - Configure Cell
    
    func configure(with details: DataResponseModel) {
        titleLabel.text = details.name
        subtitleLabel.text = details.symbol
        newImageView.isHidden = !details.isNew
        newImageView.image = UIImage(named: AppConstants.imageNewBadge.rawValue)
        setImage(details)
    }
    
    private func setImage(_ details: DataResponseModel) {
        if details.isActive {
            contentView.alpha = 1
            switch details.type {
            case .coin:
                coinImageView.image = UIImage(named: AppConstants.imageCryptoCoinActive.rawValue)
            case .token:
                coinImageView.image = UIImage(named: AppConstants.imageToken.rawValue)
            case _:
                break
            }
        } else {
            contentView.alpha = 0.5
            coinImageView.image = UIImage(named: AppConstants.imageCryptoCoinInActive.rawValue)
        }
    }
    
}
