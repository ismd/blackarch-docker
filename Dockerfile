FROM blackarchlinux/blackarch:novnc

RUN useradd -m builder \
    && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install yay AUR helper
RUN pacman -Syu --needed --noconfirm base-devel git \
    && su - builder -c " \
        git clone https://aur.archlinux.org/yay.git /tmp/yay \
        && cd /tmp/yay \
        && makepkg -si --noconfirm \
    " && rm -rf /tmp/yay

# Base packages
RUN su - builder -c "yay -Sy --needed --noconfirm \
    bash-completion \
    fd \
    fzf \
    jq \
    lazygit \
    less \
    man-db \
    nano \
    neovim \
    nfs-utils \
    nodejs \
    npm \
    openssh \
    pocl \
    python \
    python2 \
    python-beautifulsoup4 \
    python-pip \
    python-pwntools \
    python-pycryptodome \
    python-requests \
    python2-requests \
    ripgrep \
    starship \
    tldr \
    unzip \
    wget \
    yq \
    zsh \
    && yay -Scc --noconfirm"

# CTF tools
RUN su - builder -c "yay -S --needed --noconfirm \
    # Crypto
    rsactftool \
    rsatool \
    # Exploitation
    exploitdb \
    metasploit \
    # Forensics & Stego
    binwalk \
    exiftool \
    foremost \
    steghide \
    stegseek \
    # Network
    netcat \
    socat \
    wireshark-cli \
    # Password cracking
    hashcat \
    hydra \
    john \
    # Recon & Scanning
    masscan \
    nikto \
    nmap \
    # Reverse engineering
    gdb \
    gef \
    ltrace \
    pwndbg \
    strace \
    # Web
    burpsuite \
    ffuf \
    gobuster \
    sqlmap \
    wfuzz \
    # Wireless
    aircrack-ng \
    wifite \
    && yay -Scc --noconfirm"

# zsh + starship
RUN chsh -s /bin/zsh root \
    && echo 'eval "$(starship init zsh)"' >> /root/.zshrc \
    && echo 'autoload -Uz compinit && compinit' >> /root/.zshrc \
    && echo 'bindkey -e' >> /root/.zshrc \
    && echo 'WORDCHARS=""' >> /root/.zshrc \
    && echo 'export PATH="$PATH:/usr/bin/vendor_perl"' >> /root/.zshrc

# LazyVim
RUN git clone https://github.com/LazyVim/starter /root/.config/nvim \
    && rm -rf /root/.config/nvim/.git

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /app
EXPOSE 8080/tcp
CMD ["/bin/zsh"]
