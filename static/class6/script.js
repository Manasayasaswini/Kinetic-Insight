const canvas = document.getElementById('experimentCanvas');
const ctx = canvas.getContext('2d');
const obsText = document.getElementById('observationText');

let currentObject = null;

function resize() {
    canvas.width = canvas.parentElement.clientWidth;
    canvas.height = canvas.parentElement.clientHeight;
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
}

function updateSun(val) {
    state.mode = 'shadow';
    state.sunAngle = val;
    obsText.innerHTML = getShadowObservation(val);
}

function getShadowObservation(angle) {
    if (angle > 80 && angle < 100) return "<strong>Noon:</strong> The sun is overhead. The shadow is at its shortest! [01:58]";
    if (angle < 40 || angle > 140) return "<strong>Morning/Evening:</strong> The sun is low in the sky. shadows become very long.";
    return "As the sun moves in a straight line, notice how the shadow always stays on the opposite side.";
}

function setMode(m) {
    state.mode = m;
    if (m === 'pinhole') {
        obsText.innerHTML = "<strong>Inversion:</strong> Because light travels in straight lines, the top of the candle goes through the hole and hits the bottom of the screen! [03:02]";
    }
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
    const groundY = canvas.height - 100;
    const centerX = canvas.width / 2;
    const objectHeight = 100;
    
    // 1. Draw Ground
    ctx.strokeStyle = '#D1D1C7';
    ctx.beginPath();
    ctx.moveTo(50, groundY);
    ctx.lineTo(canvas.width - 50, groundY);
    ctx.stroke();

    // 2. Calculate Sun Position (Semi-circle)
    const radius = 200;
    const rad = (state.sunAngle * Math.PI) / 180;
    const sunX = centerX + radius * Math.cos(Math.PI - rad);
    const sunY = groundY - radius * Math.sin(Math.PI - rad);

    // 3. Draw Shadow
    // The "Physics": Shadow length increases as sun angle decreases
    const shadowLen = objectHeight / Math.tan(rad);
    
    ctx.fillStyle = 'rgba(45, 52, 54, 0.2)'; // Soft Charcoal Shadow
    ctx.beginPath();
    ctx.ellipse(centerX + shadowLen/2, groundY, Math.abs(shadowLen/2), 5, 0, 0, Math.PI * 2);
    ctx.fill();

    // 4. Draw Stick Figure (The Opaque Object)
    ctx.strokeStyle = '#2D3436';
    ctx.lineWidth = 3;
    ctx.beginPath();
    // Body
    ctx.moveTo(centerX, groundY); ctx.lineTo(centerX, groundY - 60);
    // Head
    ctx.arc(centerX, groundY - 75, 15, 0, Math.PI * 2);
    // Arms & Legs
    ctx.moveTo(centerX, groundY - 50); ctx.lineTo(centerX - 20, groundY - 30);
    ctx.moveTo(centerX, groundY - 50); ctx.lineTo(centerX + 20, groundY - 30);
    ctx.stroke();

    // 5. Draw Sun
    ctx.shadowBlur = 20;
    ctx.shadowColor = '#FAD390';
    ctx.fillStyle = '#F1C40F';
    ctx.beginPath();
    ctx.arc(sunX, sunY, 20, 0, Math.PI * 2);
    ctx.fill();
    ctx.shadowBlur = 0;
}

function drawPinholeCamera() {
    const boxX = 400, boxY = 150, boxW = 250, boxH = 200;
    const pinholeY = boxY + boxH/2;
    
    // 1. Draw the Candle (The Object)
    // We use the mouse Y position to let the student "move" the candle
    const candleX = 150;
    const candleY = Math.max(100, Math.min(400, state.mouse.y));
    
    // Candle Body
    ctx.fillStyle = "#E0E0D5";
    ctx.fillRect(candleX - 10, candleY, 20, 60);
    // Flame
    ctx.fillStyle = "#F1C40F";
    ctx.beginPath();
    ctx.moveTo(candleX, candleY - 20);
    ctx.quadraticCurveTo(candleX + 10, candleY, candleX, candleY + 5);
    ctx.quadraticCurveTo(candleX - 10, candleY, candleX, candleY - 20);
    ctx.fill();

    // 2. Draw the Camera Box
    ctx.strokeStyle = "#2D3436";
    ctx.lineWidth = 2;
    ctx.strokeRect(boxX, boxY, boxW, boxH);
    // Draw the Pinhole
    ctx.fillStyle = "#F5F5F0";
    ctx.beginPath();
    ctx.arc(boxX, pinholeY, 4, 0, Math.PI * 2);
    ctx.fill();
    ctx.stroke();

    // 3. Draw Light Rays (The "Proof")
    ctx.setLineDash([5, 5]);
    ctx.strokeStyle = "rgba(241, 196, 15, 0.4)";
    
    // Ray from Top of Flame
    ctx.beginPath();
    ctx.moveTo(candleX, candleY - 20);
    ctx.lineTo(boxX, pinholeY);
    // Calculate inversion point on the back screen
    const ratio = boxW / (boxX - candleX);
    const invertedY = pinholeY + (pinholeY - (candleY - 20)) * ratio;
    ctx.lineTo(boxX + boxW, invertedY);
    ctx.stroke();
    
    // 4. Draw the Inverted Image
    // The "Fascinating" part: A smaller, upside-down flame
    const imgY = pinholeY + (pinholeY - candleY) * ratio;
    ctx.setLineDash([]);
    ctx.save();
    ctx.translate(boxX + boxW, imgY);
    ctx.scale(1, -1); // Flip vertically!
    ctx.globalAlpha = 0.6;
    // Drawing the same candle but smaller
    ctx.fillStyle = "#E0E0D5";
    ctx.fillRect(-5, 0, 10, 30);
    ctx.fillStyle = "#F1C40F";
    ctx.beginPath();
    ctx.moveTo(0, -10);
    ctx.quadraticCurveTo(5, 0, 0, 2);
    ctx.quadraticCurveTo(-5, 0, 0, -10);
    ctx.fill();
    ctx.restore();
}

draw();
