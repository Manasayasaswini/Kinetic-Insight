const canvas = document.getElementById('experimentCanvas');
const ctx = canvas.getContext('2d');
const obsText = document.getElementById('observationText');
const factText = document.getElementById('factText');
const modeButtons = document.querySelectorAll('[data-mode-btn]');
const controlPanels = document.querySelectorAll('[data-control-panel]');

let currentObject = null;
const state = {
    mode: 'transparency',
    sunAngle: 45,
    lightColor: 'rgba(255, 248, 184, 0.75)',
    torchPos: { x: 100, y: 250 },
    objectPos: { x: 290, y: 250 },
    mouse: { x: 150, y: 220 }
};

const FACTS = {
    transparency: "Transparent objects let most light pass, translucent objects let only some light through, and opaque objects block it almost completely.",
    shadow: "A shadow always forms on the side opposite the light source. Lower Sun angle means a longer shadow.",
    pinhole: "A pinhole camera works because light travels in straight lines. Rays from the top and bottom of the object cross at the tiny hole."
};

function syncLayout() {
    controlPanels.forEach((panel) => {
        panel.classList.toggle('hidden', panel.dataset.controlPanel !== state.mode);
    });

    modeButtons.forEach((button) => {
        const isActive = button.dataset.modeBtn === state.mode;
        button.classList.toggle('active-tab', isActive);
        button.classList.toggle('border-blue-300', isActive && state.mode === 'transparency');
        button.classList.toggle('bg-blue-50', isActive && state.mode === 'transparency');
        button.classList.toggle('border-yellow-300', isActive && state.mode === 'shadow');
        button.classList.toggle('bg-yellow-50', isActive && state.mode === 'shadow');
        button.classList.toggle('border-indigo-300', isActive && state.mode === 'pinhole');
        button.classList.toggle('bg-indigo-50', isActive && state.mode === 'pinhole');
        button.classList.toggle('text-white', false);
        if (!isActive) {
            button.classList.remove('bg-blue-50', 'bg-yellow-50', 'bg-indigo-50', 'border-blue-300', 'border-yellow-300', 'border-indigo-300');
        }
    });

    if (factText) {
        factText.textContent = FACTS[state.mode];
    }
}

function clamp(value, min, max) {
    return Math.max(min, Math.min(max, value));
}

function roundedRect(x, y, w, h, r) {
    const radius = Math.min(r, w / 2, h / 2);
    ctx.beginPath();
    ctx.moveTo(x + radius, y);
    ctx.lineTo(x + w - radius, y);
    ctx.quadraticCurveTo(x + w, y, x + w, y + radius);
    ctx.lineTo(x + w, y + h - radius);
    ctx.quadraticCurveTo(x + w, y + h, x + w - radius, y + h);
    ctx.lineTo(x + radius, y + h);
    ctx.quadraticCurveTo(x, y + h, x, y + h - radius);
    ctx.lineTo(x, y + radius);
    ctx.quadraticCurveTo(x, y, x + radius, y);
    ctx.closePath();
}

