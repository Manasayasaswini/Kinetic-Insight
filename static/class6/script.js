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

const state = {
    torchPos: { x: 100, y: 250 },
    objectPos: { x: 350, y: 250 },
    lightColor: 'rgba(255, 255, 200, 0.6)'
};

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
    obsText.innerHTML = `<strong>${currentObject.name}:</strong> ${currentObject.info}`;
}

function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

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

    requestAnimationFrame(draw);
}

draw();
