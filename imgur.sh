# Move to folder where to store your images on your hosting
cd /bigspace/media

# remove previous lists
rm list.txt dl.txt

echo "Get all files in list.txt"

cd /var/www/mywebsite

# get all imgur links in all posts
for i in `wp post list --format=ids`; do wp post get $i |grep imgur.com >> /bigspace/media/media/list.txt;done

echo "Renaming.."

cd /bigspace/media/media

# rename i.imgur to imgur so all links are the same
sed -i 's/i.imgur/imgur/g' list.txt

echo "Create dl.txt"

# strip everything but the link and put it in a downloads txt file
for i in `cat list.txt`;do echo $i | grep -o -P '(?<=src=").*(?=.)' >> dl.txt;done

echo "Downloading.."

# download all files, of it was not a success add to fail txt
for i in `cat dl.txt`; do
if [ ! -f "`echo $i|cut -f4 -d '/'`" ]; then
wget -q $i && echo "SUCCESS - $i" || echo $i >> dl_fail.txt;
sleep 2;
else
echo "$i SKIPPED";
fi
done
