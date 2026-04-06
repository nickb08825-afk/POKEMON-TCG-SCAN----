# Pokémon TCG Scanner AI 🃏

A web application that uses AI to scan, identify, and retrieve information about Pokémon Trading Card Game (TCG) cards.

## Features

- 📷 **Card Scanning** – Capture or upload a photo of any Pokémon TCG card
- 🤖 **AI Recognition** – Automatically identify the card using image recognition
- 📊 **Card Details** – View full card details including name, set, rarity, and stats
- 💰 **Price Lookup** – Get current market prices via the Pokémon TCG API
- 🗂️ **Collection Tracking** – Save and manage your personal card collection
- 🔍 **Search & Filter** – Browse cards by name, set, type, or rarity

## Tech Stack

- **Frontend**: React + Vite
- **Backend**: Node.js + Express
- **AI/ML**: TensorFlow.js / OpenAI Vision API
- **Card Data**: [Pokémon TCG API](https://pokemontcg.io/)
- **Database**: SQLite (dev) / PostgreSQL (production)

## Getting Started

### Prerequisites

- Node.js 18+
- npm or yarn
- A Pokémon TCG API key (free at [pokemontcg.io](https://pokemontcg.io))

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/nickb08825-afk/POKEMON-TCG-SCAN----.git
   cd POKEMON-TCG-SCAN----
   ```

2. Install dependencies:
   ```bash
   # Install root / backend dependencies
   npm install

   # Install frontend dependencies
   cd client && npm install && cd ..
   ```

3. Configure environment variables:
   ```bash
   cp .env.example .env
   # Edit .env and add your API keys
   ```

4. Start the development server:
   ```bash
   npm run dev
   ```

5. Open [http://localhost:5173](http://localhost:5173) in your browser.

## Project Structure

```
POKEMON-TCG-SCAN----/
├── client/               # React frontend
│   ├── public/
│   └── src/
│       ├── components/   # UI components
│       ├── pages/        # Page views
│       ├── hooks/        # Custom React hooks
│       ├── services/     # API service calls
│       └── utils/        # Utility functions
├── server/               # Node.js + Express backend
│   ├── routes/           # API routes
│   ├── controllers/      # Route controllers
│   ├── services/         # Business logic & AI integration
│   └── models/           # Database models
├── .env.example          # Environment variable template
└── package.json
```

## Environment Variables

See [`.env.example`](.env.example) for the full list of required environment variables.

| Variable | Description |
|---|---|
| `POKEMON_TCG_API_KEY` | API key from pokemontcg.io |
| `PORT` | Backend server port (default: `3000`) |
| `DATABASE_URL` | PostgreSQL connection string (production) |
| `OPENAI_API_KEY` | OpenAI API key for Vision-based scanning (optional) |

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/scan` | Submit a card image for AI identification |
| `GET` | `/api/cards/:id` | Get details for a specific card |
| `GET` | `/api/collection` | List saved cards in a collection |
| `POST` | `/api/collection` | Add a card to the collection |
| `DELETE` | `/api/collection/:id` | Remove a card from the collection |

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

## License

MIT License – see [LICENSE](LICENSE) for details.

