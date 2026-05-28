import SwiftUI
import MapKit

struct CameraDetailView: View {
    let camera: TrafficCameraItem

    @State private var image: UIImage?
    @State private var isLoading = true
    @State private var loadError = false

    private let refreshInterval: TimeInterval = 300

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                cameraImageSection

                VStack(spacing: 12) {
                    infoRow(label: "Road", value: camera.roadName)
                    infoRow(label: "Direction", value: camera.directionDisplay)
                    if camera.milepost != 0 {
                        infoRow(label: "Milepost", value: String(format: "%.1f", camera.milepost))
                    }
                    infoRow(label: "Refresh Rate", value: "Approximately every 5 minutes.")

                    if camera.isVideo {
                        HStack {
                            Image(systemName: "video.fill")
                                .foregroundColor(.accentColor)
                            Text("Live video feed")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding()
                .wsdotCard()

                mapSection
            }
            .padding()
        }
        .navigationTitle(camera.title)
        .navigationBarTitleDisplayMode(.inline)
        .wsdotToolbar()
        .wsdotFavorite(category: .trafficCamera, itemId: String(camera.id), title: camera.title, subtitle: camera.roadName)
        .task { await loadImage() }
    }

    private var cameraImageSection: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .frame(height: 250)
            } else if loadError {
                VStack {
                    Image(systemName: "camera.slash.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("Camera offline")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .frame(maxWidth: .infinity)
        .wsdotCard()
    }

    private var mapSection: some View {
        Map(initialPosition: .region(MKCoordinateRegion(
            center: camera.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))) {
            Marker(camera.title, coordinate: camera.coordinate)
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .mapStyle(.standard)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
            Spacer()
        }
    }

    private func loadImage() async {
        let urlString = camera.url + "?" + String(Int(Date().timeIntervalSince1970 / 60))
        guard let url = URL(string: urlString) else {
            loadError = true
            isLoading = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                image = uiImage
            } else {
                loadError = true
            }
        } catch {
            loadError = true
        }
        isLoading = false
    }
}
