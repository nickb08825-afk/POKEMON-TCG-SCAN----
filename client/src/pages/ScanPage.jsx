import React, { useState } from 'react';
import { scanCard } from '../services/api';
import CardResult from '../components/CardResult';

function isValidImageDataUrl(url) {
  return typeof url === 'string' && url.startsWith('data:image/');
}

export default function ScanPage() {
  const [selectedFile, setSelectedFile] = useState(null);
  const [preview, setPreview] = useState(null);
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  function handleFileChange(e) {
    const file = e.target.files[0];
    if (!file) return;
    setSelectedFile(file);
    setResult(null);
    setError(null);
    // Read as a data URL so we can validate the content type before rendering
    const reader = new FileReader();
    reader.onload = (evt) => {
      const dataUrl = evt.target.result;
      setPreview(isValidImageDataUrl(dataUrl) ? dataUrl : null);
    };
    reader.readAsDataURL(file);
  }

  async function handleScan() {
    if (!selectedFile) return;
    setLoading(true);
    setError(null);
    try {
      const data = await scanCard(selectedFile);
      setResult(data);
    } catch (err) {
      setError('Failed to scan card. Please try again.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div>
      <h2>Scan a Card</h2>
      <p>Take a photo of your Pokémon TCG card or upload an image to identify it.</p>

      <div style={{ marginBottom: '1rem' }}>
        <input type="file" accept="image/*" onChange={handleFileChange} />
      </div>

      {preview && (
        <div style={{ marginBottom: '1rem' }}>
          <img src={preview} alt="Card preview" style={{ maxHeight: 300, borderRadius: 8 }} />
        </div>
      )}

      <button onClick={handleScan} disabled={!selectedFile || loading}>
        {loading ? 'Scanning…' : 'Scan Card'}
      </button>

      {error && <p style={{ color: 'red' }}>{error}</p>}

      {result && <CardResult data={result} />}
    </div>
  );
}
