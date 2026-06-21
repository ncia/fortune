Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile('assets\images\ic_diary.png')
$bmp = New-Object System.Drawing.Bitmap 138, 138
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.DrawImage($img, 0, 0, 138, 138)
$bmp.Save('assets\images\ic_diary2.png', [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
$img.Dispose()