function drawCandle(cx, baseY, scale, alpha = 1) {
    const bodyW = 20 * scale;
    const bodyH = 62 * scale;
    const flameH = 26 * scale;
    const bodyX = cx - bodyW / 2;
    const bodyY = baseY - bodyH;

    ctx.save();
    ctx.globalAlpha = alpha;

    const waxGradient = ctx.createLinearGradient(bodyX, bodyY, bodyX + bodyW, bodyY + bodyH);
    waxGradient.addColorStop(0, '#9BE7A6');
    waxGradient.addColorStop(0.5, '#78E08F');
    waxGradient.addColorStop(1, '#58B36A');
    ctx.fillStyle = waxGradient;
    roundedRect(bodyX, bodyY, bodyW, bodyH, 6 * scale);
    ctx.fill();

    ctx.strokeStyle = 'rgba(55, 84, 64, 0.4)';
    ctx.lineWidth = Math.max(1, 1.5 * scale);
    ctx.stroke();

    ctx.strokeStyle = 'rgba(255, 255, 255, 0.22)';
    ctx.lineWidth = Math.max(0.8, scale);
    for (let i = 1; i <= 3; i++) {
        const lineX = bodyX + (bodyW / 4) * i;
        ctx.beginPath();
        ctx.moveTo(lineX, bodyY + 6 * scale);
        ctx.lineTo(lineX - 2 * scale, bodyY + bodyH - 8 * scale);
        ctx.stroke();
    }

    ctx.strokeStyle = '#5B4636';
    ctx.lineWidth = Math.max(1, 1.2 * scale);
    ctx.beginPath();
    ctx.moveTo(cx, bodyY - 4 * scale);
    ctx.lineTo(cx, bodyY + 8 * scale);
    ctx.stroke();

    ctx.shadowBlur = 18 * scale;
    ctx.shadowColor = 'rgba(241, 196, 15, 0.5)';
    const outerGradient = ctx.createRadialGradient(cx, bodyY - 8 * scale, 2 * scale, cx, bodyY - 8 * scale, 18 * scale);
    outerGradient.addColorStop(0, '#FFF4B3');
    outerGradient.addColorStop(0.45, '#FAD390');
    outerGradient.addColorStop(1, '#F1C40F');
    ctx.fillStyle = outerGradient;
    ctx.beginPath();
    ctx.moveTo(cx, bodyY - flameH);
    ctx.quadraticCurveTo(cx + 12 * scale, bodyY - 12 * scale, cx, bodyY + 2 * scale);
    ctx.quadraticCurveTo(cx - 12 * scale, bodyY - 12 * scale, cx, bodyY - flameH);
    ctx.fill();

    ctx.shadowBlur = 0;
    ctx.fillStyle = '#FFF3D1';
    ctx.beginPath();
    ctx.moveTo(cx, bodyY - flameH * 0.62);
    ctx.quadraticCurveTo(cx + 5 * scale, bodyY - 8 * scale, cx, bodyY - 1 * scale);
    ctx.quadraticCurveTo(cx - 5 * scale, bodyY - 8 * scale, cx, bodyY - flameH * 0.62);
    ctx.fill();

    ctx.restore();
}

function drawGlowRay(fromX, fromY, midX, midY, toX, toY, color) {
    ctx.save();
    ctx.strokeStyle = color;
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';
    ctx.shadowBlur = 18;
    ctx.shadowColor = color;
    ctx.lineWidth = 4;
    ctx.globalAlpha = 0.22;
    ctx.beginPath();
    ctx.moveTo(fromX, fromY);
    ctx.lineTo(midX, midY);
    ctx.lineTo(toX, toY);
    ctx.stroke();

    ctx.lineWidth = 2;
    ctx.globalAlpha = 0.85;
    ctx.beginPath();
    ctx.moveTo(fromX, fromY);
    ctx.lineTo(midX, midY);
    ctx.lineTo(toX, toY);
    ctx.stroke();
    ctx.restore();
}

function projectYThroughPinhole(sourceY, pinholeY, ratio) {
    return pinholeY + (pinholeY - sourceY) * ratio;
}

