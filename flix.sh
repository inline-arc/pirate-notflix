#!/usr/bin/env bash

input() {
	printf "Search Torrent: " && read -r name || name="$1"
	get_url
}

get_url() {
	search=$(echo "${name}" | sed 's/ /\%20/g')
	magnet=$(curl -s "$baseurl/search/${search}/1/99/200" | grep -Eo "magnet:\?xt=urn:btih:[a-zA-Z0-9]*" | head -n 1)
	choose
}

stream() {
	peerflix -k "${magnet}"
}

download() {
	peerflix "${magnet}"
}

choose() {
	choice="$( printf "stream\ndownload" | fzf)"
	[ "$choice" = "stream" ] && stream
	[ "$choice" = "download" ] && download
}

baseurl=$(curl -s -L -o /dev/null -w "%{url_effective}\n" https://thepiratebay.party)
name=$(printf "$*")

# checks if name variable is empty or not
[ -n "$name" ] && get_url
[ ! -n "$name" ] && input

