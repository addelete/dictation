isar_build:
	@echo "Building ISAR..."
	@flutter pub run build_runner build
	@echo "Done."
icons_launcher:
	@echo "Generating icons launcher..."
	@flutter pub run icons_launcher:create
	@echo "Done."
