
import UIKit

protocol ChipsViewControllerDelegate: AnyObject {
    func didUpdateSelectedFilters(_ selectedFilter: String, isSelected: Bool)
}

class ChipsViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let viewModel: ChipsViewModel
    weak var delegate: ChipsViewControllerDelegate?
    
    
    // MARK: - Initializer
        init(viewModel: ChipsViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
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
        collectionView.register(ChipCollectionViewCell.self, forCellWithReuseIdentifier: ChipCollectionViewCell.reuseId)
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
        return viewModel.filterOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipCollectionViewCell.reuseId, for: indexPath) as? ChipCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: viewModel.filterOptions[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ChipCollectionViewCell {
            cell.contentView.backgroundColor = cell.selectedBackgroundColor
            let selectedOption = viewModel.filterOptions[indexPath.row]
            if !(viewModel.selectedFilterData.contains(selectedOption)) {
                viewModel.selectedFilterData.append(selectedOption)
            }
            delegate?.didUpdateSelectedFilters(selectedOption, isSelected: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ChipCollectionViewCell {
            cell.contentView.backgroundColor = cell.deselectedBackgroundColor
            let deselectedOption = viewModel.filterOptions[indexPath.row]
            if let index = viewModel.selectedFilterData.firstIndex(of: deselectedOption) {
                viewModel.selectedFilterData.remove(at: index)
            }
            delegate?.didUpdateSelectedFilters(deselectedOption, isSelected: false)
        }
    }
    
    // MARK: - Flow Layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = viewModel.filterOptions[indexPath.row]
        let width = title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width + 18
        return CGSize(width: width, height: 30)
    }
}
