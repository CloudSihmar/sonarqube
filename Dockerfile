FROM sonarqube:lts-community

USER root

# 1. Upgrade system packages and clean up
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2. Remove vulnerable libcurl versions
RUN apt-get update && \
    apt-get purge -y curl libcurl4 && \
    apt-get autoremove -y && \
    find / -name "*libcurl.so*" -delete 2>/dev/null || true && \
    rm -rf /var/lib/apt/lists/*

# 3. Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libzstd-dev \
    libbrotli-dev \
    libidn2-0-dev \
    libpsl-dev \
    libnghttp2-dev \
    libldap2-dev \
    libssh-dev \
    ca-certificates \
    wget \
    perl && \
    rm -rf /var/lib/apt/lists/*

# 4. Install curl 8.12.0 from source
RUN wget https://curl.se/download/curl-8.12.0.tar.gz && \
    tar -xzf curl-8.12.0.tar.gz && \
    cd curl-8.12.0 && \
    ./configure \
        --prefix=/usr \
        --libdir=/usr/lib/x86_64-linux-gnu \
        --with-openssl \
        --with-nghttp2 \
        --with-brotli \
        --with-zstd \
        --with-libidn2 \
        --with-psl \
        --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf curl-8.12.0 curl-8.12.0.tar.gz

# 5. Verify installation
RUN ldconfig && \
    curl --version

# 6. Clean up build dependencies (optional)
RUN apt-get purge -y build-essential && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER sonarqube
