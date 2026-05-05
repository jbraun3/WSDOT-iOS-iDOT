//
//  LegendPopup.swift
//  WSDOT-iOS-iDOT
//
//  Created by Jules on 4/29/26.
//
import SwiftUI

struct LegendPopup: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(alignment: .leading, spacing: 32) {
                Text("Map Legend")
                    .font(.system(size: 24, weight: .bold))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Traffic Flow")
                        .font(.system(size: 16, weight: .semibold))
                    
                    HStack {
                        Text("Clear")
                            .font(.system(size: 14))
                        
                        Spacer()
                        
                        HStack(spacing: 0) {
                            Color(hex: 0x94DDA3)
                            Color(hex: 0xEAD57B)
                            Color(hex: 0xC46556)
                            Color(hex: 0x873C35)
                        }
                        .frame(width: 192, height: 16)
                        
                        Spacer()
                        
                        Text("Slow")
                            .font(.system(size: 14))
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Alert Severity")
                        .font(.system(size: 16, weight: .semibold))
                    
                    HStack {
                        severityItem(icon: "lowalertseverity", label: "Low")
                        Spacer()
                        severityItem(icon: "mediumalertseverity", label: "Medium")
                        Spacer()
                        severityItem(icon: "highalertseverity", label: "High")
                        Spacer()
                        severityItem(icon: "closurealertseverity", label: "Closure")
                    }
                }
                
                VStack(alignment: .leading, spacing: 17) {
                    Text("Alert Types")
                        .font(.system(size: 16, weight: .semibold))
                    
                    VStack(spacing: 24) {
                        HStack {
                            alertTypeItem(icon: "conealerttype", label: "Construction")
                            Spacer()
                            alertTypeItem(icon: "maintenancealerttype", label: "Maintenance")
                            Spacer()
                            alertTypeItem(sfSymbol: "car", label: "Incidents")
                        }
                        
                        HStack(spacing: 85) {
                            alertTypeItem(icon: "bridgealerttype", label: "Bridges")
                            alertTypeItem(sfSymbol: "ferry", label: "Ferries")
                        }
                        .padding(.leading, 15)
                    }
                }
                
                Spacer()
            }
            .padding(.leading, 25.8)
            .padding(.trailing, 24)
            .padding(.top, 29)
            .padding(.bottom, 24)
            .frame(width: 351, height: 500)
            .background(Color.black.opacity(0.8), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .foregroundColor(.white)
            .padding(32)
        }
    }
    
    private func severityItem(icon: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
            
            Text(label)
                .font(.system(size: 14))
        }
    }
    
    private func alertTypeItem(icon: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
            
            Text(label)
                .font(.system(size: 14))
        }
    }
    
    private func alertTypeItem(sfSymbol: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: sfSymbol)
                .font(.system(size: 30))
                .frame(width: 35, height: 35)
            
            Text(label)
                .font(.system(size: 14))
        }
    }
}

extension Color {
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: 1
        )
    }
}
