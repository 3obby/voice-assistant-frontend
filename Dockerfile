# Use a base Docker image with both Node and Python
FROM node:18-bullseye

# Install Python
RUN apt-get update && apt-get install -y python3 python3-venv

# Set work directory
WORKDIR /app

# Copy package files and install Node deps
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm
RUN pnpm install

# Copy the rest
COPY . .

# Create and activate a Python venv, install requirements
RUN python3 -m venv venv
RUN . venv/bin/activate && pip install -r requirements.txt

# Expose the Next.js port
EXPOSE 3000

# By default, run Next in background and the Python agent
# Use a process manager like "forever" or "render" two processes.
CMD ["/bin/bash", "-c", "pnpm dev & . venv/bin/activate && python agent.py"]