install:
	flutter pub get && cd rust && cargo update && cargo bin --install

frbc.gen:
	cd rust && cargo frbc generate
	
frbc.gen.watch:
	cd rust && cargo frbc generate --watch

flutter.dev.macos:
	flutter run -d macos
	
flutter.build.macos:
	cd rust && cargo check && cargo frbc generate && cd .. && flutter build -d macos --release