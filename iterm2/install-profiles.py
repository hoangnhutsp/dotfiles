#!/usr/bin/env python3
"""Install iTerm2 dynamic profiles for the images in the dotfiles bg folder."""

import json
import re
import subprocess
import sys
from pathlib import Path


def main() -> None:
    image_dir = Path(sys.argv[1]).expanduser().resolve()
    images = sorted(
        path for path in image_dir.iterdir()
        if path.is_file() and path.suffix.lower() in {".png", ".jpg", ".jpeg", ".gif", ".tif", ".tiff"}
    )
    if not images:
        raise SystemExit(f"No background images found in {image_dir}")

    profiles = []
    profile_guids = {}
    for image in images:
        slug = re.sub(r"[^a-z0-9]+", "-", image.name.lower()).strip("-")
        guid = f"dotfiles-bg-{slug}"
        profiles.append(
            {
                "Name": f"Dotfiles - {image.name}",
                "Guid": guid,
                "Background Image Location": str(image),
            }
        )
        profile_guids[image.name] = guid

    support_dir = Path.home() / "Library/Application Support/iTerm2/DynamicProfiles"
    support_dir.mkdir(parents=True, exist_ok=True)
    profile_file = support_dir / "dotfiles.json"
    profile_file.write_text(json.dumps({"Profiles": profiles}, indent=2) + "\n")

    default_guid = profile_guids.get("02.png", profiles[0]["Guid"])
    subprocess.run(
        ["defaults", "write", "com.googlecode.iterm2", "Default Profile Guid", "-string", default_guid],
        check=True,
    )
    print(f"Installed {len(profiles)} iTerm2 background profiles; default: {default_guid}")


if __name__ == "__main__":
    main()
