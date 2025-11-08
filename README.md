# Hyprlock Configuration

This repository contains the Hyprlock configuration files and layout settings. Below are the different layouts with their respective screenshots and descriptions.

## Layout 19

![Layout 19](https://github.com/mahaveergurjar/Hyprlock-Dots/blob/glava/screenshots/layout19.png)

## Layout 20

![Layout 20](https://github.com/mahaveergurjar/Hyprlock-Dots/blob/glava/screenshots/layout20.png)

...

## Installation and Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/mahaveergurjar/hyprlock-Dots.git
   ```
2. Copy the configuration files to your Hyprlock directory:
   ```bash
   cp -r hyprlock-config/* ~/.config/hyprlock/
   ```
3. Copy the `hyprlock.conf` file to the Hypr configuration directory:
   ```bash
   cp hyprlock.conf ~/.config/hypr/
   ```
4. Copy the glava configuration files files to your glava directory

   ```bash
   cp -f $HOME/.config/glava/{radial.glsl,rc.glsl} ~/.config/glava/
   ```

5. Restart Hyprlock to apply the changes:
   ```bash
   hyprlock --reload
   ```

## Customization

You can customize the layouts by editing the respective configuration files located in the `~/.config/hyprlock/` directory.

## Issues

If you face any issues, please open an issue in this repository.
