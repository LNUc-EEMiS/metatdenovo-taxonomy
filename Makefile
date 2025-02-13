MANIFEST.txt: README.md $(wildcard gtdb*)
	ls -Llh $^ | sed 's/[^ ]\+ \+[^ ]\+ \+[^ ]\+ \+[^ ]\+ \+\([^ ]\+\).* \+\([^ ]\+\)/\2 (\1)/' > $@
