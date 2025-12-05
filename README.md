# 🍵 Tea Timer

A beautiful, calm, and aesthetic Flutter productivity application for timing tea steeping to perfection.

![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features

- 🎨 **Calm Aesthetic Design** - Soft color palette with sage green, warm beige, and lavender tones
- 🌓 **Dark Mode Support** - Automatic system-based theme switching for day and night
- ⏱️ **Dual Timer Options** - 3 minutes for Green Tea, 5 minutes for Black Tea
- ▶️ **Auto-Start** - Timer begins immediately upon duration selection
- 🔄 **Smooth Animations** - Circular timer visualization with gradient progress arc
- 📱 **Mobile-First Layout** - Optimized for one-handed use with centered visuals and bottom controls
- ⚡ **Haptic Feedback** - Gentle vibrations when timer completes
- 🎯 **Intuitive Controls** - Combined pause/resume toggle and clear reset functionality
- ✅ **Material 3 Design** - Modern UI with premium Google Fonts typography

## 📸 Screenshots

_Beautiful, minimalist interface showcasing the timer in action_

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.7 or higher)
- Supported platform:
  - macOS 10.14+
  - iOS 12+
  - Android 5.0+ (API 21+)
  - Windows 10+
  - Linux
  - Web (Chrome, Safari, Firefox, Edge)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd tea-timer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # macOS
   flutter run -d macos
   
   # iOS Simulator
   flutter run -d "iPhone Simulator"
   
   # Chrome
   flutter run -d chrome
   
   # Android
   flutter run -d android
   ```

## 🎯 Usage

1. **Select Duration**: Tap on either "3 Minutes" (Green Tea) or "5 Minutes" (Black Tea) - Timer starts automatically!
2. **Pause/Resume**: Use the toggle button to pause timer if needed, or resume countdown
3. **Reset**: Press the reset button to return to the selection screen
4. **Completion**: Receive haptic feedback and a celebration dialog when finished

## 🏗️ Architecture

The app follows clean architecture principles with clear separation of concerns:

```
lib/
├── config/          # App configuration
│   ├── constants.dart   # Timer durations and settings
│   └── theme.dart       # Color palette and theming
├── controllers/     # State management
│   └── timer_controller.dart  # Riverpod timer logic
├── services/        # App services
│   └── sound_service.dart     # Haptic feedback
├── widgets/         # Custom widgets
│   ├── circular_timer_painter.dart  # Custom painter
│   └── duration_selector.dart       # Duration cards
├── screens/         # App screens
│   └── timer_screen.dart      # Main timer UI
└── main.dart        # Entry point
```

### Key Technologies

- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) 2.4.9
- **Typography**: [google_fonts](https://pub.dev/packages/google_fonts) 6.1.0
- **Audio**: [audioplayers](https://pub.dev/packages/audioplayers) 5.2.1
- **UI Framework**: Material 3 with custom theming

## 🧪 Testing

Run all tests:

```bash
flutter test
```

Run code analysis:

```bash
flutter analyze
```

## 🎨 Design System

### Color Palette

- **Primary**: Soft Sage Green `#8B9D83`
- **Secondary**: Warm Beige `#E8DCC4`
- **Accent**: Soft Lavender `#C5B3D5`
- **Light Background**: Off-White `#FAF8F5`
- **Dark Background**: Charcoal `#1A1A1A`
- **Text**: Charcoal `#2C2C2C` (Light) / Off-White `#E0E0E0` (Dark)

### Typography

- **Display/Headings**: Raleway (light, elegant)
- **Body/Labels**: Inter (readable, modern)

## 📝 Comments & Documentation

All code is thoroughly commented to explain:
- Component purposes and responsibilities
- State management flow
- Custom painting logic
- Animation implementations
- User interaction handling

## � Development Metrics & AI Contribution

This project was accelerated using **Google Antigravity**, an advanced agentic coding assistant designed to pair-program with human developers.

### AI & Human Collaboration
- **Primary Agent**: Google Antigravity
- **Underlying Models**: Orchestrated workflow using **Claude 3.5 Sonnet (Thinking)**, **OpenAI GPT-OSS-120B**, and Google's experimental **M7/M8** models.
- **Human Role**: Prompt engineering, high-level design direction, visual verification, and iteration feedback.
- **Workflow**: The agent autonomously handled file creation, logic implementation, error debugging, and git management, while the user provided strategic oversight.

### Efficiency Analysis
Comparison of standard industry estimates (via `scc` COCOMO model) vs. actual development time:

| Metric | Industry Estimate (SCC) | Actual (Antigravity) | Efficiency Gain |
| :--- | :--- | :--- | :--- |
| **Development Time** | 5.01 months | ~4 hours | **> 99%** |
| **Estimated Cost** | $70,286 | N/A | **~$70k Saved** |
| **Codebase Size** | ~3,500 lines | Generated in 1 session | N/A |
| **Team Size** | 1.25 developers | 1 Human + 1 Agent | N/A |

*Note: Calculations based on the Constructive Cost Model (COCOMO) for organic software development.*

## �🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev)
- Fonts from [Google Fonts](https://fonts.google.com)
- Icons from [Material Design](https://material.io/icons)

## 📧 Contact

For questions or feedback, please open an issue on GitHub.

---

**Made with ❤️ and ☕ for tea lovers everywhere**
