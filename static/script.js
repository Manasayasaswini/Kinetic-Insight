// ─────────────────────────────────────────────
//  Kinetic Insight — Optics Lab | script.js
// ─────────────────────────────────────────────

const cv  = document.getElementById('c');
const ctx = cv.getContext('2d');

const S = { n1: 1.0, n2: 1.5, mat: 'Glass', mx: 0, my: 0, mode: 'refract', moved: false };

const FACTS = {
  Water:   "A swimming pool looks shallower than it really is — that's refraction bending light as it travels from water to air!",
  Glass:   "Spectacle lenses use refraction to correct vision. The curved glass bends light rays so they focus on your retina perfectly.",
  Oil:     "You can make glass nearly invisible by putting it in oil with the same refractive index. Scientists use this trick in labs!",
  Diamond: "Diamond's n = 2.42 traps light inside through total internal reflection at just 24°, creating that brilliant sparkle in jewellery.",
  Custom:  "You're exploring a custom refractive index. Higher n = optically denser medium — light slows down and bends more toward the normal."
};

function explainText(t1deg, theta2, isTIR, n2) {
  if (isTIR) return `<span style="color:#f87171;font-weight:500">Total Internal Reflection!</span> At ${t1deg.toFixed(0)}°, the angle is too steep for light to pass through. It bounces back completely — this is how optical fibres carry internet signals!`;
  if (theta2 !== null) {
    const t2 = (theta2 * 180 / Math.PI).toFixed(0);
    const bends = n2 > 1.01 ? 'bends toward' : 'bends away from';
    return `Light enters at <span style="color:#f87171">${t1deg.toFixed(0)}°</span> and exits at <span style="color:#2dd4bf">${t2}°</span>. It slows down and <strong>${bends}</strong> the normal line. Higher n₂ = more bending.`;
  }
  return 'Aim the laser at the boundary line to begin.';
}

function resize() {
  const w = cv.parentElement;
  cv.width = w.clientWidth;
  cv.height = w.clientHeight;
}
window.addEventListener('resize', resize);
resize();

cv.addEventListener('mousemove', e => {
  const r = cv.getBoundingClientRect();
  S.mx = e.clientX - r.left;
  S.my = e.clientY - r.top;
  if (!S.moved) {
    S.moved = true;
    document.getElementById('hint').style.opacity = '0';
    document.getElementById('stepguide').style.opacity = '0';
  }
});

window.setMat = function(btn) {
  document.querySelectorAll('.mat-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  S.n2 = parseFloat(btn.dataset.n);
  S.mat = btn.dataset.name;
  document.getElementById('n2s').value = S.n2;
  document.getElementById('n2d').textContent = S.n2.toFixed(2);
  document.getElementById('factbox').textContent = FACTS[S.mat] || '';
};

window.onSlide = function(val) {
  S.n2 = parseFloat(val);
  S.mat = 'Custom';
  document.getElementById('n2d').textContent = S.n2.toFixed(2);
  document.querySelectorAll('.mat-btn').forEach(b => b.classList.remove('active'));
  document.getElementById('factbox').textContent = FACTS.Custom;
};

window.setMode = function(m) {
  S.mode = m;
  document.getElementById('mRefract').classList.toggle('active', m === 'refract');
  document.getElementById('mTIR').classList.toggle('active', m === 'tir');
};

function beam(x1, y1, x2, y2, color, w = 2.5) {
  ctx.save();
  ctx.shadowBlur = 16; ctx.shadowColor = color;
  ctx.strokeStyle = color; ctx.lineWidth = w; ctx.lineCap = 'round';
  ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2); ctx.stroke();
  ctx.restore();
}

function dot(x, y, color, r = 5) {
  ctx.save();
  ctx.shadowBlur = 18; ctx.shadowColor = color;
  ctx.fillStyle = color;
  ctx.beginPath(); ctx.arc(x, y, r, 0, Math.PI * 2); ctx.fill();
  ctx.restore();
}

function txt(str, x, y, color, size = 10, mono = true) {
  ctx.save();
  ctx.font = `${size}px ${mono ? "'Space Mono',monospace" : "'DM Sans',sans-serif"}`;
  ctx.fillStyle = color;
  ctx.fillText(str, x, y);
  ctx.restore();
}

function dashedArc(cx, cy, r, a1, a2, color) {
  ctx.save();
  ctx.strokeStyle = color; ctx.lineWidth = 1;
  ctx.setLineDash([3, 3]);
  ctx.beginPath(); ctx.arc(cx, cy, r, a1, a2); ctx.stroke();
  ctx.setLineDash([]);
  ctx.restore();
}

