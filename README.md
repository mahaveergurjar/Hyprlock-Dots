# Hyprlock Configuration

A curated collection of **Hyprlock layouts** with ready-to-use configuration files. Each layout provides a unique visual style for your lock screen.

---

## Preview

Below are all available layouts:

### Layout 1
![Layout 1](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout1.png)
### Layout 2
![Layout 2](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout2.png)
### Layout 3
![Layout 3](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout3.png)
### Layout 4
![Layout 4](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout4.png)
### Layout 5
![Layout 5](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout5.png)

### Layout 6
![Layout 6](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout6.png)
### Layout 7
![Layout 7](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout7.png)
### Layout 8
![Layout 8](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout8.png)
### Layout 9
![Layout 9](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout9.png)
### Layout 10
![Layout 10](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout10.png)

### Layout 11
![Layout 11](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout11.png)
### Layout 12
![Layout 12](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout12.png)
### Layout 13
![Layout 13](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout13.png)
### Layout 14
![Layout 14](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout14.png)
### Layout 15
![Layout 15](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout15.png)

### Layout 16
![Layout 16](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout16.png)
### Layout 17
![Layout 17](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/main/screenshots/layout17.png)
### Layout 18
![Layout 18](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/refs/heads/main/screenshots/layout18.png)
### Layout 19
![Layout 19](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/glava/screenshots/layout19.png)
### Layout 20
![Layout 20](https://raw.githubusercontent.com/mahaveergurjar/Hyprlock-Dots/refs/heads/main/screenshots/layout20.png)

> **Note:**  
> Layout 19 requires files from a separate branch:  
> https://github.com/mahaveergurjar/Hyprlock-Dots/tree/glava

---

## Installation

### 1. Clone the repository
```bash
git clone https://github.com/mahaveergurjar/Hyprlock-Dots.git
cd Hyprlock-Dots
```

### 2. Copy configuration files
```bash
cp -r .config/hyprlock ~/.config/
cp hyprlock.conf ~/.config/hypr/
```

### 3. Reload Hyprlock
```bash
hyprlock --reload
```

---

## Usage

- Select a layout by editing `hyprlock.conf`
- Point to the desired layout file inside `~/.config/hyprlock/`
- Reload Hyprlock after changes

---

## Customization

All layouts are fully customizable:

- Location: `~/.config/hyprlock/`
- Modify:
  - Colors
  - Fonts
  - Widgets
  - Backgrounds

Each layout is modular, so you can mix and match components easily.

---

## Troubleshooting

Common issues and fixes:

- **Hyprlock not reloading**  
  → Ensure `hyprlock --reload` runs without errors  

- **Layout not applied**  
  → Verify correct file path in `hyprlock.conf`  

- **Missing assets (fonts/images)**  
  → Install required dependencies or update paths  

---

## Issues

Encountered a bug or need help?  
Open an issue in the repository with:

- Your configuration  
- Error logs  
- Screenshot (if applicable)
