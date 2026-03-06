# Pixel Art Shader Setup Instructions

## Files Created

✅ **Shaders:**
- `shaders/toon_piece.gdshader` - Toon/cel shading for 3D objects
- `shaders/outline.gdshader` - Post-process outline shader

✅ **Scripts:**
- `scripts/pixel_perfect_camera.gd` - Camera with pixel-perfect snapping
- `scripts/pixel_art_setup.gd` - Setup script for low-res rendering

## Setup Steps

### 1. Project Settings

Before creating your scene, configure these settings:

1. **Project Settings > Rendering > Renderer:**
   - Make sure `Rendering Method` is set to `Forward Plus` (this is usually the default)
   - In Godot 4, depth and normal textures are available by default with Forward Plus renderer
   - If you see `Depth Prepass` option, enable it (may not be visible in all versions)

2. **Project Settings > Display > Window:**
   - Set `Size` to `320x180` (or your preferred low resolution)
   - Set `Stretch Mode` to `viewport` or `canvas_items`
   - Set `Stretch Aspect` to `keep`

**Note:** In Godot 4, `DEPTH_TEXTURE` and `NORMAL_TEXTURE` should work automatically with the Forward Plus renderer. If outlines don't appear, we may need to adjust the shader approach.

### 2. Create Test Scene

Create a new scene (`test_scene.tscn`) with this structure:

```
TestScene (Node3D)
├── Camera3D
│   └── [Attach: scripts/pixel_perfect_camera.gd]
├── MeshInstance3D (test object)
│   └── Mesh: SphereMesh or BoxMesh
│   └── Material: ShaderMaterial
│       └── Shader: shaders/toon_piece.gdshader
│       └── Albedo: Set to white or any color
├── DirectionalLight3D
│   └── Rotation: Adjust for lighting
└── ColorRect (fullscreen overlay)
    └── Anchors: Full Rect (stretch to fill screen)
    └── Color: Transparent (alpha = 0)
    └── Material: ShaderMaterial
        └── Shader: shaders/outline.gdshader
        └── Outline Color: Black (0, 0, 0, 1)
```

### 3. Detailed Setup

#### Camera Setup:
1. Add a `Camera3D` node
2. Attach the `pixel_perfect_camera.gd` script
3. The script will automatically set up isometric view
4. Adjust `pixel_size`, `low_res_width`, and `low_res_height` in the inspector

#### Test Object Setup:
1. Add a `MeshInstance3D` node
2. In the Inspector, set Mesh to `SphereMesh` or `BoxMesh`
3. Create a new `ShaderMaterial` resource
4. Set the Shader to `shaders/toon_piece.gdshader`
5. Adjust the `albedo` color in the material
6. Adjust `bands` (1-10) for more/less toon bands
7. Adjust `light_intensity` for brightness

#### Outline Post-Process Setup:
1. Add a `ColorRect` node as a child of the root
2. In the Inspector:
   - Set Anchors to "Full Rect" (stretch to fill)
   - Set Color to fully transparent: `rgba(0, 0, 0, 0)`
3. Create a new `ShaderMaterial` resource
4. Set the Shader to `shaders/outline.gdshader`
5. Adjust `outline_threshold` (0.0-0.1) - lower = more sensitive
6. Adjust `outline_width` (0.5-3.0) - controls outline thickness
7. Set `outline_color` to black or your preferred outline color

#### Lighting Setup:
1. Add a `DirectionalLight3D` node
2. Rotate it to light your scene (e.g., rotation_degrees = Vector3(-45, -30, 0))
3. Adjust energy/color as needed

### 4. Optional: Pixel Art Setup Script

If you want to set resolution programmatically:
1. Add the `pixel_art_setup.gd` script to your root node
2. Adjust `target_width` and `target_height` in the inspector
3. The script will set the viewport size on ready

## Testing

1. Run your scene
2. You should see:
   - Low resolution rendering (pixelated)
   - Toon/cel-shaded objects with banded lighting
   - Black outlines around objects
   - Isometric camera view

## Troubleshooting

**No outlines appearing:**
- Make sure `Rendering Method` is set to `Forward Plus` in Project Settings > Rendering > Renderer
- Check that the ColorRect is set to fullscreen and has the outline shader material
- Adjust `outline_threshold` to a lower value (more sensitive)
- The outline shader needs access to depth/normal textures - if it still doesn't work, we may need to use a different approach (like a viewport with depth enabled)

**Objects too dark/bright:**
- Adjust `light_intensity` in the toon shader material
- Adjust `bands` for more/less lighting steps
- Add more lights or adjust existing light energy

**Resolution not pixelated:**
- Make sure viewport size is set to low resolution in Project Settings
- Check that Stretch Mode is set correctly
- Verify the pixel_art_setup script is running if you're using it

## Next Steps

Once the shaders are working:
1. Create 3D chess piece models (low-poly works best)
2. Apply the toon shader to all pieces
3. Set up the chess board
4. Integrate your chess logic code
