#!/bin/sh

LOCAL_PATH=`pwd`

echo -e "\e[43mCurrent path is '$LOCAL_PATH'\e[0m\nStart building..."

# Check build tool
command -v git >/dev/null 2>&1 || { echo "git is required but it's not installed.  Aborting." >&2; exit 1; }
command -v composer >/dev/null 2>&1 || { echo "composer is required but it's not installed.  Aborting." >&2; exit 1; }
command -v php >/dev/null 2>&1 || { echo "php is required but it's not installed.  Aborting." >&2; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "unzip is required but it's not installed.  Aborting." >&2; exit 1; }
command -v zip >/dev/null 2>&1 || { echo "zip is required but it's not installed.  Aborting." >&2; exit 1; }

# Update source code CodeIgniter Framework
echo -e "\e[44m[1] Updating CodeIgniter repo...\e[0m"
rm -rf "include/CodeIgniter/"
git submodule update --init --remote --rebase
if [ $? -ne 0 ]; then
	echo -e "\e[91mERROR during git execution, aborted!"
	exit 1
fi

echo -e "\e[44m[2] Remove unneeded file...\e[0m"
codeigniter=`cat "include/CodeIgniter/.git"`
rm -rf "include/CodeIgniter/"
mkdir -p "include/CodeIgniter/"
echo $codeigniter > "include/CodeIgniter/.git"
cd "include/CodeIgniter/"
git checkout "system/"
git checkout "tests/"
cd $LOCAL_PATH

# Auto test
echo -e "\e[44m[3] Auto testing...\e[0m"
#pear channel-discover pear.phpunit.de
#pear channel-discover pear.symfony.com
#pear install phpunit/PHPUnit
#pear channel-discover pear.bovigo.org
#pear install bovigo/vfsStream-beta

#cd "include/CodeIgniter"
#composer install
phpunit -d zend.enable_gc=0 -d date.timezone=UTC --coverage-text --configuration "./include/CodeIgniter/tests/phpunit.xml"
phpunit -d zend.enable_gc=0 -d date.timezone=UTC --coverage-text --configuration "./include/CodeIgniter/tests/travis/mysqli.phpunit.xml"
#cd $LOCAL_PATH

# Language pack for CodeIgniter
echo -e "\e[44m[4] Installing language pack...\e[0m"
wget --no-check-certificate "https://github.com/bcit-ci/codeigniter3-translations/archive/develop.zip" -O "cache/ci-language-pack.zip"
unzip -j -o "cache/ci-language-pack.zip" -d "include/CodeIgniter/system/language/vietnamese/" "codeigniter3-translations-develop/language/vietnamese/*"
rm "cache/ci-language-pack.zip"

# Update Composer components
echo -e "\e[44m[5] Updating Composer components...\e[0m"
composer self-update
composer update -vvv
echo -e "\e[44mDone!\e[0m"