function drawProjectedCandle(cx, projection, alpha = 0.76) {
    const bodyTop = projection.bodyTop;
    const bodyBottom = projection.bodyBottom;
    const bodyHeight = Math.max(10, Math.abs(bodyBottom - bodyTop));
    const bodyWidth = Math.max(6, bodyHeight * 0.32);
    const bodyX = cx - bodyWidth / 2;
    const bodyY = Math.min(bodyTop, bodyBottom);

    ctx.save();
    ctx.globalAlpha = alpha;

    const waxGradient = ctx.createLinearGradient(bodyX, bodyY, bodyX + bodyWidth, bodyY + bodyHeight);
    waxGradient.addColorStop(0, '#A6EDB1');
    waxGradient.addColorStop(0.5, '#78E08F');
    waxGradient.addColorStop(1, '#4D9D61');
    ctx.fillStyle = waxGradient;
    roundedRect(bodyX, bodyY, bodyWidth, bodyHeight, 4);
    ctx.fill();

    ctx.strokeStyle = 'rgba(229, 246, 233, 0.32)';
    ctx.lineWidth = 1;
    for (let i = 1; i <= 2; i++) {
        const lineX = bodyX + (bodyWidth / 3) * i;
        ctx.beginPath();
        ctx.moveTo(lineX, bodyY + 3);
        ctx.lineTo(lineX - 1, bodyY + bodyHeight - 4);
        ctx.stroke();
    }

    const wickTop = projection.wickTop;
    const wickBottom = projection.wickBottom;
    ctx.strokeStyle = 'rgba(84, 60, 41, 0.85)';
    ctx.lineWidth = 1.2;
    ctx.beginPath();
    ctx.moveTo(cx, wickTop);
    ctx.lineTo(cx, wickBottom);
    ctx.stroke();

    const flameTop = projection.flameTop;
    const flameBottom = projection.flameBottom;
    const flameHalfW = Math.max(4, Math.abs(flameBottom - flameTop) * 0.28);

    ctx.shadowBlur = 12;
    ctx.shadowColor = 'rgba(241, 196, 15, 0.45)';
    const flameGradient = ctx.createLinearGradient(cx, flameTop, cx, flameBottom);
    flameGradient.addColorStop(0, '#F1C40F');
    flameGradient.addColorStop(0.55, '#FAD390');
    flameGradient.addColorStop(1, '#FFF3D1');
    ctx.fillStyle = flameGradient;
    ctx.beginPath();
    ctx.moveTo(cx, flameTop);
    ctx.quadraticCurveTo(cx + flameHalfW, (flameTop + flameBottom) / 2, cx, flameBottom);
    ctx.quadraticCurveTo(cx - flameHalfW, (flameTop + flameBottom) / 2, cx, flameTop);
    ctx.fill();

    ctx.shadowBlur = 0;
    ctx.restore();
}

function resize() {
    canvas.width = canvas.parentElement.clientWidth;
    canvas.height = canvas.parentElement.clientHeight;
    state.torchPos = { x: Math.max(90, canvas.width * 0.14), y: canvas.height * 0.5 };
    state.objectPos = { x: Math.max(state.torchPos.x + 170, canvas.width * 0.42), y: canvas.height * 0.5 };
    state.mouse.x = Math.min(state.mouse.x, canvas.width - 40);
    state.mouse.y = Math.min(state.mouse.y, canvas.height - 80);
}
window.onresize = resize;
resize();

canvas.addEventListener('mousemove', (e) => {
    const rect = canvas.getBoundingClientRect();
    state.mouse.x = e.clientX - rect.left;
    state.mouse.y = e.clientY - rect.top;
});

const MATERIALS = {
    glass: { 
        name: 'Transparent', 
        opacity: 0.1, 
        passThrough: 0.9, 
        info: 'Light passes through completely [00:57]. Objects are clearly visible.' 
    },
    paper: { 
        name: 'Translucent', 
        opacity: 0.5, 
        passThrough: 0.3, 
        info: 'Light passes partially [01:37]. Objects look blurry and faint.' 
    },
    wood: { 
        name: 'Opaque', 
        opacity: 1.0, 
        passThrough: 0.0, 
        info: 'Light is blocked completely [01:17]. A dark shadow is formed behind it.' 
    }
};

function setObject(type) {
    currentObject = MATERIALS[type];
    state.mode = 'transparency';
    obsText.innerHTML = `<strong>${currentObject.name}:</strong> ${currentObject.info}`;
    syncLayout();
}

function updateSun(val) {
    state.mode = 'shadow';
    state.sunAngle = val;
    obsText.innerHTML = getShadowObservation(val);
    syncLayout();
}

function getShadowObservation(angle) {
    if (angle > 80 && angle < 100) return "<strong>Noon:</strong> The sun is overhead. The shadow is at its shortest! [01:58]";
    if (angle < 40 || angle > 140) return "<strong>Morning/Evening:</strong> The sun is low in the sky. shadows become very long.";
    return "As the sun moves in a straight line, notice how the shadow always stays on the opposite side.";
}

