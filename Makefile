isar_build:
	@echo "Building ISAR..."
	@flutter dart run build_runner build
	@echo "Done."
icons_launcher:
	@echo "Generating icons launcher..."
	@flutter dart run icons_launcher:create
	@echo "Done."
