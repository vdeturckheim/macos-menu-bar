import SwiftUI

struct ContentView: View {
    @State private var remaining: CountdownComponents? = Countdown.remaining()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                YCLogoView(size: 120)

                Text(Countdown.eventName)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text(Countdown.eventDateString)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if let remaining = remaining {
                    HStack(spacing: 16) {
                        CountdownUnit(value: remaining.days, label: "DAYS")
                        CountdownUnit(value: remaining.hours, label: "HRS")
                        CountdownUnit(value: remaining.minutes, label: "MIN")
                        CountdownUnit(value: remaining.seconds, label: "SEC")
                    }
                    .padding(.top, 8)
                } else {
                    Text("It's here!")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(YCBrand.orange)
                }

                Spacer()
                Spacer()
            }
            .padding()
        }
        .onReceive(timer) { _ in
            remaining = Countdown.remaining()
        }
    }
}

struct CountdownUnit: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 44, weight: .bold, design: .monospaced))
                .foregroundColor(YCBrand.orange)
                .frame(minWidth: 60)
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.gray)
        }
    }
}