function setMode(m) {
    state.mode = m;
    if (m === 'pinhole') {
        obsText.innerHTML = "<strong>Inversion:</strong> Drag the candle up, down, closer, or farther. Straight-line rays cross at the pinhole, so the colorful image flips and changes size on the screen.";
    } else if (m === 'shadow') {
        obsText.innerHTML = getShadowObservation(state.sunAngle);
    } else if (m === 'transparency' && currentObject) {
        obsText.innerHTML = `<strong>${currentObject.name}:</strong> ${currentObject.info}`;
    } else if (m === 'transparency') {
        obsText.innerHTML = "Select an object to begin the experiment.";
    }
    syncLayout();
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    if (state.mode === 'transparency') {
        drawTransparencyExperiment();
    } else if (state.mode === 'shadow') {
        drawShadowExperiment();
    } else if (state.mode === 'pinhole') {
        drawPinholeCamera();
    }

    requestAnimationFrame(draw);
}

function drawTransparencyExperiment() {

    // 1. Draw Torch
    ctx.fillStyle = '#2D3436';
    ctx.fillRect(state.torchPos.x - 40, state.torchPos.y - 15, 60, 30);
    ctx.beginPath();
    ctx.arc(state.torchPos.x + 20, state.torchPos.y, 15, 0, Math.PI * 2);
    ctx.fill();

    // 2. Initial Light Beam (From Torch to Object)
    ctx.fillStyle = state.lightColor;
    ctx.beginPath();
    ctx.moveTo(state.torchPos.x + 20, state.torchPos.y);
    ctx.lineTo(state.objectPos.x, state.torchPos.y - 60);
    ctx.lineTo(state.objectPos.x, state.torchPos.y + 60);
    ctx.fill();

    if (currentObject) {
        // 3. Draw the Object
        ctx.fillStyle = `rgba(100, 100, 100, ${currentObject.opacity})`;
        ctx.strokeStyle = '#2D3436';
        ctx.lineWidth = 2;
        ctx.strokeRect(state.objectPos.x - 20, state.objectPos.y - 60, 40, 120);
        ctx.fillRect(state.objectPos.x - 20, state.objectPos.y - 60, 40, 120);

        // 4. Draw Passing Light
        if (currentObject.passThrough > 0) {
            ctx.fillStyle = `rgba(255, 255, 200, ${currentObject.passThrough * 0.5})`;
            ctx.beginPath();
            ctx.moveTo(state.objectPos.x + 20, state.torchPos.y - 60);
            ctx.lineTo(canvas.width, state.torchPos.y - 100);
            ctx.lineTo(canvas.width, state.torchPos.y + 100);
            ctx.lineTo(state.objectPos.x + 20, state.torchPos.y + 60);
            ctx.fill();
        }

        // 5. Draw Shadow
        if (currentObject.passThrough < 0.5) {
            const shadowIntensity = 1 - currentObject.passThrough;
            ctx.fillStyle = `rgba(0, 0, 0, ${shadowIntensity * 0.15})`;
            ctx.beginPath();
            ctx.moveTo(state.objectPos.x + 20, state.torchPos.y - 60);
            ctx.lineTo(canvas.width, state.torchPos.y - 80);
            ctx.lineTo(canvas.width, state.torchPos.y + 80);
            ctx.lineTo(state.objectPos.x + 20, state.torchPos.y + 60);
            ctx.fill();
        }
    }
}

