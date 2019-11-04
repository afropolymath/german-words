build: src/*
	@echo "Building files..."
	@elm make src/Main.elm --output=dist/app.js