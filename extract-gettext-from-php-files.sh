# Ref: https://gist.github.com/anjan-virtism/f9121542717f53b3bbb6043c31783aa2#file-extract-gettext-from-php-files-sh
# find /var/www/frontac/ \( -name "*.php" -o -name "*.inc" \) ! -path "./tmp/*" | sort -bdf | xargs xgettext --default-domain=myapp --output=myapp3.pot --language=PHP --indent --no-wrap --sort-output --omit-header

find files/ \( -name "*.php" -o -name "*.inc" \) ! -path "./tmp/*" | \
sort -bdf | \
xargs xgettext \
--default-domain=myapp \
--output=myapp.pot \
--language=PHP \
--indent \
--no-wrap \
--sort-output
# \
# --omit-header