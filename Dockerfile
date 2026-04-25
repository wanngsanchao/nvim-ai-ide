# 1. 强制使用 x86_64 (amd64) 架构的基础镜像
FROM --platform=linux/amd64 ubuntu:22.04

# 2. 设置非交互式安装模式
ENV DEBIAN_FRONTEND=noninteractive

# 3. 设置全局 HTTP/HTTPS 代理（用于 curl, wget, git, npm, pip 等）
ENV HTTP_PROXY=http://httpproxy-headless.kubebrain.svc.pjlab.local:3128
ENV HTTPS_PROXY=http://httpproxy-headless.kubebrain.svc.pjlab.local:3128
ENV NO_PROXY=.pjlab.org.cn,localhost,127.0.0.1

# 4. 配置 APT 包管理器专用代理
RUN echo 'Acquire::http::Proxy "http://httpproxy-headless.kubebrain.svc.pjlab.local:3128";' > /etc/apt/apt.conf.d/99proxy && \
    echo 'Acquire::https::Proxy "http://httpproxy-headless.kubebrain.svc.pjlab.local:3128";' >> /etc/apt/apt.conf.d/99proxy

# 5. 安装系统基础工具、开发依赖、LSP 依赖、Neovim 编译依赖及网络诊断工具
RUN apt-get update && \
    apt-get install -y \
        curl \
        wget \
        git \
        unzip \
        build-essential \
        cmake \
        python3 \
        python3-pip \
        python3-venv \
        nodejs \
        npm \
        ripgrep \
        fd-find \
        fzf \
        gcc \
        g++ \
        gdb \
        shellcheck \
        openssh-server \
        sudo \
        htop \
        tmux \
        less \
        vim \
        rsync \
        ca-certificates \
        clangd \
        ninja-build \
        gettext \
        libtool \
        libtool-bin \
        autoconf \
        automake \
        pkg-config \
        doxygen \
        iproute2 \
        net-tools \
        tcpdump \
        iputils-ping \
        netcat-openbsd \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 6. 安装 Go（用于 gopls LSP）
RUN curl -OL https://go.dev/dl/go1.23.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.23.5.linux-amd64.tar.gz && \
    rm go1.23.5.linux-amd64.tar.gz

# 7. 将 Go 加入 PATH
ENV PATH="/usr/local/go/bin:/root/go/bin:${PATH}"

# 8. 安装语言服务器（LSP）
RUN go install golang.org/x/tools/gopls@latest && \
    pip3 install ruff-lsp && \
    npm install -g bash-language-server && \
    npm cache clean --force

# 9. 无交互安装 Rust 工具链
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 10. 将 Cargo 二进制目录加入 PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# 11. 安装 tree-sitter-cli
RUN cargo --version && \
    cargo install tree-sitter-cli

# 12. 从源码编译并安装 Neovim
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make install && \
    rm -rf /tmp/neovim

# 13. 创建默认工作目录
RUN mkdir -p /data

# 14. 配置 SSH 服务（允许 root 密码登录）
RUN mkdir -p /run/sshd && \
    echo 'root:devpassword' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 15. 设置 nvim 别名
RUN echo 'alias n=nvim' >> /root/.bashrc

# 16. 复制容器启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 17. 暴露 SSH 端口
EXPOSE 22

# 18. 设置容器默认工作目录
WORKDIR /data

# 19. 启动 SSH 服务（前台运行）
CMD ["/bin/bash", "/entrypoint.sh"]
