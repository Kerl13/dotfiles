# Defined in - @ line 1
function gitroot --description 'alias gitroot=cd (git rev-parse --show-toplevel)'
	cd (git rev-parse --show-toplevel) $argv;
end
