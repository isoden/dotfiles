alias g='git'
alias d='docker'
# see https://scrapbox.io/takker/clip.exe%E3%81%A7%E6%97%A5%E6%9C%AC%E8%AA%9E%E3%82%92%E3%82%B3%E3%83%94%E3%83%BC%E3%81%99%E3%82%8B%E3%81%A8%E6%96%87%E5%AD%97%E5%8C%96%E3%81%91%E3%81%99%E3%82%8B%E3%82%88%E3%81%86%E3%81%AB%E3%81%AA%E3%81%A3%E3%81%9F
# clip.exe に日本語を渡すと文字化けするようになった。 対策として文字コードを sjis に変換してから clip.exe に渡す。
alias pbcopy='iconv -f utf8 -t sjis | /mnt/c/Windows/system32/clip.exe'
alias reboot='exec $SHELL -l'
