# Granix
FOA Granulator
# GRANIX - AmbiX Granulator

![Granix Interface](docs/images/granix_interface.png)

A sophisticated real-time granular synthesizer with first-order Ambisonics spatialization, developed in Csound with Cabbage framework.

## 🎯 Overview

**GRANIX** transforms traditional granular synthesis by integrating intelligent spatial audio processing through AmbiX (4-channel first-order Ambisonics). Unlike conventional granulators that treat spatialization as an afterthought, GRANIX makes space an integral part of the sound design process.

### Key Features

- **Real-time Granular Synthesis** with comprehensive parameter control
- **First-Order Ambisonics (FOA)** encoding in AmbiX format (W, Y, Z, X)
- **Dynamic Spatial Movement** based on audio buffer position
- **Intelligent Grain Distribution** in 3D space
- **Professional VST3 Plugin** built with Cabbage framework
- **Comprehensive GUI** with waveform display and real-time controls

## 🚀 What Makes GRANIX Unique

### Reasoned Ambisonics Implementation
- **Position-Dependent Azimuth**: Grains rotate through 360° space based on their position in the audio buffer
- **Density-Controlled Elevation**: Spatial height distribution correlates with grain density for natural sound behavior
- **Automatic Space Filling**: Higher density settings automatically create more immersive spatial coverage

### Advanced Granulation Engine
- **Dual Randomization**: Independent control over density and duration randomness
- **Flexible Envelope Shaping**: Adjustable attack/decay ratio for each grain
- **Scrubber Control**: Precise playhead positioning with randomization
- **Bidirectional Playback**: Forward and reverse reading with variable speed

## 📋 Requirements

### Software Dependencies
- **Csound 6.15+** with plugin support
- **Cabbage 2.5+** for GUI and VST3 compilation
- **DAW with AmbiX support** (Reaper, Pro Tools, Logic Pro, etc.)

### Recommended Setup
- **AmbiX Decoder Plugin** (e.g., IEM Plugin Suite)
- **4-channel audio interface** or virtual routing
- **Spatial Audio Monitoring** (headphones or surround speakers)

## 🔧 Installation

