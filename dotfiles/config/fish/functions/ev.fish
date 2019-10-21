function ev
	evince $argv >/dev/null 2>&1 &;
  disown
end
