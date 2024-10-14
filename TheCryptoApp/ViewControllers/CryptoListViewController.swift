
import UIKit

class CryptoListViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let listTableView = UITableView()
    private let chipsViewController = ChipsViewController()
    let spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    
    var dataModel: [DataResponseModel]?
    var originalDataModel: [DataResponseModel]?
    var activeFilters: [CryptoFilter] = []
    
    // MARK: - VC Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setupView()
        setSearchBarController()
        setupTableView()
        makeAPICall()
    }
    
    // MARK: - Setup UI Methods
    
    private func setupView() {
        view.backgroundColor = AppColors.themePurple
        title = AppConstants.navigationTitleCoin.rawValue
    }
    
    private func setupTableView() {
        view.addSubview(listTableView)
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: DetailsTableViewCell.reuseId)
        listTableView.rowHeight = UITableView.automaticDimension
        listTableView.layer.cornerRadius = 12
        listTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        setTableViewConstraints()
    }
    
    private func setTableViewConstraints() {
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        listTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        listTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        listTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setSearchBarController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.layer.cornerRadius = 12
        searchController.searchBar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        searchController.searchBar.backgroundColor = .white
        navigationItem.searchController = searchController
    }
    
    private func setNavigationBar() {
        var navBar = UINavigationBar()
        let width = self.view.frame.width
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        navBar.barTintColor = .white
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.sizeToFit()
        self.view.addSubview(navBar)
    }
    
    private func setupChipsViewController() {
        addChild(chipsViewController)
        view.addSubview(chipsViewController.view)
        chipsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        chipsViewController.delegate = self
    
        NSLayoutConstraint.activate([
            chipsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chipsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chipsViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chipsViewController.view.heightAnchor.constraint(equalToConstant: 100)
        ])
        chipsViewController.didMove(toParent: self)
    }
    
    private func showLoader() {
        spinner.startAnimating()
        listTableView.backgroundView = spinner
    }
    
    private func hideLoader() {
        spinner.stopAnimating()
        listTableView.backgroundView = nil
    }
    
    // MARK: - Network Call
    
    private func makeAPICall() {
        showLoader()
        NetworkService.getCryptoData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let successData):
                self.dataModel = successData
                self.originalDataModel = successData
                reloadTableViewMainThread()
            case .failure(let failure):
                print(failure.rawValue)
                hideLoader()
            }
        }
    }
    
    private func reloadTableViewMainThread() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            hideLoader()
            self.listTableView.reloadData()
            setupChipsViewController()
        }
    }

}

// MARK: - UITableViewDataSource extension

extension CryptoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataModel else { return 0 }
        return dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.reuseId, for: indexPath) as? DetailsTableViewCell else { return UITableViewCell() }
        guard let dataModel else { return UITableViewCell() }
        cell.configure(with: dataModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animator = TableViewAnimator(animation: TableAnimationFactory.makeFadeAnimation(duration: 0.1, delayFactor: 0.01))
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
}

// MARK: - UISearchBarDelegate delegate extension

extension CryptoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            activeFilters.removeAll()
            makeAPICall()
        } else {
            dataModel = dataModel?.filter({ $0.name?.localizedCaseInsensitiveContains(searchText) ?? false || $0.symbol?.localizedCaseInsensitiveContains(searchText) ?? false })
            listTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        makeAPICall()
    }
    
}

extension CryptoListViewController: ChipsViewControllerDelegate {
    
    // MARK: - ChipsViewControllerDelegate
    
    func didUpdateSelectedFilters(_ selectedFilter: String, isSelected: Bool) {
        
        dataModel = originalDataModel
        
        switch selectedFilter {
        case "Active Coins":
            if isSelected {
                activeFilters.append(.active)
            } else {
                activeFilters.removeAll { $0 == .active }
            }
        case "Inactive Coins":
            if isSelected {
                activeFilters.append(.inactive)
            } else {
                activeFilters.removeAll { $0 == .inactive }
            }
        case "Only Tokens":
            if isSelected {
                activeFilters.append(.token)
            } else {
                activeFilters.removeAll { $0 == .token }
            }
        case "Only Coins":
            if isSelected {
                activeFilters.append(.coin)
            } else {
                activeFilters.removeAll { $0 == .coin }
            }
        case "New Coins":
            if isSelected {
                activeFilters.append(.new)
            } else {
                activeFilters.removeAll { $0 == .new }
            }
        default:
            break
        }
        
        if !activeFilters.isEmpty {
            dataModel = CryptoFilterModel.applyFilters(originalDataModel: dataModel ?? [], filters: activeFilters)
        }
        listTableView.reloadData()
    }
    
}
