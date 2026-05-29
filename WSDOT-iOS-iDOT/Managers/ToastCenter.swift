//
//  ToastCenter.swift
//  WSDOT-iOS-iDOT
//
//

import SwiftUI

// MARK: - Model

struct ToastMessage: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var icon: String = "checkmark.circle.fill"
}

// MARK: - Center

@Observable
final class ToastCenter {
    var message: ToastMessage?

    @ObservationIgnored
    private var dismissTask: Task<Void, Never>?

    func show(_ text: String, icon: String = "checkmark.circle.fill") {
        let newMessage = ToastMessage(text: text, icon: icon)
        dismissTask?.cancel()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            message = newMessage
        }
        dismissTask = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(2))
            guard !Task.isCancelled, let self else { return }
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                if self.message?.id == newMessage.id {
                    self.message = nil
                }
            }
        }
    }
}

// MARK: - Environment Implementation

extension EnvironmentValues {
    @Entry var toastCenter: ToastCenter = ToastCenter()
}

// MARK: - Toast view

struct ToastView: View {
    let message: ToastMessage

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: message.icon)
                .foregroundStyle(WSDOTStyle.primaryGreen)
                .font(.system(size: 18, weight: .semibold))
            Text(message.text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .wsdotCard()
        .padding(.horizontal, 40)
    }
}

// MARK: - Overlay modifier

struct ToastOverlayModifier: ViewModifier {
    @Environment(\.toastCenter) private var toastCenter

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let message = toastCenter.message {
                    ToastView(message: message)
                        .padding(.top, 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .allowsHitTesting(false)
                }
            }
    }
}

extension View {
    func toastOverlay() -> some View {
        modifier(ToastOverlayModifier())
    }
}
