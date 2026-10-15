/**
 * Apply query params to frame DOM + CSS variables.
 * Params: img, title, subtitle, primary, accent, textDark, bgLight, w, h
 */
(function applyFrameParams() {
  const params = new URLSearchParams(location.search);
  const img = params.get('img') || '';
  const title = params.get('title') || 'Your headline';
  const subtitle = params.get('subtitle') || 'Short supporting line';
  const primary = params.get('primary') || '#7C3AED';
  const accent = params.get('accent') || '#6366F1';
  const textDark = params.get('textDark') || '#0F172A';
  const bgLight = params.get('bgLight') || '#F8FAFC';
  const w = params.get('w') || '1080';
  const h = params.get('h') || '1920';

  const root = document.documentElement;
  root.style.setProperty('--primary', primary);
  root.style.setProperty('--accent', accent);
  root.style.setProperty('--text-dark', textDark);
  root.style.setProperty('--bg-light', bgLight);
  root.style.setProperty('--canvas-w', w + 'px');
  root.style.setProperty('--canvas-h', h + 'px');

  const meta = document.querySelector('meta[name="viewport"]');
  if (meta) meta.setAttribute('content', `width=${w}, height=${h}`);

  const imgEl = document.getElementById('shot');
  const titleEl = document.getElementById('title');
  const subtitleEl = document.getElementById('subtitle');

  if (imgEl && img) imgEl.src = img;
  if (titleEl) titleEl.textContent = title;
  if (subtitleEl) subtitleEl.textContent = subtitle;

  root.classList.add('params-ready');
})();