function loop() {
  requestAnimationFrame(loop);
  const W = cv.width, H = cv.height, bY = H / 2;

  ctx.fillStyle = '#070b12';
  ctx.fillRect(0, 0, W, H);

  // Medium fill + grid
  ctx.fillStyle = 'rgba(45,212,191,0.04)';
  ctx.fillRect(0, bY, W, H - bY);
  ctx.save();
  ctx.strokeStyle = 'rgba(45,212,191,0.04)'; ctx.lineWidth = 1;
  for (let y = bY + 28; y < H; y += 28) { ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(W, y); ctx.stroke(); }
  ctx.restore();

  // Boundary line
  ctx.save();
  ctx.strokeStyle = 'rgba(255,255,255,0.1)'; ctx.lineWidth = 1;
  ctx.beginPath(); ctx.moveTo(0, bY); ctx.lineTo(W, bY); ctx.stroke();
  ctx.restore();

  // Labels
  txt('AIR  (n₁ = 1.00)', 14, bY - 10, 'rgba(255,255,255,0.15)');
  txt(`${S.mat.toUpperCase()}  (n₂ = ${S.n2.toFixed(2)})`, 14, bY + 18, 'rgba(45,212,191,0.3)');

  const src = { x: 70, y: bY - 175 };
  const mx = S.moved ? Math.max(10, Math.min(W - 10, S.mx)) : src.x + 130;
  const my = S.moved ? S.my : bY - 60;

  // Hit point on boundary
  const pdx = mx - src.x, pdy = my - src.y;
  const t = Math.abs(pdy) > 0.01 ? (bY - src.y) / pdy : 0.5;
  const hx = src.x + t * pdx, hy = bY;

  // Normal line
  ctx.save();
  ctx.strokeStyle = 'rgba(255,255,255,0.15)'; ctx.lineWidth = 1; ctx.setLineDash([5, 4]);
  ctx.beginPath(); ctx.moveTo(hx, bY - 110); ctx.lineTo(hx, bY + 110); ctx.stroke();
  ctx.setLineDash([]);
  ctx.restore();
  txt('Normal', hx + 5, bY - 94, 'rgba(255,255,255,0.2)', 9);

  // Theta1
  const adx = hx - src.x;
  const theta1 = Math.atan2(Math.abs(adx), Math.abs(bY - src.y));
  const dir = adx >= 0 ? 1 : -1;

  // Incident ray + source
  beam(src.x, src.y, hx, hy, '#f87171', 2.5);
  dot(src.x, src.y, '#f87171', 5);
  txt('LASER SOURCE', src.x + 8, src.y - 10, 'rgba(248,113,113,0.45)', 9);

  // θ1 arc + label
  dashedArc(hx, hy, 36, -Math.PI / 2, -Math.PI / 2 - theta1 * dir, 'rgba(248,113,113,0.5)');
  const t1deg = (theta1 * 180 / Math.PI).toFixed(1);
  txt(`θ₁ = ${t1deg}°`, hx + (dir > 0 ? -68 : 14), bY - 22, 'rgba(248,113,113,0.75)', 10);

  const sinT2 = (S.n1 / S.n2) * Math.sin(theta1);
  const isTIR = Math.abs(sinT2) > 1 || S.mode === 'tir';

  document.getElementById('sv-t1').textContent = t1deg + '°';
  document.getElementById('tirbox').classList.toggle('hidden', !isTIR);
  document.getElementById('sv-t2').style.color = isTIR ? '#f87171' : '#2dd4bf';

  let theta2ForExplain = null;

  if (!isTIR) {
    const theta2 = Math.asin(sinT2);
    theta2ForExplain = theta2;
    const len = 1800;
    const ex = hx + len * Math.sin(theta2) * dir;
    const ey = bY + len * Math.cos(theta2);

    beam(hx, hy, ex, ey, '#2dd4bf', 2.5);
    dot(hx, hy, 'rgba(255,255,255,0.85)', 3);

    // θ2 arc + label
    dashedArc(hx, hy, 42, Math.PI / 2, Math.PI / 2 + theta2 * dir, 'rgba(45,212,191,0.5)');
    const t2deg = (theta2 * 180 / Math.PI).toFixed(1);
    txt(`θ₂ = ${t2deg}°`, hx + (dir > 0 ? 14 : -68), bY + 28, 'rgba(45,212,191,0.75)', 10);

    // Speed tag
    const spd = (1 / S.n2).toFixed(3);
    const tagX = hx + 90 * Math.sin(theta2) * dir;
    const tagY = bY + 90 * Math.cos(theta2);
    txt(`v = ${spd}c`, tagX + 8, tagY - 4, 'rgba(45,212,191,0.6)', 10);

    // Wavefront ripples
    ctx.save();
    ctx.strokeStyle = 'rgba(45,212,191,0.06)'; ctx.lineWidth = 1;
    for (let i = 1; i <= 4; i++) {
      const wx = hx + i * 50 * Math.sin(theta2) * dir;
      const wy = bY + i * 50 * Math.cos(theta2);
      ctx.beginPath(); ctx.arc(wx, wy, 14 + i * 5, 0, Math.PI * 2); ctx.stroke();
    }
    ctx.restore();

    document.getElementById('sv-t2').textContent = t2deg + '°';
    document.getElementById('sv-spd').textContent = spd + 'c';

  } else {
    // TIR
    const ex = hx + 1800 * Math.sin(theta1) * dir;
    const ey = bY - 1800 * Math.cos(theta1);
    beam(hx, hy, ex, ey, '#f97316', 2.5);
    dot(hx, hy, 'rgba(255,255,255,0.85)', 3);

    ctx.save();
    ctx.fillStyle = 'rgba(249,115,22,0.1)';
    ctx.beginPath(); ctx.arc(hx, hy, 24, 0, Math.PI * 2); ctx.fill();
    ctx.restore();

    txt('REFLECTED', hx + 14 * dir, bY - 28, 'rgba(249,115,22,0.6)', 9);
    document.getElementById('sv-t2').textContent = 'TIR';
    document.getElementById('sv-spd').textContent = '—';
  }

  document.getElementById('explainbox').innerHTML =
    explainText(parseFloat(t1deg), theta2ForExplain, isTIR, S.n2);
}

document.getElementById('factbox').textContent = FACTS['Glass'];
loop();
