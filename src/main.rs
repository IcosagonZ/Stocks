#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

//use std::error::Error;

slint::include_modules!();

fn update_clicked()
{
    println!("APP: Update requested");
}

// Main program
fn main() -> Result<(), slint::PlatformError>
{
    let app_ui = AppWindow::new()?;

    app_ui.on_update_clicked(|| update_clicked());


    app_ui.run()?;

    Ok(())
}