function drawShadowExperiment() {
    const centerX = canvas.width / 2;
    const groundY = canvas.height - 120;
    const pillarHeight = 132;
    const pillarWidth = 34;
    const pillarX = centerX - pillarWidth / 2;

    const sky = ctx.createLinearGradient(0, 0, 0, groundY);
    sky.addColorStop(0, '#EEF7FF');
    sky.addColorStop(0.55, '#FFF8DA');
    sky.addColorStop(1, '#F5F0DB');
    ctx.fillStyle = sky;
    ctx.fillRect(0, 0, canvas.width, groundY);

    const fieldGlow = ctx.createRadialGradient(centerX, groundY - 10, 40, centerX, groundY + 10, canvas.width * 0.45);
    fieldGlow.addColorStop(0, 'rgba(255, 236, 166, 0.24)');
    fieldGlow.addColorStop(1, 'rgba(255, 236, 166, 0)');
    ctx.fillStyle = fieldGlow;
    ctx.fillRect(0, groundY - 100, canvas.width, 180);

    const groundGrad = ctx.createLinearGradient(0, groundY, 0, canvas.height);
    groundGrad.addColorStop(0, '#D8D2B8');
    groundGrad.addColorStop(0.55, '#B6C98C');
    groundGrad.addColorStop(1, '#89A663');
    ctx.fillStyle = groundGrad;
    ctx.fillRect(0, groundY, canvas.width, canvas.height - groundY);

    ctx.strokeStyle = 'rgba(118, 145, 82, 0.4)';
    ctx.lineWidth = 1;
    for (let x = 40; x < canvas.width; x += 28) {
        ctx.beginPath();
        ctx.moveTo(x, groundY + 8);
        ctx.lineTo(x - 8, groundY + 26);
        ctx.moveTo(x + 4, groundY + 12);
        ctx.lineTo(x + 10, groundY + 30);
        ctx.stroke();
    }

    const radius = Math.min(280, canvas.width * 0.28);
    const rad = (state.sunAngle * Math.PI) / 180;
    const sunX = centerX + radius * Math.cos(Math.PI - rad);
    const sunY = groundY - radius * Math.sin(Math.PI - rad);

    const shadowLen = pillarHeight / Math.tan(rad);
    const shadowOpacity = Math.max(0.06, 0.24 - Math.min(Math.abs(shadowLen) / 1200, 0.14));
    const shadowWidth = Math.max(18, Math.abs(shadowLen) * 0.42);
    const shadowCenterX = centerX + shadowLen / 2;

    const shadowGrad = ctx.createLinearGradient(centerX, groundY + 4, centerX + shadowLen, groundY + 18);
    shadowGrad.addColorStop(0, `rgba(45, 52, 54, ${shadowOpacity + 0.1})`);
    shadowGrad.addColorStop(1, `rgba(45, 52, 54, ${shadowOpacity * 0.35})`);
    ctx.fillStyle = shadowGrad;
    ctx.beginPath();
    ctx.ellipse(shadowCenterX, groundY + 8, shadowWidth, 14, 0, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = '#B19163';
    ctx.beginPath();
    ctx.moveTo(pillarX - 12, groundY + 1);
    ctx.lineTo(pillarX + pillarWidth + 12, groundY + 1);
    ctx.lineTo(pillarX + pillarWidth + 22, groundY + 18);
    ctx.lineTo(pillarX - 20, groundY + 18);
    ctx.closePath();
    ctx.fill();

    const pillarFront = ctx.createLinearGradient(pillarX, groundY - pillarHeight, pillarX + pillarWidth, groundY);
    pillarFront.addColorStop(0, '#9A8A76');
    pillarFront.addColorStop(0.55, '#7F7364');
    pillarFront.addColorStop(1, '#665C50');
    ctx.fillStyle = pillarFront;
    roundedRect(pillarX, groundY - pillarHeight, pillarWidth, pillarHeight, 7);
    ctx.fill();

    const sunOnRight = sunX > centerX;
    ctx.fillStyle = sunOnRight ? 'rgba(255,255,255,0.18)' : 'rgba(0,0,0,0.12)';
    ctx.fillRect(sunOnRight ? pillarX : pillarX + pillarWidth * 0.62, groundY - pillarHeight + 6, pillarWidth * 0.38, pillarHeight - 12);

    ctx.strokeStyle = 'rgba(255,255,255,0.16)';
    ctx.lineWidth = 1;
    for (let y = groundY - pillarHeight + 14; y < groundY - 12; y += 18) {
        ctx.beginPath();
        ctx.moveTo(pillarX + 6, y);
        ctx.lineTo(pillarX + pillarWidth - 6, y + 2);
        ctx.stroke();
    }

    const sideFace = sunOnRight
        ? [
            [pillarX + pillarWidth, groundY - pillarHeight],
            [pillarX + pillarWidth + 12, groundY - pillarHeight + 8],
            [pillarX + pillarWidth + 12, groundY + 8],
            [pillarX + pillarWidth, groundY]
        ]
        : [
            [pillarX, groundY - pillarHeight],
            [pillarX - 12, groundY - pillarHeight + 8],
            [pillarX - 12, groundY + 8],
            [pillarX, groundY]
        ];
    ctx.fillStyle = sunOnRight ? '#5E5449' : '#A39584';
    ctx.beginPath();
    ctx.moveTo(sideFace[0][0], sideFace[0][1]);
    for (let i = 1; i < sideFace.length; i++) {
        ctx.lineTo(sideFace[i][0], sideFace[i][1]);
    }
    ctx.closePath();
    ctx.fill();

    const sunGrad = ctx.createRadialGradient(sunX, sunY, 3, sunX, sunY, 44);
    sunGrad.addColorStop(0, '#FFFFFF');
    sunGrad.addColorStop(0.18, '#FFF4B3');
    sunGrad.addColorStop(0.45, '#F1C40F');
    sunGrad.addColorStop(1, 'rgba(241, 196, 15, 0)');
    ctx.fillStyle = sunGrad;
    ctx.beginPath();
    ctx.arc(sunX, sunY, 44, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = 'rgba(255, 220, 107, 0.4)';
    ctx.lineWidth = 2;
    for (let i = 0; i < 8; i++) {
        const angle = (Math.PI * 2 * i) / 8;
        ctx.beginPath();
        ctx.moveTo(sunX + Math.cos(angle) * 34, sunY + Math.sin(angle) * 34);
        ctx.lineTo(sunX + Math.cos(angle) * 54, sunY + Math.sin(angle) * 54);
        ctx.stroke();
    }
}

function drawPinholeCamera() {
    const panel = ctx.createLinearGradient(0, 0, 0, canvas.height);
    panel.addColorStop(0, '#FCFAF4');
    panel.addColorStop(1, '#F0E8D9');
    ctx.fillStyle = panel;
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    const boxW = Math.min(300, canvas.width * 0.38);
    const boxH = Math.min(250, canvas.height * 0.52);
    const boxX = canvas.width * 0.54;
    const boxY = (canvas.height - boxH) / 2;
    const pinholeY = boxY + boxH / 2;
    const screenX = boxX + boxW - 20;

    const candleX = clamp(state.mouse.x, canvas.width * 0.12, boxX - 95);
    const candleBaseY = clamp(state.mouse.y + 36, boxY + 70, boxY + boxH + 70);
    const objectScale = 0.95 + ((boxX - candleX) / Math.max(160, boxX - canvas.width * 0.12)) * 0.35;
    const bodyTopY = candleBaseY - 62 * objectScale;
    const flameTopY = candleBaseY - 88 * objectScale;
    const flameBottomY = candleBaseY - 54 * objectScale;
    const wickTopY = bodyTopY - 4 * objectScale;
    const wickBottomY = bodyTopY + 8 * objectScale;

    const ratio = (screenX - boxX) / Math.max(40, boxX - candleX);
    const projection = {
        bodyBottom: projectYThroughPinhole(candleBaseY, pinholeY, ratio),
        bodyTop: projectYThroughPinhole(bodyTopY, pinholeY, ratio),
        wickTop: projectYThroughPinhole(wickTopY, pinholeY, ratio),
        wickBottom: projectYThroughPinhole(wickBottomY, pinholeY, ratio),
        flameTop: projectYThroughPinhole(flameTopY, pinholeY, ratio),
        flameBottom: projectYThroughPinhole(flameBottomY, pinholeY, ratio)
    };

    ctx.fillStyle = 'rgba(230, 200, 152, 0.2)';
    ctx.fillRect(boxX - 16, boxY + boxH + 18, boxW + 56, 18);

    const sideDepth = 24;
    ctx.fillStyle = '#D7B57F';
    ctx.beginPath();
    ctx.moveTo(boxX + boxW, boxY);
    ctx.lineTo(boxX + boxW + sideDepth, boxY + 16);
    ctx.lineTo(boxX + boxW + sideDepth, boxY + boxH + 16);
    ctx.lineTo(boxX + boxW, boxY + boxH);
    ctx.closePath();
    ctx.fill();

    ctx.fillStyle = '#F0D7AA';
    ctx.beginPath();
    ctx.moveTo(boxX, boxY);
    ctx.lineTo(boxX + sideDepth, boxY - 16);
    ctx.lineTo(boxX + boxW + sideDepth, boxY - 16);
    ctx.lineTo(boxX + boxW, boxY);
    ctx.closePath();
    ctx.fill();

    const chamber = ctx.createLinearGradient(boxX + 8, boxY, boxX + boxW, boxY);
    chamber.addColorStop(0, '#231E17');
    chamber.addColorStop(0.5, '#0F1115');
    chamber.addColorStop(1, '#27313F');
    ctx.fillStyle = chamber;
    roundedRect(boxX, boxY, boxW, boxH, 14);
    ctx.fill();

    const cardboard = ctx.createLinearGradient(boxX, boxY, boxX + boxW, boxY + boxH);
    cardboard.addColorStop(0, '#F0D5A3');
    cardboard.addColorStop(0.5, '#E6C898');
    cardboard.addColorStop(1, '#CDA56C');
    ctx.fillStyle = cardboard;
    roundedRect(boxX - 12, boxY - 10, boxW + 24, boxH + 20, 18);
    ctx.fill();

    ctx.fillStyle = chamber;
    roundedRect(boxX, boxY, boxW, boxH, 14);
    ctx.fill();

    ctx.strokeStyle = 'rgba(130, 92, 46, 0.55)';
    ctx.lineWidth = 2;
    roundedRect(boxX - 12, boxY - 10, boxW + 24, boxH + 20, 18);
    ctx.stroke();

    ctx.strokeStyle = 'rgba(115, 80, 35, 0.35)';
    ctx.lineWidth = 1.3;
    for (let i = 0; i < 3; i++) {
        const seamY = boxY + 36 + i * (boxH / 3);
        ctx.beginPath();
        ctx.moveTo(boxX + boxW * 0.08, seamY);
        ctx.lineTo(boxX + boxW * 0.92, seamY + 6);
        ctx.stroke();
    }

    const screenGradient = ctx.createLinearGradient(screenX - 8, boxY + 10, screenX + 12, boxY + boxH - 10);
    screenGradient.addColorStop(0, 'rgba(224, 240, 255, 0.28)');
    screenGradient.addColorStop(1, 'rgba(210, 228, 255, 0.12)');
    ctx.fillStyle = screenGradient;
    ctx.fillRect(screenX - 6, boxY + 14, 12, boxH - 28);

    const apertureGlow = ctx.createRadialGradient(boxX + 2, pinholeY, 1, boxX + 2, pinholeY, 22);
    apertureGlow.addColorStop(0, 'rgba(255, 244, 200, 0.95)');
    apertureGlow.addColorStop(0.4, 'rgba(255, 220, 120, 0.4)');
    apertureGlow.addColorStop(1, 'rgba(255, 220, 120, 0)');
    ctx.fillStyle = apertureGlow;
    ctx.beginPath();
    ctx.arc(boxX + 2, pinholeY, 22, 0, Math.PI * 2);
    ctx.fill();

    ctx.fillStyle = '#1A1410';
    ctx.beginPath();
    ctx.arc(boxX, pinholeY, 5, 0, Math.PI * 2);
    ctx.fill();

    drawGlowRay(candleX, flameTopY, boxX, pinholeY, screenX, projection.flameTop, 'rgba(255, 176, 84, 0.95)');
    drawGlowRay(candleX, flameBottomY, boxX, pinholeY, screenX, projection.flameBottom, 'rgba(119, 196, 255, 0.95)');

    drawCandle(candleX, candleBaseY, objectScale, 1);

    ctx.save();
    ctx.beginPath();
    ctx.rect(boxX + 8, boxY + 10, boxW - 18, boxH - 20);
    ctx.clip();
    drawProjectedCandle(screenX, projection, 0.72);
    ctx.restore();

    ctx.fillStyle = 'rgba(255, 255, 255, 0.12)';
    ctx.fillRect(boxX + 24, boxY + 18, boxW * 0.22, boxH - 36);

    ctx.fillStyle = '#6B4B24';
    ctx.font = "11px 'Inter', sans-serif";
    ctx.fillText('PINHOLE CAMERA', boxX + 18, boxY - 22);
    ctx.fillText('dark chamber', boxX + boxW * 0.46, boxY + 22);

    ctx.fillStyle = 'rgba(45, 52, 54, 0.7)';
    ctx.font = "12px 'Inter', sans-serif";
    ctx.fillText('Move the candle with your mouse', 36, boxY - 22);
    ctx.fillText('closer to the hole = bigger image', 36, boxY + boxH + 34);
}

setObject('glass');
syncLayout();
draw();
