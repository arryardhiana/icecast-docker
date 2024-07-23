# Gunakan base image Ubuntu 20.04
FROM ubuntu:20.04

# Tandai informasi kontak Anda
LABEL maintainer="arry <arry@unpad.ac.id>"

# Tambahkan pengguna dan grup icecast
RUN groupadd -r icecast && useradd -r -g icecast icecast

# Update dan upgrade paket pada container
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    icecast2 \
    curl \
    iputils-ping\
    tzdata\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Tambah Timezone Jakarta

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Salin file konfigurasi Icecast
COPY icecast.xml /etc/icecast2/icecast.xml

# Ubah pemilik file konfigurasi Icecast
RUN chown icecast:icecast /etc/icecast2/icecast.xml

# Buat direktori log dan set izin yang sesuai
RUN mkdir -p /var/log/icecast2 && chown icecast:icecast /var/log/icecast2

# Tampilkan port Icecast
#EXPOSE 8000

# Ubah pengguna yang dijalankan sebagai Icecast
USER icecast

# Jalankan Icecast saat container dimulai
CMD ["icecast2", "-c", "/etc/icecast2/icecast.xml"]

