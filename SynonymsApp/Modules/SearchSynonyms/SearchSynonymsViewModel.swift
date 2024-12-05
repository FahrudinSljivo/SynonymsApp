import Foundation
import Combine

final class SearchSynonymsViewModel: ObservableObject {
    
    @Published var synonymSets: [Set<String>] = []
    @Published var searchText = ""
    @Published var synonymSetToBeShown: Set<String>?
    @Published var showInitialAnimation = true
    @Published var showResults = false
    @Published var addSynonymViewPresented = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    /*
     Inicijalizacija skupa sinonima iz SynonymsData singletona koji nam sluzi kao izvor podataka kao i postavljanje listenera kako bismo automatski azurirali skup sinonima synonymSets koji prikazujemo u View-u na osnovu promjena u izvoru podataka.
     */
    
    init() {
        synonymSets = SynonymsData.fetchSets()
        SynonymsData.synonymSetsDataPublisher
            .sink { [weak self] updatedSets in
                self?.synonymSets = updatedSets
            }
            .store(in: &cancellables)
    }
    
    /*
      Funkcijom checkForSynonyms pretrazujemo sinonime za rijec koju je korisnik unio.
      Vazno je napomenuti da se rijeci koje imaju isto znacenje, tj. koje su sinonimi, nalaze u istom skupu rijeci. Na taj nacin cemo postici i komutativnost/bidirektivnost (ako je A sinonim od B, tada je B sinonim od A) kao i tranzitivnost (ako je A sinonim od B, a C sinonim od B, tada ce i C biti sinonim od A).
      Koristeni su skupovi za smjestanje grupa sinonima, a ne nizovi, iz razloga sto nema smisla da cuvamo duplikate rijeci, ali i zato sto je pretraga u skupu konstantnog vremena (O(1)), za razliku od niza gdje je linearno vrijeme (O(n)).
      */
    
    func checkForSynonyms() {
        showResults = true
        if let synonymSetToBeShown = synonymSets.first(where: { $0.contains(where: { $0.caseInsensitiveCompare(searchText) == .orderedSame })}) {
            self.synonymSetToBeShown = synonymSetToBeShown
        } else {
            synonymSetToBeShown = nil
        }
    }
}
