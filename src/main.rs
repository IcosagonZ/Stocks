mod app_main;

#[cfg(not(target_os = "android"))]
#[tokio::main]
async fn main() -> Result<(), slint::PlatformError>
{
    app_main::app_main().await;
}
