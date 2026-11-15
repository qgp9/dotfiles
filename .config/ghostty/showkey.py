#!/usr/bin/env python3
"""터미널이 앱에 보내는 바이트를 그대로 출력. q 두 번 연속 누르면 종료.

  python3 showkey.py          # 레거시 인코딩 (일반 앱이 받는 것)
  python3 showkey.py kitty    # kitty keyboard protocol 켠 상태 (modern TUI가 받는 것)
"""
import os, sys, termios, tty, select

kitty = len(sys.argv) > 1 and sys.argv[1] == "kitty"
fd = sys.stdin.fileno()
old = termios.tcgetattr(fd)
tty.setraw(fd)
if kitty:
    # 1=disambiguate, 8=all keys as escape codes
    os.write(1, b"\x1b[>9u")
print(f"mode={'kitty' if kitty else 'legacy'}  — 키를 눌러보세요 (q q 로 종료)\r")
last = b""
try:
    while True:
        data = os.read(fd, 64)
        while select.select([fd], [], [], 0.02)[0]:
            data += os.read(fd, 64)
        print(repr(data).replace("\\x1b", "ESC") + "\r")
        if data in (b"q", b"\x1b[113u") and last == data:
            break
        last = data
finally:
    if kitty:
        os.write(1, b"\x1b[<u")
    termios.tcsetattr(fd, termios.TCSADRAIN, old)
