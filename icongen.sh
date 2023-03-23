#/bin/zsh

export PROJECT=JMeter
export ICONDIR=Contents/Resources/$PROJECT.iconset
export ORIGICON=Icon.png

mkdir $ICONDIR

# Normal screen icons
for SIZE in 16 32 64 128 256 512; do
sips -z $SIZE $SIZE $ORIGICON --out $ICONDIR/icon_${SIZE}x${SIZE}.png ;
done

# Retina display icons
for SIZE in 32 64 256 512 1024; do
sips -z $SIZE $SIZE $ORIGICON --out $ICONDIR/icon_$(expr $SIZE / 2)x$(expr $SIZE / 2)x2.png ;
done

# Make a multi-resolution Icon
iconutil -c icns $ICONDIR -o Contents/Resources/$PROJECT.icns
rm -rf $ICONDIR #it is useless now