use clipboard_rs::{Clipboard, ClipboardContext};

#[flutter_rust_bridge::frb(sync)]
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(dart_async)]
pub async fn greet_async(name: String) -> String {
    format!("Hello from async, {name}!")
}

#[flutter_rust_bridge::frb(dart_async)]
pub async fn get_content_from_clipboard() -> Result<String, String> {
    let ctx = ClipboardContext::new().map_err(|err| err.to_string())?;
    let text = ctx.get_text().map_err(|err| err.to_string())?;
    Ok(text)
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
