#!/usr/bin/bash
# Notepad++ Edit -> EOL conversion -> Unix/OSX format
# chmod a+x xxxxx.sh

# For Git Bash here run as "sh <script_file_name>.sh"

# Example 1 create-nodejs-ts.sh
# Example 2 create-nodejs-ts.sh --no-git --no-pause

# use --no-git for first argument for none-git project and 
# --no- pause for second argumment not to wait for user input to 
# continue.

read -e -p "Nodejs Typescript Project Directory:" -i "nodejs-ts" PROJECT_DIR
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR


#<<comment
FILE=tsconfig.json
if [ -f "$FILE" ]; then
    echo "This script cannot run for existing projects."
	read -p "Press [Enter] key to exit..."	
	exit
	
else 
    echo "Creating Project..."

fi
#comment

git init
npx gitignore node
npm init -y
git add .
git commit -m "Initial Commit"
npm install --save-dev typescript ts-node nodemon tslib
npm install --save-dev @types/jest @types/node 
npx tsc --init
mv tsconfig.json tsconfig.generated.json
read -r -d '' VAR << EOM
{
  "compilerOptions": {
    "module": "CommonJS",
    "outDir": "./dist",
    "rootDir": "src",
    "target": "es6",
    "lib": [
      "es6",
      "dom",
      "dom.iterable",
      "esnext"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "sourceMap": true,
    "jsx": "react",
    "moduleResolution": "node",
    "forceConsistentCasingInFileNames": true,
    "noImplicitReturns": true,
    "noImplicitThis": true,
    "noImplicitAny": true,
    "importHelpers": true,
    "strictNullChecks": true,
    "suppressImplicitAnyIndexErrors": true,
    "noUnusedLocals": false,
    "declaration": true,
    "declarationMap": true,
    "allowSyntheticDefaultImports": true,
     "experimentalDecorators": true
  },
  "exclude": [
    "dist",
    "node_modules",
    "build",
    "scripts",
    "acceptance-tests",
    "webpack",
    "jest",
    "src/setupTests.ts"
  ]
}
EOM

# setting target as es6 helps to support es6 code
# setting declaration true generates corresponding '.d.ts' file
# setting sourceMap true generates corresponding '.map' file
# outDir redirects output structure to the directory
# rootDir specifies the root directory of input files
# setting strict true enables all strict type-checking options

echo "$VAR" > tsconfig.json


# NestJS 3rd party modules; package.json > type="commonjs", 
# tsconfig.json module="CommonJS"

jq '.type = "commonjs"' package.json > "tmp" && mv "tmp" package.json


jq '.scripts.start = "echo This is a library project. It wont be hosted"' package.json > "tmp" && mv "tmp" package.json
jq '.scripts.build = "tsc"' package.json > "tmp" && mv "tmp" package.json
jq '.scripts.tsc = "tsc"' package.json > "tmp" && mv "tmp" package.json
jq '.main = "./dist/index.js"' package.json > "tmp" && mv "tmp" package.json
jq '.types = "./dist/types.d.ts"' package.json > "tmp" && mv "tmp" package.json


mkdir -p src
cd src

echo 'export * from "./index";' > types.ts

read -r -d '' INDEXTS << EOM
export * from "./ex";
EOM
echo "$INDEXTS" > index.ts



read -r -d '' EX << EOM
export class ExDto {
  field1: string;
  field2: string;
}
EOM
echo "$EX" > ex.ts

cd ..

if [ $1 == "--no-git" ]; then 
	# Remove git directory
	rm -rf .git
else
	git add .
	git commit -m "Configuration Commit"
fi

cd ..

if [ $2 == "--no-pause" ]; then 
# Dont pause, another script is called this script, and operation might continue without waiting for user input.
	echo "Completed"
else
	read -p "Press [Enter] key to exit..."
fi


