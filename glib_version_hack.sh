#Programatically do the steps outlined at
# http://www.lightofdawn.org/wiki/wiki.cgi/NewAppsOnOldGlibc
# - sets GLIBC 2_14 to weak to run targets on older libcs.

set -e
if [ ! -x $1 ]; then
    exit -1
fi

SECTION_OFFSET=$(printf "%d" $(readelf -V $1    |grep '.gnu.version_r' -A1 | grep 'Offset'    | awk '{print $4}'))
GLIB_2_14_OFFSET=$(printf "%d" $(readelf -V $1 | grep 'Name: GLIBC_2.14'   | awk '{print $1}' | tr -d :         ))

INDEX=$(( SECTION_OFFSET + GLIB_2_14_OFFSET + 4 + 1 ))

echo "Going to patch $1: "
echo ".gnu_version_r table (@ $(printf '%0X' $SECTION_OFFSET))"
echo "----> GLIBC_2.14 (@ $(printf '%0X' $GLIB_2_14_OFFSET))"
echo "Offset $(printf '%0X' $INDEX)"

xxd -c 1 -p $1 | awk "{if (NR==$INDEX)\$0=\"02\"; print;}" | xxd -r -c 1 -p  > $1.patched