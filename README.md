# Kinetic Insight: The Interactive Visualization Lab

**Kinetic Insight** is an immersive, web-based educational platform designed for grades 9-12. It transforms abstract scientific formulas into tactile, visual experiences, fostering deep conceptual understanding through active play.

## 🚀 The Vision
Traditional learning is often static. Kinetic Insight makes it dynamic. Instead of reading about refraction, students "feel" the light bend by interacting with it. Our goal is to bridge the gap between "knowing" a formula and "seeing" the universe work.

## 🧪 Current Focus: Optics & Refraction
The first module explores **Snell's Law** and **Total Internal Reflection**.
- **Tactile Laser Control:** Aim and fire a laser beam through various media.
- **Dynamic Physics Engine:** Real-time calculation of refraction angles.
- **Visual Math Overlay:** Watch the math change as you move the beam.
- **AI Tutor:** Personalized, context-aware physics guidance.

## 🛠️ Tech Stack
- **Frontend:** HTML5 Canvas, JavaScript (60fps Animation)
- **Backend:** Python (FastAPI)
- **Database:** PostgreSQL (via Neon/Supabase)
- **Deployment:** Vercel
- **Intelligence:** LLM Integration for real-time tutoring

## 🏗️ Project Structure
- `/static`: The interactive frontend engine.
- `main.py`: Python API for data persistence and AI logic.
- `requirements.txt`: Python dependencies.

## 🚦 Getting Started (Dev Mode)
1. Initialize the virtual environment: `python -m venv venv`
2. Activate: `source venv/bin/activate`
3. Install dependencies: `pip install -r requirements.txt`
4. Run the server: `uvicorn main.py --reload`
