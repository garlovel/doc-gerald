#! /bin/bash
# set external display on right or left

PRI="LVDS1"
PRI_RH=1024
PRI_RV=600

SEC="VGA1"
SEC_RH=1920
SEC_RV=1280

SIDE="R"

# NOTE: xrandr cannot pipe its output, and kdialog cannot cancel a textbox
xrandr >> ~/.xrandr.txt
kdialog --textbox ~/.xrandr.txt 750 500
rm ~/.xrandr.txt
EXIT_CODE=$?
if [ ! $EXIT_CODE = 0 ]; then
  # response = 1 (cancel) or 254 (error) so exit
  exit $EXIT_CODE
fi

RESULT1=`kdialog --radiolist "aspect ratio" 1 "16:9 at right" on 2 "16:9 at left" off 3 "4:3 at right" off 4 "4:3 at left" off`
EXIT_CODE=$?
if [ ! $EXIT_CODE = 0 ]; then
  # response = 1 (cancel) or 254 (error) so exit
  echo "response was $EXIT_CODE"
  exit $EXIT_CODE
fi

case "$RESULT1" in
  1 )
    SIDE="R" ; SEC_ASPECT="16:9" ;;
  2 )
    SIDE="L" ; SEC_ASPECT="16:9" ;;
  3 )
    SIDE="R" ; SEC_ASPECT="4:3" ;;
  4 ) 
    SIDE="L" ; SEC_ASPECT="4:3" ;;
  * )
    exit
    ;;
esac

case $SEC_ASPECT in
 "4:3" )
    RESULT2=`kdialog --radiolist "display Size" 6 " 640x 480 VGA" off 5 " 800x 600 SVGA" off 4 "1024x 768 XGA" off 3 "1280x1024 SXGA" off 2 "1600x1200 UXGA" on 1 "4096x3072 4K" off` 
    EXIT_CODE=$?
    if [ ! $EXIT_CODE = 0 ]; then
      # response = 1 (cancel) or 254 (error) so exit
      echo "response was $EXIT_CODE"
      exit $EXIT_CODE
    fi
    case $RESULT2 in
      1 )
        SEC_RH=4096 ; SEC_RV=3072 ;;
      2 ) 
        SEC_RH=1600 ; SEC_RV=1200 ;;
      3 )
        SEC_RH=1280 ; SEC_RV=1024 ;;
      4 )
        SEC_RH=1024 ; SEC_RV=768 ;;
      5 )
        SEC_RH=800 ; SEC_RV=600 ;;
      6 )
        SEC_RH=640 ; SEC_RV=480 ;;
      * )
      exit ;;
    esac
    ;;
 "16:9" )
    RESULT2=`kdialog --radiolist "Display Size" 4 "1280x 768 WXGA" off 3 "1280x 720 HD720" off 2 "1920x1080 HD1080" on 1 "2048x1080 2K" off`
    EXIT_CODE=$?
    if [ ! $EXIT_CODE = 0 ]; then
      # response = 1 (cancel) or 254 (error) so exit
      echo "response was $EXIT_CODE"
      exit $EXIT_CODE
    fi
    case $RESULT2 in
      1 )
        SEC_RH=2048 ; SEC_RV=1080 ;;
      2 )
        SEC_RH=1920 ; SEC_RV=1080 ;;
      3 )
        SEC_RH=1280 ; SEC_RV=720 ;;
      4 )
        SEC_RH=1280 ; SEC_RV=768 ;;
      * )
      exit ;;
    esac  
    ;;
  * )
    exit ;;
esac

echo "side $SIDE ; aspect $ASPECTH:$ASPECTV ; monitor size $RESULT2 "

# do the math vertical placement
if [ $SEC_RV -gt $PRI_RV ]
then
  PRIPOS_V=$(($SEC_RV-$PRI_RV))
  SECPOS_V=0
else
  PRIPOS_V=0
  SECPOS_V=$(($PRI_RV-$SEC_RV))
fi
# do the math horizontal placement
case $SIDE in
  "L" )
    PRIPOS_H=$(($SEC_RH+1))
    SECPOS_H=0
    ;;
  "R" )
    PRIPOS_H=0
    SECPOS_H=$(($PRI_RH+1))
    ;;
esac

echo 'primary position '"$PRIPOS_H"x"$PRIPOS_V"' ; secondary position '"$SECPOS_H"x"$SECPOS_V"

#reset display to selected mode (must match actual specs for monitor)

xrandr --output "$PRI" --auto --pos "$PRIPOS_H"x"$PRIPOS_V" --primary --output $SEC --pos "$SECPOS_H"x"$SECPOS_V" --mode "$SEC_RH"x"$SEC_RV"

# Standard names, resolutions and aspect ratios of standard displays
# 6    VGA  640 X  480   4:3
# 5   SVGA  800 X  600   4:3
# 4    XGA 1024 X  768   4:3
# 3   SXGA 1280 X 1024   4:3
# 2   UXGA 1600 X 1200   4:3
# 1     4K 4096 X 3072   4:3
# 4   WXGA 1280 X  768  16:9
# 3  HD720 1280 X  720  16:9 -
# 2 HD1080 1920 X 1080  16:9
# 1     2K 2048 X 1080  19:9 + 
