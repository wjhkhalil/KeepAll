"""Render the 1024×500 LifeKeeper Play Store feature graphic."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'assets/store/lifekeeper_feature_graphic_1024x500.png'
FONT = ROOT / 'assets/fonts'

def font(name, size): return ImageFont.truetype(FONT / name, size)
bold = lambda n: font('Nunito-Bold.ttf', n)
extra = lambda n: font('Nunito-ExtraBold.ttf', n)

im = Image.new('RGB', (1024, 500), '#FEFAEA')
d = ImageDraw.Draw(im)
d.ellipse((786, -203, 1142, 153), fill='#DCEBCB')
d.ellipse((335, 335, 675, 675), fill='#F7DEBB')
d.ellipse((54, 44, 155, 145), fill='#D4E7C3')
d.ellipse((906, 352, 993, 439), fill='#F5D4A6')

def rr(box, radius, fill, outline=None, width=1): d.rounded_rectangle(box, radius, fill, outline, width)
def txt(xy, value, f, fill): d.text(xy, value, font=f, fill=fill)

rr((68, 63, 180, 175), 31, '#FEFAEA')
icon = Image.open(ROOT / 'assets/Icon/lifekeeper_app_icon_512x512_original_background.png').convert('RGBA').resize((100,100), Image.Resampling.LANCZOS)
im.paste(icon, (74, 69), icon)
txt((204, 67), 'LifeKeeper', extra(43), '#285D4A')
txt((207, 119), 'YOUR EVERYDAY THINGS, ALL IN ONE PEACEFUL PLACE', bold(17), '#5F756A')
txt((69, 186), 'Keep your day', extra(47), '#234D3D')
txt((69, 237), 'beautifully organised.', extra(47), '#234D3D')
txt((72, 303), 'Tasks, reminders, lists, receipts and documents —', bold(20), '#62776D')
txt((72, 332), 'all calmly kept in one place.', bold(20), '#62776D')
rr((68,389,203,441),26,'#D9EBCB'); d.ellipse((81,402,107,428),fill='#4F8667'); d.line((88,415,92,419,100,410),fill='white',width=3,joint='curve'); txt((115,401),'TASKS',bold(16),'#315E4C')
rr((215,389,359,441),26,'#F7DFB3'); txt((249,401),'🛒',font('Nunito-Regular.ttf',18),'#A87635'); txt((273,401),'LISTS',bold(16),'#8B6530')

# Phone and app preview.
rr((657,91,927,469),36,'#335E50'); rr((665,102,919,456),27,'#F8FAF0')
rr((756,112,828,119),4,'#B9C7BD')
txt((692,135),'Good morning, Sara',extra(22),'#254D3E'); txt((693,168),'TUESDAY, 24 SEPTEMBER',bold(12),'#779083')
rr((682,205,902,367),19,'#E4F0D9'); txt((699,220),'Upcoming tasks',extra(16),'#315C4B')
for y, color, title, sub in [(266,'#4E896A','Pick up medicine','Today · 18:00'),(323,'#F0A765','Pay electricity bill','Tomorrow')]:
    d.ellipse((693,y-11,715,y+11),fill=color); d.line((699,y,703,y+4,710,y-5),fill='white',width=2,joint='curve')
    txt((724,y-12),title,bold(14),'#335E50'); txt((724,y+4),sub,bold(11),'#7C9787')
d.line((699,298,885,298),fill='#C8DCC3',width=1)
rr((682,385,786,429),14,'#F9E3C5'); txt((702,397),'Shopping',bold(13),'#916D3F')
rr((796,385,902,429),14,'#DFEBDD'); txt((817,397),'Documents',bold(13),'#466D58')

OUT.parent.mkdir(parents=True, exist_ok=True)
im.save(OUT, 'PNG', optimize=True)
print(OUT)
