const canvas = document.getElementById("canvas");
const ctx = canvas.getContext("2d");

// Responsive Canvas
function resize() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
}
window.onresize = resize;
resize();

// Simulation State
const state = {
    n1: 1.0,      // Air
    n2: 1.5,      // Glass
    boundaryY: canvas.height / 2,
    origin: { x: 50, y: canvas.height / 2 - 150 }, // Moved down and left
    mouse: { x: 300, y: 300 }
};

window.onmousemove = (e) => {
    state.mouse.x = e.clientX;
    state.mouse.y = e.clientY;
};

document.getElementById("material").addEventListener("change", (e) => {
    state.n2 = parseFloat(e.target.value);
});

function draw() {
    ctx.fillStyle = "#0a0a0c"; // Dark space-like background
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    // 1. Draw the "Water/Glass" medium
    ctx.fillStyle = "rgba(0, 150, 255, 0.15)";
    ctx.fillRect(0, state.boundaryY, canvas.width, canvas.height - state.boundaryY);

    // 2. Draw the "Normal" (The dotted teaching line)
    ctx.setLineDash([5, 5]);
    ctx.strokeStyle = "rgba(255, 255, 255, 0.3)";
    ctx.beginPath();
    ctx.moveTo(state.mouse.x, state.boundaryY - 100);
    ctx.lineTo(state.mouse.x, state.boundaryY + 100);
    ctx.stroke();
    ctx.setLineDash([]); // Reset dash

    // 3. Incident Ray (The Laser)
    const dx = state.mouse.x - state.origin.x;
    const dy = state.boundaryY - state.origin.y;
    const theta1 = Math.atan2(dx, dy); // Angle relative to Normal

    drawBeam(state.origin.x, state.origin.y, state.mouse.x, state.boundaryY, "#ff3e3e");

    if (Math.abs(sinTheta2) <= 1) {
        const theta2 = Math.asin(sinTheta2);
        const length = 2000; 
        const endX = state.mouse.x + length * Math.sin(theta2);
        const endY = state.boundaryY + length * Math.cos(theta2);

        drawBeam(state.mouse.x, state.boundaryY, endX, endY, "#00f2ff");

        // --- SPEEDOMETER TAG ---
        const speed = (1.0 / state.n2).toFixed(2);
        ctx.fillStyle = "#00f2ff";
        ctx.font = "bold 16px monospace";
        // Place text 100px down the refracted beam
        const textX = state.mouse.x + 100 * Math.sin(theta2);
        const textY = state.boundaryY + 100 * Math.cos(theta2);
        ctx.fillText(`v ≈ ${speed}c`, textX + 20, textY);
    }

    requestAnimationFrame(draw);
    }

// Helper for "Fascinating" Neon Glow
function drawBeam(x1, y1, x2, y2, color) {
    ctx.shadowBlur = 15;
    ctx.shadowColor = color;
    ctx.strokeStyle = color;
    ctx.lineWidth = 4;
    ctx.lineCap = "round";
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();
    ctx.shadowBlur = 0; // Reset for other drawings
}

draw();
