import SwiftUI

struct TrafficMapCameras: View {
    @State private var cameras: [TrafficCameraItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var searchText = ""

    var filteredCameras: [TrafficCameraItem] {
        if searchText.isEmpty { return cameras }
        return cameras.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.roadName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading cameras...")
                } else if let errorMessage = errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("Failed to load cameras")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(filteredCameras) { camera in
                            NavigationLink(destination: CameraDetailView(camera: camera)) {
                                CameraRowView(camera: camera)
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search cameras...")
                }
            }
            .navigationTitle("Cameras")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("WSDOT-logo-white")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                }
            }
            .toolbarBackground(Color("WSDOTprimarygreen"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task { await fetchCameras() }
        }
    }

    private func fetchCameras() async {
        isLoading = true
        do {
            cameras = try await TrafficCameraService.shared.getCameras()
            isLoading = false
        } catch {
            errorMessage = "Please check your connection and try again."
            print("Camera API Error: \(error)")
            isLoading = false
        }
    }
}

struct CameraRowView: View {
    let camera: TrafficCameraItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: camera.isVideo ? "video.fill" : "camera.fill")
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(camera.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Text(camera.roadName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if !camera.directionDisplay.isEmpty {
                Text(camera.directionDisplay)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
}
