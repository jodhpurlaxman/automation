filename="images.txt"
while read -r line
do
#curl –silent  $
path=`echo $line | cut -c 43-`
imagename=`echo $path | rev | cut -d/ -f1 | rev `
#echo $imagename
#echo $path
DIRECTORY=`echo $path | rev | cut -d"/" -f2-  | rev `
#echo $DIRECTORY
#exit 1
if [ ! -d "$DIRECTORY" ]; then
      mkdir -p $DIRECTORY
fi
curl --silent -o $path  $line
echo "downloading: "$line ">> in to" $DIRECTORY/$imagename
done < "$filename"

