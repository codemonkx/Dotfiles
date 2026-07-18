import os
from PIL import Image, ImageDraw

def crop_to_circle_with_border(src_path, dest_path, border_color="#8e00d1", border_width=12):
    # Open image and convert to RGBA
    img = Image.open(src_path).convert("RGBA")
    
    # Crop to square
    size = min(img.size)
    img = img.crop(((img.width - size) // 2,
                    (img.height - size) // 2,
                    (img.width + size) // 2,
                    (img.height + size) // 2))
    
    # Resize to standard high quality 500x500
    output_size = (500, 500)
    img = img.resize(output_size, Image.Resampling.LANCZOS)
    
    # Create mask for circular crop
    mask = Image.new("L", output_size, 0)
    draw_mask = ImageDraw.Draw(mask)
    
    # Draw filled circle (contracted by border width to stay sharp)
    margin = border_width // 2
    draw_mask.ellipse((margin, margin, output_size[0] - margin, output_size[1] - margin), fill=255)
    
    # Apply circular mask
    output = Image.new("RGBA", output_size, (0, 0, 0, 0))
    output.paste(img, (0, 0), mask=mask)
    
    # Draw circular outline border
    if border_width > 0:
        draw_border = ImageDraw.Draw(output)
        draw_border.ellipse((margin, margin, output_size[0] - margin, output_size[1] - margin), 
                             outline=border_color, width=border_width)
    
    # Save the output PNG
    output.save(dest_path, "PNG")
    print(f"Successfully generated circular PFP at {dest_path}")

if __name__ == "__main__":
    src = "/home/nx02/assets/pfp_original.png"
    dest = "/home/nx02/assets/pfp.png"
    crop_to_circle_with_border(src, dest, border_color="#8e00d1", border_width=0)
