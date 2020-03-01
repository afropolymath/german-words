build: src/*
	@echo "Building files..."
	@elm make src/Main.elm --optimize --output=docs/js/app.js
	# @uglifyjs docs/js/app.js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | uglifyjs --mangle --output=docs/js/app.min.js
	# @echo "Initial size: $(cat $js | wc -c) bytes  ($js)"
	# @echo "Minified size:$(cat $min | wc -c) bytes  ($min)"
	# @echo "Gzipped size: $(cat $min | gzip -c | wc -c) bytes"