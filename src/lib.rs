mod app_main;

#[cfg(target_os = "android")]
#[no_mangle]
pub fn android_main(app: slint::android::AndroidApp)
{
    slint::android::init(app).unwrap();

    smol::block_on(async {
        match app_main::app_main().await {
            Ok(_) => (),
            Err(e) => eprintln!("Error in app_main: {:?}", e),
        }
    });
}
