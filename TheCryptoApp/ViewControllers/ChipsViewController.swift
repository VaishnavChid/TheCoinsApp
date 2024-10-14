
import UIKit

protocol ChipsViewControllerDelegate: AnyObject {
    func didUpdateSelectedFilters(_ selectedFilter: String, isSelected: Bool)
}

class ChipsViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    let filterOptions = ["Active Coins", "Inactive Coins", "Only Tokens", "Only Coins", "New Coins"]
    
    var selectedFilterData: [String]?
    weak var delegate: ChipsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
    }
    
    private func setupView() {
        view.layer.cornerRadius = 12
        view.backgroundColor = .systemGray4
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChipCell.self, forCellWithReuseIdentifier: "ChipCell")
        collectionView.allowsMultipleSelection = true
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
    
extension ChipsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChipCell", for: indexPath) as! ChipCell
        cell.configure(with: filterOptions[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ChipCell {
            cell.contentView.backgroundColor = UIColor.systemGray
            let selectedOption = filterOptions[indexPath.row]
            if !(selectedFilterData?.contains(selectedOption) ?? false) {
                selectedFilterData?.append(selectedOption)
            }
            delegate?.didUpdateSelectedFilters(selectedOption, isSelected: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ChipCell {
            cell.contentView.backgroundColor = UIColor.lightGray
            let deselectedOption = filterOptions[indexPath.row]
            if let index = selectedFilterData?.firstIndex(of: deselectedOption) {
                selectedFilterData?.remove(at: index)
            }
            delegate?.didUpdateSelectedFilters(deselectedOption, isSelected: false)
        }
    }
    
    // MARK: - Flow Layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = filterOptions[indexPath.row]
        let width = title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width + 18
        return CGSize(width: width, height: 30)
    }
}
