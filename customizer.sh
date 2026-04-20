#!/usr/bin/env bash
#
# Customizer script compatible with Bash and Zsh
# Usage: ./customizer.sh my.new.package MyNewDataModel [ApplicationName]

# exit when any command fails
set -e

if [ $# -lt 2 ]; then
   echo "Usage: $0 my.new.package MyNewDataModel [ApplicationName]" >&2
   exit 2
fi

PACKAGE=$1
DATAMODEL=$2
APPNAME=${3:-MyApplication}

# Portably handle string replacement (works in bash and zsh)
SUBDIR=$(echo "$PACKAGE" | tr '.' '/')

# Portably handle case conversion using awk
# Capitalized (first letter upper)
DATAMODEL_CAP=$(echo "$DATAMODEL" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
# Lowercase first letter
DATAMODEL_LOW_FIRST=$(echo "$DATAMODEL" | awk '{print tolower(substr($0,1,1)) substr($0,2)}')
# All lowercase
DATAMODEL_ALL_LOW=$(echo "$DATAMODEL" | awk '{print tolower($0)}')

OLD_PACKAGE="me.ashishekka.machine.template"
OLD_SUBDIR="me/ashishekka/machine/template"

# Detect OS for sed differences (macOS/BSD vs Linux)
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_INPLACE=(sed -i '')
else
  SED_INPLACE=(sed -i)
fi

for n in $(find . -type d \( -path '*/src/androidTest' -or -path '*/src/main' -or -path '*/src/test' \) )
do
  if [ -d "$n/java/$OLD_SUBDIR" ]; then
    echo "Creating $n/java/$SUBDIR"
    mkdir -p "$n/java/$SUBDIR"
    echo "Moving files from $OLD_PACKAGE to $PACKAGE"
    mv "$n/java/$OLD_SUBDIR"/* "$n/java/$SUBDIR/"
    # Cleanup empty old directories
    rm -rf "$n/java/me/ashishekka"
  fi
done

# Rename package and imports
echo "Renaming packages and imports to $PACKAGE"
find ./ -type f -name "*.kt" -exec "${SED_INPLACE[@]}" "s/package $OLD_PACKAGE/package $PACKAGE/g" {} \;
find ./ -type f -name "*.kt" -exec "${SED_INPLACE[@]}" "s/import $OLD_PACKAGE/import $PACKAGE/g" {} \;

# Gradle files
echo "Updating Gradle files"
find ./ -type f -name "*.kts" -exec "${SED_INPLACE[@]}" "s/$OLD_PACKAGE/$PACKAGE/g" {} \;

# Rename model in code
echo "Renaming model occurrences ($DATAMODEL_CAP, $DATAMODEL_LOW_FIRST, $DATAMODEL_ALL_LOW)"
find ./ -type f -name "*.kt" -exec "${SED_INPLACE[@]}" "s/MyModel/$DATAMODEL_CAP/g" {} \;
find ./ -type f -name "*.kt" -exec "${SED_INPLACE[@]}" "s/myModel/$DATAMODEL_LOW_FIRST/g" {} \;
find ./ -type f -name "*.kt*" -exec "${SED_INPLACE[@]}" "s/mymodel/$DATAMODEL_ALL_LOW/g" {} \;

# Rename files
echo "Renaming files with MyModel to $DATAMODEL_CAP"
find ./ -name "*MyModel*.kt" | while read -r file; do
    new_file=$(echo "$file" | sed "s/MyModel/$DATAMODEL_CAP/g")
    mv "$file" "$new_file"
done

# Rename modules
find ./ -name "*-mymodel" -type d | while read -r dir; do
    new_dir=$(echo "$dir" | sed "s/mymodel/$DATAMODEL_ALL_LOW/g")
    mv "$dir" "$new_dir"
done

# Rename directories
find ./ -name "mymodel" -type d | while read -r dir; do
    new_dir=$(echo "$dir" | sed "s/mymodel/$DATAMODEL_ALL_LOW/g")
    mv "$dir" "$new_dir"
done

# Rename app
if [ "$APPNAME" != "MyApplication" ]; then
    echo "Renaming app to $APPNAME"
    find ./ -type f \( -name "MyApplication.kt" -or -name "settings.gradle.kts" -or -name "*.xml" \) -exec "${SED_INPLACE[@]}" "s/MyApplication/$APPNAME/g" {} \;
    find ./ -name "MyApplication.kt" | while read -r file; do
        new_file=$(echo "$file" | sed "s/MyApplication/$APPNAME/g")
        mv "$file" "$new_file"
    done
fi

# Cleanup
echo "Removing additional files"
rm -rf .google/
rm -rf .github/
rm -rf CONTRIBUTING.md LICENSE customizer.sh

echo "Project customized successfully for $PACKAGE ($APPNAME)!"
