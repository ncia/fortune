from PIL import Image

def process_image():
    img = Image.open('assets/images/magic_book.jpg')
    img = img.convert("RGBA")
    
    # 1. 흰색 배경 투명화
    datas = img.getdata()
    newData = []
    tolerance = 230
    for item in datas:
        if item[0] > tolerance and item[1] > tolerance and item[2] > tolerance:
            newData.append((255, 255, 255, 0))
        else:
            newData.append(item)
    img.putdata(newData)
    
    # 2. 비율 유지하며 최대한 2048에 맞게 확대
    scale = min(2048 / img.width, 2048 / img.height)
    new_w = int(img.width * scale)
    new_h = int(img.height * scale)
    img_resized = img.resize((new_w, new_h), Image.Resampling.LANCZOS)
    
    # 3. 2048x2048 투명 배경 생성 후 정가운데 배치
    final_img = Image.new("RGBA", (2048, 2048), (0, 0, 0, 0))
    offset = ((2048 - new_w) // 2, (2048 - new_h) // 2)
    final_img.paste(img_resized, offset)
    
    # 4. 저장 (투명도를 지원하는 png로 저장)
    final_img.save('assets/images/magic_book.png')
    print("Image processed and saved to assets/images/magic_book.png")

if __name__ == '__main__':
    process_image()
