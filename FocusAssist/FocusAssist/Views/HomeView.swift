import SwiftUI

struct HomeView: View {
    @State private var vm = SessionViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                Image(systemName: "hourglass")
                    .font(.system(size: 56))
                    .foregroundStyle(.tint)
                    .symbolEffect(.pulse)

                VStack(spacing: 4) {
                    Text("\(vm.minutes)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                    Text("minutes").foregroundStyle(.secondary)
                }

                Stepper("Session length",
                        value: $vm.minutes.animation(.snappy),
                        in: 5...120, step: 5)
                    .labelsHidden()

                Spacer()

                NavigationLink {
                    SessionView(vm: vm)
                } label: {
                    Label("Start session", systemImage: "play.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
            .padding(24)
            .navigationTitle("FocusAssist")
        }
    }
}
