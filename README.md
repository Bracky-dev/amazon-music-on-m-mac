# Amazon Music on M Mac

Amazon's Mac installer refuses to open on Apple Silicon (M1–M6?) because its start script only checks for Intel chips.
This is the native Mac app, not a crappy rebuild. The startup of the app is the only thing that is patched.

1. Download the official installer from amazon.com/music.
2. Open this DMG and move it to applications.
3. Once you are signed in, restart the app if it isnt loading *(only issue for me)*

It verifies Amazon's signature, then runs the installer through Rosetta.

<img width="600" height="400" alt="image" src="https://github.com/user-attachments/assets/903b6c45-d5a6-4643-a87c-896cfed46c0d" />
