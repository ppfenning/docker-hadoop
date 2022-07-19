cd crime-stats || exit
echo "Get data from kaggle..."
kaggle datasets download -d currie32/crimes-in-chicago
echo ""
echo "Unzip kaggle set..."
unzip crimes-in-chicago.zip
echo ""
echo "Combine CSVs..."
awk '(NR == 1) || (FNR > 1)' ./*.csv > Chicago_Crimes_Dirty.csv
echo ""
echo "Removing null years..."
awk '!($19 == "")' Chicago_Crimes_Dirty.csv > Chicago_Crimes.csv
echo ""
echo "Zipping single csv..."
zip Chicago_Crimes.zip Chicago_Crimes.csv
echo ""
echo "Removing unwanted data..."
rm ./*.csv crimes-in-chicago.zip
echo ""