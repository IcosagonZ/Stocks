run:
	cargo run

build-linux:
	cargo build --release

build-windows:
	cargo build --release --target x86_64-pc-windows-gnu

build-android:
	export ANDROID_HOME=/media/rohan/Development/Studio/sdk/
	export ANDROID_NDK_ROOT=/media/rohan/Development/Studio/sdk/ndk/28.0.12433566/
	cargo apk build --target aarch64-linux-android --lib
