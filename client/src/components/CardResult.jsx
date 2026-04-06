import React from 'react';
import { addToCollection } from '../services/api';

export default function CardResult({ data }) {
  const { cardName, cardData } = data;

  async function handleSave() {
    try {
      await addToCollection({
        cardId: cardData?.id || cardName,
        cardName: cardData?.name || cardName,
        imageUrl: cardData?.images?.small || null,
      });
      alert(`${cardData?.name || cardName} added to your collection!`);
    } catch {
      alert('Failed to add card to collection. Please try again.');
    }
  }

  return (
    <div style={{ marginTop: '1.5rem', border: '1px solid #ccc', borderRadius: 8, padding: '1rem', maxWidth: 400 }}>
      <h3>Identified Card</h3>
      {cardData ? (
        <div style={{ display: 'flex', gap: '1rem' }}>
          {cardData.images?.small && (
            <img src={cardData.images.small} alt={cardData.name} style={{ height: 200, borderRadius: 6 }} />
          )}
          <div>
            <p><strong>Name:</strong> {cardData.name}</p>
            <p><strong>Set:</strong> {cardData.set?.name}</p>
            <p><strong>Rarity:</strong> {cardData.rarity || 'N/A'}</p>
            {cardData.cardmarket?.prices?.averageSellPrice && (
              <p><strong>Avg. Price:</strong> ${cardData.cardmarket.prices.averageSellPrice.toFixed(2)}</p>
            )}
            <button onClick={handleSave} style={{ marginTop: '0.5rem' }}>
              ➕ Add to Collection
            </button>
          </div>
        </div>
      ) : (
        <p>Card identified as <strong>{cardName}</strong>, but no API data found.</p>
      )}
    </div>
  );
}
