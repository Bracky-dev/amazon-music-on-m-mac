# Amazon Music on M Mac

Amazon's Mac installer refuses to open on Apple Silicon (M1–M4) because its start script only checks for Intel chips.

1. Download the official installer from amazon.com/music.
2. Open this DMG and run "Install Amazon Music.command".

It verifies Amazon's signature, then runs the installer through Rosetta.
