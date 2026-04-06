import React, { useEffect, useState } from 'react';
import { getCollection, removeFromCollection } from '../services/api';

/** Allow only https image URLs from the Pokémon TCG CDN and similar trusted sources. */
function isSafeImageUrl(url) {
  if (!url) return false;
  try {
    const parsed = new URL(url);
    return parsed.protocol === 'https:';
  } catch {
    return false;
  }
}

export default function CollectionPage() {
  const [collection, setCollection] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchCollection();
  }, []);

  async function fetchCollection() {
    try {
      const data = await getCollection();
      setCollection(data);
    } catch {
      setError('Failed to load collection.');
    } finally {
      setLoading(false);
    }
  }

  async function handleRemove(id) {
    try {
      await removeFromCollection(id);
      setCollection((prev) => prev.filter((c) => c.id !== id));
    } catch {
      setError('Failed to remove card. Please try again.');
    }
  }

  if (loading) return <p>Loading collection…</p>;
  if (error) return <p style={{ color: 'red' }}>{error}</p>;

  return (
    <div>
      <h2>My Collection</h2>
      {collection.length === 0 ? (
        <p>Your collection is empty. Scan some cards to get started!</p>
      ) : (
        <ul style={{ listStyle: 'none', padding: 0, display: 'flex', flexWrap: 'wrap', gap: '1rem' }}>
          {collection.map((entry) => (
            <li
              key={entry.id}
              style={{
                border: '1px solid #ccc',
                borderRadius: 8,
                padding: '0.75rem',
                width: 160,
                textAlign: 'center',
              }}
            >
              {isSafeImageUrl(entry.imageUrl) && (
                <img src={entry.imageUrl} alt={entry.cardName} style={{ width: '100%', borderRadius: 4 }} />
              )}
              <p style={{ margin: '0.5rem 0', fontWeight: 'bold' }}>{entry.cardName}</p>
              <button onClick={() => handleRemove(entry.id)} style={{ color: 'red', border: 'none', background: 'none', cursor: 'pointer' }}>
                Remove
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
