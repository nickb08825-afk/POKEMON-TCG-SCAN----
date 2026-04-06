/**
 * AI Service – Card Identification
 *
 * This service handles the AI-powered image recognition for Pokémon TCG cards.
 * It is designed to be swappable: configure your preferred backend via the
 * AI_PROVIDER environment variable.
 *
 * Supported providers:
 *   - "openai"  – Uses OpenAI Vision (gpt-4o) to identify the card. Requires OPENAI_API_KEY.
 *   - "mock"    – Returns a placeholder name; useful for local development.
 *
 * Set AI_PROVIDER=openai in your .env file to enable real scanning.
 */

const axios = require('axios');

async function identifyCard(imageBuffer) {
  const provider = process.env.AI_PROVIDER || 'mock';

  if (provider === 'openai') {
    if (!process.env.OPENAI_API_KEY) {
      throw new Error('OPENAI_API_KEY is not set. Please add it to your .env file.');
    }
    return identifyWithOpenAI(imageBuffer);
  }

  if (provider !== 'mock') {
    console.warn(`Unsupported AI_PROVIDER "${provider}". Falling back to mock mode.`);
  }

  // Default: mock response for development
  return 'Pikachu';
}

async function identifyWithOpenAI(imageBuffer) {
  const base64Image = imageBuffer.toString('base64');

  const response = await axios.post(
    'https://api.openai.com/v1/chat/completions',
    {
      model: 'gpt-4o',
      messages: [
        {
          role: 'user',
          content: [
            {
              type: 'text',
              text: 'This is a Pokémon Trading Card Game card. What is the exact name of the Pokémon on this card? Reply with only the Pokémon name.',
            },
            {
              type: 'image_url',
              image_url: { url: `data:image/jpeg;base64,${base64Image}` },
            },
          ],
        },
      ],
      max_tokens: 50,
    },
    {
      headers: {
        Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
        'Content-Type': 'application/json',
      },
    }
  );

  const message = response.data.choices?.[0]?.message?.content?.trim();
  if (!message) {
    throw new Error('OpenAI Vision returned an empty or invalid response.');
  }
  return message;
}

module.exports = { identifyCard };
