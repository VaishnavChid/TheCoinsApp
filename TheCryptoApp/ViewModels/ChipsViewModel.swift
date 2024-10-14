
class ChipsViewModel {
    let filterOptions: [String]
    var selectedFilterData: [String] = []
    
    init(filterOptions: [String]) {
        self.filterOptions = filterOptions
    }
    
    func selectFilter(_ filter: String) {
        if !selectedFilterData.contains(filter) {
            selectedFilterData.append(filter)
        }
    }
    
    func deselectFilter(_ filter: String) {
        if let index = selectedFilterData.firstIndex(of: filter) {
            selectedFilterData.remove(at: index)
        }
    }
}

