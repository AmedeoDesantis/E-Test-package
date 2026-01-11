FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install system dependencies required by Defects4J and Python
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    python3-venv \
    openjdk-11-jdk \
    git \
    subversion \
    perl \
    cpanminus \
    make \
    curl \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Setup Defects4J (following the official GitHub instructions)
WORKDIR /opt
RUN git clone https://github.com/rjust/defects4j.git defects4j

WORKDIR /opt/defects4j

# Automatically install all Perl dependencies via cpanm
RUN cpanm --installdeps .

# Initialize the framework (downloads external libraries and repositories)
RUN ./init.sh

# Add Defects4J executables to the system PATH
ENV PATH="/opt/defects4j/framework/bin:${PATH}"

# 3. Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# 4. Python environment and project setup
WORKDIR /app

# Create a virtual environment to isolate Python packages
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN git clone https://github.com/AmedeoDesantis/E-Test-package.git .

# Install Python dependencies from your requirements file
RUN pip install --no-cache-dir -r requirements.txt

# Make sure startup scripts are executable
RUN chmod +x /app/entrypoint.sh /app/extract_archives.sh

# Expose port for Jupyter Lab
EXPOSE 8888

# Set entrypoint and default command
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/bin/bash"]
