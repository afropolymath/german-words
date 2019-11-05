build: src/*
	@echo "Building files..."
	@elm make src/Main.elm --output=docs/js/app.js