### Option 1: Pre-compiled VST3
1. Download the latest release from [Releases](https://github.com/7IMING/Granix/releases)
2. Copy `Granix.vst3` to your VST3 plugins folder:
   - **Windows**: `C:\Program Files\Common Files\VST3\`
   - **macOS**: `~/Library/Audio/Plug-Ins/VST3/`
   - **Linux**: `~/.vst3/`

### Option 2: Build from Source
```bash
# Clone repository
git clone git@github.com:7IMING/Granix.git
cd Granix

# Open in Cabbage
cabbage AmbixGranulatoreDef.csd

# Export as VST3 from Cabbage interface
# File → Export → VST3 Plugin
```

## 🎛️ Interface Guide

### Transport Controls
- **Open File**: Load audio file (WAV, AIFF, FLAC supported)
- **ON/OFF**: Enable/disable granulator engine
- **Play/Stop**: Control transport playback

### Granulation Parameters

| Parameter | Range | Description |
|-----------|-------|-------------|
| **FREQ** | -2 to +2 | Grain reading frequency (pitch control) |
| **DENS** | 1-1000 | Grain density (grains per second) |
| **DENS RAND** | 0-100% | Density randomization amount |
| **DUR** | 1-1000ms | Individual grain duration |
| **DUR RAND** | 0-100% | Duration randomization amount |
| **ENVFORM** | 0.001-0.999 | Envelope attack/decay ratio |

### Spatial Controls

| Parameter | Range | Description |
|-----------|-------|-------------|
| **AZIMUTH** | -180° to +180° | Horizontal rotation offset |
| **% ELEVATION** | 0-100% | Vertical spread intensity |
| **AMP IN** | 0-100% | Input gain control |

### Transport & Navigation
| Parameter | Range | Description |
|-----------|-------|-------------|
| **RATE PLAY** | -2 to +2 | Playback speed and direction |
| **SCRAB** | 0-100% | Playhead position variation |

## 🎵 Creative Usage Examples

### Evolving Soundscapes
```
• DENS: 50-100 grains/sec
• DUR: 100-500ms with 30% randomization  
• AZIMUTH: Sweep from -180° to +180°
• ELEVATION: 70-90% for full sphere coverage
```

### Rhythmic Textures
```
• DENS: 10-30 grains/sec with minimal randomization
• DUR: 20-100ms for percussive character
• RATE PLAY: Sync to DAW tempo
• ELEVATION: 20-40% for focused positioning
```

### Reverse Granular Clouds
```
• FREQ: -1.5 to -0.5 (reverse pitch)
• RATE PLAY: -0.5 to -1.0 (reverse transport)
• DENS RAND: 60-80% for organic clustering
• SCRAB: 40-60% for position drift
```

## 🔊 AmbiX Output Format

GRANIX outputs **4-channel AmbiX** (ACN/SN3D):

| Channel | Component | Description |
|---------|-----------|-------------|
| 1 | **W** | Omnidirectional (pressure) |
| 2 | **Y** | Left-Right (velocity) |
| 3 | **Z** | Up-Down (velocity) |  
| 4 | **X** | Front-Back (velocity) |

### Decoding Recommendations
- **IEM AllRADecoder** (free, comprehensive)
- **Ambix Decoder** (open source)
- **Blue Ripple Sound O3A** (professional)

## 🏗️ Technical Architecture

### Core Components
- **Main Controller** (Instrument 100): Parameter management and GUI coordination
- **File Loader** (Instrument 99): Audio file analysis and table generation  
- **Playback Engine** (Instrument 1): Transport control and grain scheduling
- **Grain Generator** (Instrument 2): Individual grain synthesis and spatialization
- **AmbiX Encoder** (Custom Opcode): Spherical to AmbiX conversion

### Spatial Algorithm
```csound
; Dynamic azimuth combines user control with buffer position
kaziout = user_azimuth + (buffer_position) * 360°

; Elevation varies with density and amplitude
kelev = (random(-90°, +90°)) * density_scale * user_elevation%
```

## 📚 Documentation

- **[User Manual](docs/user_manual.md)** - Comprehensive parameter guide
- **[Spatial Audio Theory](docs/ambisonics_theory.md)** - Understanding AmbiX implementation
- **[Creative Techniques](docs/creative_techniques.md)** - Advanced usage patterns
- **[Technical Reference](docs/technical_reference.md)** - Code documentation

## 🐛 Known Limitations

### FOA Resolution Artifacts
- **"Donut Effect"**: Energy gaps in diagonal directions (inherent to first-order)
- **Solution**: Increase grain density and duration for better spatial coverage

### Performance Considerations
- **High grain densities** (>500/sec) may require buffer optimization
- **Complex audio files** with high channel counts load as mono only

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md).

### Development Setup
```bash
# Fork and clone
git clone https://github.com/yourusername/Granix.git

# Create feature branch  
git checkout -b feature/amazing-feature

# Make changes and test thoroughly
# Commit with descriptive messages
git commit -m "Add amazing spatial feature"

# Push and create pull request
git push origin feature/amazing-feature
```

## 📄 License

This project is licensed under the **GPL-3.0 License** - see [LICENSE](LICENSE) file for details.

### Third-Party Acknowledgments
- **Csound**: Audio programming language by the Csound Community
- **Cabbage**: Visual programming framework by Rory Walsh
- **AmbiX Standard**: Spatial audio format specification

## 👨‍💻 Author

**Francesco Dicorato** - Sound Designer & Developer
- GitHub: [@7IMING](https://github.com/7IMING)
- Email: francesco.dicorato@example.com

## 🙏 Acknowledgments

- **Csound Community** for the robust audio programming environment
- **Rory Walsh** for the Cabbage framework
- **IEM Graz** for AmbiX format standardization and tools
- **Spatial Audio Research** community for theoretical foundations

## 📊 Project Status

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-GPL--3.0-orange)
![Platform](https://img.shields.io/badge/platform-VST3-purple)

---

**Ready to explore spatial granular synthesis?** Download GRANIX and transform your audio into immersive 3D soundscapes!

⭐ **Star this repository** if you find GRANIX useful for your projects!
