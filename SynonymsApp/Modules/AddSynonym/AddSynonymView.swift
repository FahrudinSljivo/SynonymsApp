import SwiftUI

struct AddSynonymView: View {
    
    @StateObject private var viewModel = AddSynonymViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("ADD_SYNONYM.ENTER_NEW_WORD".localized.addColon)
                    .bold()
                    .padding([.horizontal, .top], 20)
                TextField("ADD_SYNONYM.ENTER_NEW_WORD".localized, text: $viewModel.newWord)
                    .autocorrectionDisabled()
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding()
                Text("ADD_SYNONYM.ENTER_SYNONYMS_SEPARATED".localized.addColon)
                    .bold()
                    .padding([.horizontal, .top], 20)
                TextField("ADD_SYNONYM.ENTER_SYNONYMS".localized, text: $viewModel.wordSynonyms)
                    .autocorrectionDisabled()
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding()
                Spacer()
            }
            .navigationTitle("ADD_SYNONYM.ADD_SYNONYM".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding(8)
                            .clipShape(Circle())
                    }
                    .padding(.leading, 8)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if viewModel.addSynonyms() {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.black)
                            .padding(8)
                            .clipShape(Circle())
                    }
                    .padding(.leading, 8)
                }
            }
        }
        .toast(isShowing: $viewModel.isToastShowing, message: viewModel.toastMessage)
        .alert("ADD_SYNONYM.ALERT_TITLE".localized, isPresented: $viewModel.showAlert) {
            Button("ADD_SYNONYM.ALERT_CANCEL".localized, role: .cancel) {}
            Button("ADD_SYNONYM.ALERT_CONFIRM".localized) {
                if viewModel.addSynonyms(allowAddingToSpecificSet: true) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text("ADD_SYNONYM.ALERT_TEXT".localized)
        }
    }
}
