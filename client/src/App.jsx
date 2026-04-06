import React from 'react';
import { Routes, Route, Link } from 'react-router-dom';
import ScanPage from './pages/ScanPage';
import CollectionPage from './pages/CollectionPage';

export default function App() {
  return (
    <div style={{ fontFamily: 'sans-serif', maxWidth: 900, margin: '0 auto', padding: '1rem' }}>
      <header style={{ display: 'flex', alignItems: 'center', gap: '1rem', marginBottom: '1.5rem' }}>
        <h1 style={{ margin: 0 }}>🃏 Pokémon TCG Scanner</h1>
        <nav style={{ display: 'flex', gap: '1rem' }}>
          <Link to="/">Scan</Link>
          <Link to="/collection">My Collection</Link>
        </nav>
      </header>

      <Routes>
        <Route path="/" element={<ScanPage />} />
        <Route path="/collection" element={<CollectionPage />} />
      </Routes>
    </div>
  );
}
