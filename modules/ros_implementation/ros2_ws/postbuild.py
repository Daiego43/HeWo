#!/usr/bin/env python3
import os

EXECUTABLES = [
    "install/hewo_face_pkg/lib/hewo_face_pkg/hewo_main_node",
    "install/hewo_face_pkg/lib/hewo_face_pkg/hewo_test_node"
]

python_path = os.popen("which python").read().strip()

for exe in EXECUTABLES:
    if not os.path.exists(exe):
        continue
    with open(exe, "r+") as f:
        lines = f.readlines()
        lines[0] = f"#!{python_path}\n"
        f.seek(0)
        f.writelines(lines)
    os.chmod(exe, 0o755)
    print(f"[✓] Fixed shebang in {exe}")
