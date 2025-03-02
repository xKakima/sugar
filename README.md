# Sugar - Couples' Finance App 💑💰

Sugar is a modern Flutter application designed to help couples manage their finances together. The app provides a seamless experience for tracking shared expenses, managing budgets, and maintaining financial transparency in relationships.

## Features

- 🔐 Secure Google Sign-in 
- 💳 Shared expense tracking
- 📊 Financial analytics and reporting
- 🔔 Real-time notifications using Firebase
- 💾 Data persistence with Supabase

## Getting Started

### Prerequisites

- Flutter SDK >=3.5.0
- Dart SDK >=3.5.0
- A Supabase account and project
- Firebase project setup
- Google Cloud project (for Google Sign-in)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/xKakima/sugar.git
   cd sugar
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the assets directory with your configuration:
   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── constants/     # App-wide constants
├── controller/    # State management controllers
├── database/      # Database related code
├── models/        # Data models
├── pages/         # App screens
├── utils/         # Utility functions
└── widgets/       # Reusable widgets
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Project Link: [https://github.com/xKakima/sugar](https://github.com/xKakima/sugar)
