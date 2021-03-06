set +e
PACKAGE_VERSION=$(node -p -e "require('./package.json').version")

export PATH=$(pwd)/./node_modules/.bin:$PATH
rm -rf cobscanner && mkdir cobscanner
#browserify out/cobscanner.js --require n-readlines --outfile cobscanner/cobscanner.js
cp ./out/cobscanner.js cobscanner/
cp ./out/cobscannerdata.js cobscanner/
cp ./out/consoleexternalfeatures.js cobscanner/
cp ./out/cobolglobalcache_file.js cobscanner/
cp ./out/globalcachehelper.js cobscanner/
cp ./out/cobolsymboltableeventhelper.js cobscanner/
cp ./out/iconfiguration.js cobscanner/
cp ./out/externalfeatures.js cobscanner/
cp ./out/filesourcehandler.js cobscanner/
cp ./out/cobolglobalcache.js cobscanner/
cp ./out/cobolsourcescanner.js cobscanner/
cp -r ./out/keywords cobscanner/
cd cobscanner
export npm_config_loglevel=silent
npm init -y >/dev/null
npm install lzjs
npm install n-readlines
npm install performance-now
npm version --allow-same-version $PACKAGE_VERSION
npm install
depcheck
touch fred.json
result=$(node cobscanner.js fred.json)
if [ "$result" = "Unable to load fred.json" ]; then
 echo Quick confidence test okay
else
 echo Quick confidence test failed
 echo " Result: [$result]"
 rm -f fred.json
 exit 1
fi
rm package.json package-lock.json
