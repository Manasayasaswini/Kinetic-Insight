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
    origin: { x: 100, y: 100 },
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

    // 4. Refraction Calculation
    // Snell's Law: n1 * sin(theta1) = n2 * sin(theta2)
    const sinTheta2 = (state.n1 / state.n2) * Math.sin(theta1);
  
// Calculate relative speed (c is 1.0 in our simulation)
    const speed = (1.0 / state.n2).toFixed(2);

// Draw the Speedometer Tag
    const tagX = state.mouse.x + 50 * Math.sin(theta2);
    const tagY = state.boundaryY + 50 * Math.cos(theta2);

    ctx.fillStyle = "rgba(0, 242, 255, 0.8)";
    ctx.font = "bold 14px monospace";
    ctx.fillText(`Speed: ${speed}c`, tagX + 10, tagY);

// Optional: Add a small arrow to show direction
    ctx.beginPath();
    ctx.arc(tagX, tagY, 3, 0, Math.PI * 2);
    ctx.fill();

    if (Math.abs(sinTheta2) <= 1) {
        // SUCCESSFUL REFRACTION
        const theta2 = Math.asin(sinTheta2);
        const length = 1000; // Just to draw off-screen
        const endX = state.mouse.x + length * Math.sin(theta2);
        const endY = state.boundaryY + length * Math.cos(theta2);
        
        drawBeam(state.mouse.x, state.boundaryY, endX, endY, "#00f2ff");
    } else {
        // TOTAL INTERNAL REFLECTION (TIR)
        // This happens when going from High n to Low n, but we'll show it for "cool factor"
        const endX = state.mouse.x + (state.mouse.x - state.origin.x);
        const endY = state.origin.y; // Simplified bounce
        drawBeam(state.mouse.x, state.boundaryY, endX, endY, "#ff3e3e");
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
