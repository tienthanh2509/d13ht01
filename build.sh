#!/bin/sh

# Check build tool
command -v git >/dev/null 2>&1 || { echo "git is required but it's not installed.  Aborting." >&2; exit 1; }
command -v composer >/dev/null 2>&1 || { echo "composer is required but it's not installed.  Aborting." >&2; exit 1; }
command -v php >/dev/null 2>&1 || { echo "php is required but it's not installed.  Aborting." >&2; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "unzip is required but it's not installed.  Aborting." >&2; exit 1; }
command -v zip >/dev/null 2>&1 || { echo "zip is required but it's not installed.  Aborting." >&2; exit 1; }

# Update source code CodeIgniter Framework
echo -e "\e[44mUpdating CodeIgniter repo...\e[0m"
git submodule update --init --remote #--rebase
if [ $? -ne 0 ]; then
	echo -e "\e[91mERROR during git execution, aborted!\e[0m"
	exit 1
fi

# Language pack for CodeIgniter
echo -e "\e[44mInstalling language pack...\e[0m"
wget --no-check-certificate "https://github.com/bcit-ci/codeigniter3-translations/archive/develop.zip" -O "cache/ci-language-pack.zip"
unzip -j -o "cache/ci-language-pack.zip" -d "include/CodeIgniter/system/language/vietnamese/" "codeigniter3-translations-develop/language/vietnamese/*"
rm "cache/ci-language-pack.zip"

# Update Composer components
echo -e "\e[44mUpdating Composer components...\e[0m"
composer self-update
composer update

echo -e "\e[44mDone!\e[0m"