import SwiftUI
import PhotosUI

struct MerchantPhotoView: View {
    @StateObject private var viewModel = MerchantPhotoViewModel()
    @EnvironmentObject private var navigator: AppNavigator
    @EnvironmentObject private var repository: MerchantRepository
    
    let merchant: MerchantModel
    
    @State private var showSourceSelector = false
    @State private var showCamera = false
    @State private var cameraData: Data? = nil
    
    var body: some View {
        BaseFormLayout(title: "Registrasi 2/3") {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Upload Gambar")
                            .font(.body)
                            .fontWeight(.heavy)
                            .foregroundColor(Color(red: 0.09, green: 0.36, blue: 0.62))
                        
                        Text(viewModel.errorMessage.isEmpty ? "Maksimal 5MB. Format: PNG, JPG, JPEG, HEIF." : viewModel.errorMessage)
                            .font(.caption)
                            .foregroundColor(viewModel.errorMessage.isEmpty ? .gray : .red)
                        
                        Button {
                            showSourceSelector = true
                        } label: {
                            if let imageData = viewModel.selectedImageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 150)
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                Image(systemName: "camera")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 150)
                                    .background(Color.clear)
                                    .cornerRadius(8)
                                    .contentShape(Rectangle())
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 5)
                    .opacity(repository.activeEditField == .none || repository.activeEditField == .foto ? 1.0 : 0.0)
                    .disabled(repository.activeEditField != .none && repository.activeEditField != .foto)
                }
                .listRowBackground(
                    Rectangle()
                        .fill(.regularMaterial)
                        .overlay(Rectangle().stroke(.white.opacity(0.6), lineWidth: 1))
                )
            }
            .scrollContentBackground(.hidden)
            
            // If exists, restore previously inputted image
            .onAppear {
                if let cached = repository.draftPhoto {
                    viewModel.processRawData(cached)
                }
            }
            // Save image to cache
            .onChange(of: viewModel.selectedImageData) { newData in
                repository.draftPhoto = newData
            }
        } bottomButton: {
            Button {
                if viewModel.canSubmit {
                    var nextMerchant = merchant
                    nextMerchant.foto = viewModel.selectedImageData
                    
                    if repository.activeEditField != .none {
                        navigator.path = [.result(merchant: nextMerchant)]
                    } else {
                        navigator.navigate(to: .details(merchant: nextMerchant))
                    }
                }
            } label: {
                Text("Lanjut")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color(red: 0.09, green: 0.36, blue: 0.62))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.bottom, 10)
            .disabled(!viewModel.canSubmit)
            .opacity(viewModel.canSubmit ? 1.0 : 0.5)
        }
        
        // BOTTOM SHEET
        .sheet(isPresented: $showSourceSelector) {
            VStack(spacing: 15) {
                // CAMERA OPTION
                Button {
                    showSourceSelector = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        showCamera = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "camera")
                        Text("Kamera")
                        Spacer()
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(Color(white: 0.95))
                    .cornerRadius(10)
                }
                
                // GALLERY OPTION
                PhotosPicker(
                    selection: $viewModel.selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Galeri")
                        Spacer()
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(Color(white: 0.95))
                    .cornerRadius(10)
                }
                .onChange(of: viewModel.selectedItem) { _ in
                    showSourceSelector = false
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 35)
            
            // Draggable
            .presentationDetents([.height(250), .medium])
            
            // Shows handle
            .presentationDragIndicator(.visible)
        }
        
        // FULLSCREEN NATIVE CAMERA
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker(selectedImageData: $cameraData)
                .ignoresSafeArea()
        }
        .onChange(of: cameraData) { newData in
            if let data = newData {
                viewModel.processRawData(data)
            }
        }
    }
}
