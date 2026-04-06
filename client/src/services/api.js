import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || '/api',
});

export async function scanCard(imageFile) {
  const formData = new FormData();
  formData.append('image', imageFile);
  const response = await api.post('/scan', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });
  return response.data;
}

export async function getCollection() {
  const response = await api.get('/collection');
  return response.data;
}

export async function addToCollection(cardInfo) {
  const response = await api.post('/collection', cardInfo);
  return response.data;
}

export async function removeFromCollection(id) {
  await api.delete(`/collection/${id}`);
}

export async function getCard(id) {
  const response = await api.get(`/cards/${id}`);
  return response.data;
}
