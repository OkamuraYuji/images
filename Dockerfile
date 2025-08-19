FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV VNC_GEOMETRY=1920x1080
ENV VNC_DEPTH=24

# Cập nhật và cài đặt GNOME + VNC + các gói cần thiết
RUN apt-get update && \
    apt-get install -y \
    ubuntu-desktop \
    gnome-panel \
    gnome-settings-daemon \
    metacity \
    nautilus \
    gnome-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    supervisor \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Tạo password VNC mặc định
RUN mkdir -p /root/.vnc && \
    echo "123456" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Tạo script khởi động VNC và noVNC
RUN echo "#!/bin/bash\n\
vncserver :1 -geometry $VNC_GEOMETRY -depth $VNC_DEPTH && \n\
websockify --web=/usr/share/novnc/ --wrap-mode=ignore 8080 localhost:5901\n" \
> /startup.sh && chmod +x /startup.sh

EXPOSE 5901 8080

CMD ["/startup.sh"]
