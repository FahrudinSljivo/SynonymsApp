import SwiftUI
import Combine

final class AddSynonymViewModel: ObservableObject {
    
    @Published var synonymSets: [Set<String>] = []
    @Published var newWord = ""
    @Published var wordSynonyms = ""
    @Published var showAlert = false
    @Published var toastMessage = ""
    @Published var isToastShowing = false {
        didSet {
            if isToastShowing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.isToastShowing = false
                    }
                }
            }
        }
    }
    
    /*
     Inicijalizacija skupa sinonima iz SynonymsData singletona koji nam sluzi kao izvor podataka.
     */
    
    init() {
        synonymSets = SynonymsData.fetchSets()
    }
    
    /*
     Prilikom klika na 'Add' dugme, okida se funkcija addSynonyms(Bool) -> Bool. Funkcija ce vratiti true u slucaju da je izvrseno dodavanje novih sinonima u model, inace vraca false.
     Prvo se provjerava jednostavno validnost unosa (nedozvoljen je unos praznih stringova), a potom se formira niz dodatih rijeci. Dakle, i nova rijec i njeni sinonimi se tretiraju jednako tako sto se kreira niz od svih rijeci. Kao sto je spomenuto u komentaru iz SearchSynonymsViewModela, time cemo postici trazene karakteristike sinonima.
     Dalje se provjerava slucaj ako se barem dvije rijeci nalaze u odvojenim skupovima sinonima i prikazuje se odgovarajuca poruka ako je to slucaj. Ako nije, onda se provjerava da li neka rijec pripada nekom skupu te naposljetku ako nove rijeci ne pripadaju nijednom skupu, to onda kreiramo novi skup sinonima.
     Bitno je napomenuti da su homonimi (odnosno rijeci koje se isto pisu, a imaju razlicito znacenje) zanemareni, odnosno moze se pretpostaviti da takvih slucajeva nece biti. Pokrivanjem i tog slucaja bi se znacajno povecala nepotrebna kompleksnost rjesenja.
     */
    
    func addSynonyms(allowAddingToSpecificSet: Bool = false) -> Bool {
        
        guard !newWord.isBlank, !wordSynonyms.isBlank else {
            showToast(message: "ADD_SYNONYM.BLANK_INPUT_ERROR_MESSAGE".localized)
            return false
        }
        
        let synonyms = (CollectionOfOne(newWord) + wordSynonyms.components(separatedBy: ",").compactMap { $0 }).map({ $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() })
        
        if synonymsContainedInDifferentSets(synonyms: synonyms) {
            showToast(message: "ADD_SYNONYM.INVALID_INPUT_ERROR_MESSAGE".localized)
            return false
        } else if synonymsContainedInSomeSet(synonyms: synonyms, allowAddingToSpecificSet: allowAddingToSpecificSet) {
            if !allowAddingToSpecificSet {
                showAlert = true
                return false
            } else {
                return true
            }
        } else {
            SynonymsData.addSet(Set(synonyms))
            return true
        }
    }
    
    /*
     Funkcija koja provjerava da li su neke dvije novododane rijeci sadrzane u dva, vec postojeca, razlicita skupa sinonima. To je slucaj koji trebamo sprijeciti jer je logicki pogresan, tj. ako bi imalo smisla, to bi onda ta dva postojeca skupa vec bila spojena u jedan.
     */
    
    private func synonymsContainedInDifferentSets(synonyms: [String]) -> Bool {
        var foundFirstMatch = false
        for word in synonyms {
            for synonymSet in synonymSets {
                if synonymSet.contains(word) {
                    if foundFirstMatch {
                        return true
                    } else {
                        foundFirstMatch = true
                        break
                    }
                }
            }
        }
        return false
    }
    
    /*
     Funkcija koja provjerava da li je neka od novih rijeci vec sadrzana u nekom skupu. U slucaju da jeste, onda smjestamo citav taj novi niz rijeci u postojeci skup (pri tome se automatski izbacuju duplikati). Razlog za to je jednostavan - ako zelimo dodati novu rijec A kojoj je rijec B sinonim i ako ta rijec A vec postoji u nekom skupu sinonima kojoj je sinonim neka rijec C, tada ce i B i C biti sinonimi preko A pa ce svi skupa pripadati jednom skupu.
     Kada se proslijedi false kao allowAddingToSpecificSet parametar, tada se samo vrsi ta provjera bez tog sjedinjavanja i prikazuje se korisniku odgovarajuci prozorcic sa upitom o tome da li zeli da nastavi s tim sjedinjavanjem. U slucaju da potvrdi, tada ce se poslati true u tom parametru i izvrsice se sjedinjavanje pomenutih skupova.
     */
    
    private func synonymsContainedInSomeSet(synonyms: [String], allowAddingToSpecificSet: Bool) -> Bool {
        for i in 0..<synonymSets.count {
            for word in synonyms {
                if synonymSets[i].contains(word) {
                    if allowAddingToSpecificSet {
                        SynonymsData.appendToSet(withIndex: i, set: Set(synonyms))
                    }
                    return true
                }
            }
        }
        return false
    }
    
    /*
     Pomocna funkcija za prikazivanje Toast View-a.
     */
    
    private func showToast(message: String) {
        toastMessage = message
        withAnimation {
            isToastShowing = true
        }
    }
}
