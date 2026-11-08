import SwiftUI

struct SessionView: View {
    @Bindable var vm: SessionViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss

    private var progress: Double {
        let total = Double(vm.minutes * 60)
        return total > 0 ? Double(vm.remaining) / total : 0
    }

    var body: some View {
        VStack(spacing: 32) {
            Text("Just you, the wall, and your work.")
                .font(.headline)
                .foregroundStyle(.secondary)

            ZStack {
                Circle()
                    .stroke(.quaternary, lineWidth: 12)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(.tint, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: vm.remaining)
                Text(String(format: "%02d:%02d", vm.remaining / 60, vm.remaining % 60))
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText(countsDown: true))
                    .animation(.default, value: vm.remaining)
            }
            .frame(width: 260, height: 260)

            Group {
                if vm.isLoading {
                    ProgressView()
                } else if let q = vm.quote {
                    VStack(spacing: 8) {
                        Text("“\(q.text)”").italic().multilineTextAlignment(.center)
                        Text("— \(q.author)").font(.caption).foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else if let error = vm.errorMessage {
                    VStack(spacing: 8) {
                        Label(error, systemImage: "wifi.exclamationmark")
                            .foregroundStyle(.red)
                        Button("Retry") { Task { await vm.loadQuote() } }
                            .buttonStyle(.bordered)
                    }
                }
            }
            .animation(.easeOut(duration: 0.4), value: vm.quote?.q)
        }
        .padding(24)
        .onAppear { vm.start() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {      // left the app → reset
                vm.reset()
                dismiss()
            }
        }
    }
}
