import Foundation
import SwiftUI

struct SearchSynonymsView: View {
    
    @StateObject var viewModel = SearchSynonymsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if viewModel.synonymSetToBeShown != nil && viewModel.showResults {
                        VStack(alignment: .leading) {
                            Text("SEARCH_SYNONYMS.SYNONYM_RESULTS_TITLE".localized)
                                .bold()
                                .padding()
                            List(Array(viewModel.synonymSetToBeShown!), id: \.self) { word in
                                if word.caseInsensitiveCompare(viewModel.searchText) != .orderedSame {
                                    Text(word.capitalized)
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                    Spacer()
                    HStack {
                        
                        /*
                         Napomena: Prilikom klika na TextField ispod, postoji lag od nekoliko sekundi prije nego se pojavi tastatura. Svaki sljedeci klik na TextField radi bez ovog laga. Ovo ponasanje se desava samo u debug modeu i nesto je sto je poznat SwiftUI issue.
                         */
                        
                        TextField("SEARCH_SYNONYMS.SEARCH".localized, text: $viewModel.searchText)
                            .onChange(of: viewModel.searchText) {
                                if viewModel.showInitialAnimation {
                                    viewModel.showInitialAnimation = false
                                }
                                
                                if viewModel.showResults {
                                    viewModel.showResults = false
                                }
                            }
                            .autocorrectionDisabled()
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding()
                        
                        Button(action: {
                            viewModel.showInitialAnimation = false
                            viewModel.checkForSynonyms()
                        }) {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .padding(8)
                        }
                        .padding(.trailing)
                    }
                    .padding(.bottom, 10)
                }
                
                if viewModel.synonymSetToBeShown == nil && viewModel.showResults {
                    VStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .padding()
                        Text("SEARCH_SYNONYMS.NO_RESULTS_FOUND".localized)
                            .foregroundColor(.gray)
                            .font(.headline)
                        Spacer()
                    }
                }
                
                if viewModel.showInitialAnimation {
                    VStack {
                        Spacer()
                        TypingAnimationView(fullText: "SEARCH_SYNONYMS.TYPE_IN_TO_GET_STARTED".localized)
                        Spacer()
                    }
                }
            }
            .navigationTitle("SEARCH_SYNONYMS.TITLE".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.addSynonymViewPresented = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .padding(8)
                            .clipShape(Circle())
                    }
                    .padding(.leading, 8)
                }
            }
            .fullScreenCover(isPresented: $viewModel.addSynonymViewPresented) {
                AddSynonymView()
            }
        }
    }
}
