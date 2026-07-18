#!/usr/bin/env python3
# Background daemon to listen for Hyprland workspace changes and notify Waybar instantly (with debug logging)

import socket
import os
import subprocess
import time
import sys

def main():
    with open("/tmp/hypr_listener.log", "w", buffering=1) as log:
        log.write("Started hypr_listener\n")
        
        runtime_dir = os.environ.get("XDG_RUNTIME_DIR")
        instance = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
        log.write(f"Env: XDG_RUNTIME_DIR={runtime_dir}, SIGNATURE={instance}\n")
        
        if not runtime_dir or not instance:
            log.write("Error: environment variables missing\n")
            return
            
        socket_path = f"{runtime_dir}/hypr/{instance}/.socket2.sock"
        log.write(f"Socket path: {socket_path}\n")
        
        # Keep trying to connect on startup
        connected = False
        for i in range(10):
            if os.path.exists(socket_path):
                try:
                    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                    s.connect(socket_path)
                    connected = True
                    log.write(f"Connected to socket on attempt {i+1}\n")
                    break
                except Exception as e:
                    log.write(f"Connection attempt {i+1} failed: {e}\n")
            else:
                log.write(f"Socket path does not exist on attempt {i+1}\n")
            time.sleep(0.5)
            
        if not connected:
            log.write("Error: failed to connect to socket\n")
            return
            
        buffer = ""
        while True:
            try:
                data = s.recv(4096).decode('utf-8', errors='ignore')
                if not data:
                    log.write("Socket disconnected by remote end\n")
                    break
                buffer += data
                while "\n" in buffer:
                    line, buffer = buffer.split("\n", 1)
                    # Check for workspace switch, monitor switch, or window open/close events
                    if (line.startswith("workspace>>") or 
                        line.startswith("focusedmon>>") or 
                        line.startswith("openwindow>>") or 
                        line.startswith("closewindow>>")):
                        log.write(f"Received matched event: {line}\n")
                        res = subprocess.run(["pkill", "-RTMIN+8", "waybar"], capture_output=True, text=True)
                        log.write(f"pkill finished with returncode={res.returncode}, stdout={res.stdout.strip()}, stderr={res.stderr.strip()}\n")
            except Exception as e:
                log.write(f"Exception in read loop: {e}\n")
                break

if __name__ == "__main__":
    main()
