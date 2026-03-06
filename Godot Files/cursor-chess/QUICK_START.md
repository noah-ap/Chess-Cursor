# Quick Start Guide - Pixel Art Chess Shaders

## ✅ What's Already Set Up

- ✅ Low resolution (320x180) configured in project.godot
- ✅ Forward Plus renderer enabled
- ✅ Toon shader: `shaders/toon_piece.gdshader`
- ✅ Outline shader: `shaders/outline.gdshader`
- ✅ Camera script: `pixel_perfect_camera.gd`

## 🚀 Create Your Test Scene

1. **Create a new scene** (`test_scene.tscn`)

2. **Scene Structure:**
   ```
   TestScene (Node3D)
   ├── Camera3D
   │   └── [Attach script: pixel_perfect_camera.gd]
   ├── MeshInstance3D
   │   └── Mesh: SphereMesh or BoxMesh
   │   └── Material: ShaderMaterial
   │       └── Shader: res://shaders/toon_piece.gdshader
   │       └── Albedo: White or any color
   ├── DirectionalLight3D
   └── ColorRect (fullscreen)
       └── Anchors: Full Rect
       └── Color: Transparent (alpha = 0)
       └── Material: ShaderMaterial
           └── Shader: res://shaders/outline.gdshader
   ```

## 📝 Step-by-Step Setup

### Camera Setup:
1. Add `Camera3D` node
2. In Inspector, click the script icon and attach `pixel_perfect_camera.gd`
3. Camera will auto-setup isometric view

### Test Object Setup:
1. Add `MeshInstance3D` node
2. In Inspector:
   - **Mesh** → New SphereMesh (or BoxMesh)
3. Create material:
   - **Material Override** → New ShaderMaterial
   - **Shader** → Load: `res://shaders/toon_piece.gdshader`
   - Adjust **Albedo** color
   - Adjust **Bands** (1-10) for more/less toon steps
   - Adjust **Light Intensity** for brightness

### Outline Post-Process:
1. Add `ColorRect` node as child of root
2. In Inspector:
   - **Layout** → Full Rect (or set anchors manually)
   - **Color** → Set alpha to 0 (transparent)
3. Create material:
   - **Material** → New ShaderMaterial
   - **Shader** → Load: `res://shaders/outline.gdshader`
   - **Outline Color** → Black (0, 0, 0, 1)
   - **Outline Threshold** → 0.01 (lower = more sensitive)
   - **Outline Width** → 1.0 (thickness)

### Lighting:
1. Add `DirectionalLight3D` node
2. Rotate to light your scene (e.g., rotation_degrees = Vector3(-45, -30, 0))

## 🎮 Run the Scene

Press F5 or click Play. You should see:
- ✅ Pixelated low-res rendering
- ✅ Toon/cel-shaded objects
- ✅ Black outlines around objects
- ✅ Isometric camera view

## 🔧 Troubleshooting

**No outlines?**
- Make sure ColorRect covers entire screen
- Check that ColorRect has the outline shader material
- Try lowering `outline_threshold` to 0.005

**Too dark/bright?**
- Adjust `light_intensity` in toon shader material
- Adjust `bands` for more lighting steps
- Add more lights or increase light energy

**Camera not isometric?**
- The script sets it automatically, but you can adjust `rotation_degrees` and `position` in the script

## 📁 File Structure

```
cursor-chess/
├── project.godot
├── pixel_perfect_camera.gd
├── shaders/
│   ├── toon_piece.gdshader
│   └── outline.gdshader
└── [your scenes will go here]
```

## Next Steps

Once shaders work:
1. Create 3D chess piece models
2. Apply toon shader to pieces
3. Create chess board
4. Integrate chess logic!
