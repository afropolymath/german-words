build: src/*
	@echo "Building files..."
	@elm make src/Main.elm --output=public/js/app.js