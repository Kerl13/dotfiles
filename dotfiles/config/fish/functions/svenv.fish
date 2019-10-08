# Defined in - @ line 1
function svenv --description 'alias svenv=source venv/bin/activate.fish'
	source venv/bin/activate.fish $argv;
end
