#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

//use std::error::Error;

use std::rc::Rc;
use std::cell::RefCell;

use slint::{VecModel, ModelRc, StandardListViewItem};

slint::include_modules!();

fn update_model(stock_rows: &Vec<Vec<String>>, stock_model: &Rc<VecModel<ModelRc<StandardListViewItem>>>)
{
    println!("APP: Model update requested");

    stock_model.clear();

    for row in stock_rows
    {
        let inner_vec: Vec<StandardListViewItem> = row.into_iter()
        .map(|cell|StandardListViewItem::from(cell.as_str()))
        .collect();
        let inner_model = ModelRc::from(Rc::new(VecModel::from(inner_vec)));
        stock_model.push(inner_model);
    }
}

fn update_clicked(stock_rows: &Rc<RefCell<Vec<Vec<String>>>>, stock_model: &Rc<VecModel<ModelRc<StandardListViewItem>>>)
{
    println!("APP: Update requested");
}

fn add_default(stock_rows: &Rc<RefCell<Vec<Vec<String>>>>, stock_model: &Rc<VecModel<ModelRc<StandardListViewItem>>>)
{
    println!("APP: Add default requested");

    let mut rows = stock_rows.borrow_mut();
    rows.clear();
    rows.push(vec!["BPCL".to_string(), "400".to_string(), "0".to_string()]);
    rows.push(vec!["AAPL".to_string(), "100".to_string(), "0".to_string()]);

    update_model(&rows, stock_model);
}

fn add_clicked(stock_rows: &Rc<RefCell<Vec<Vec<String>>>>, stock_model: &Rc<VecModel<ModelRc<StandardListViewItem>>>)
{
    println!("APP: Add requested");

    let mut rows = stock_rows.borrow_mut();
    rows.push(vec!["MSFT".to_string(), "400".to_string(), "0".to_string()]);
    update_model(&rows, stock_model);
}

fn remove_clicked(stock_rows: &Rc<RefCell<Vec<Vec<String>>>>, stock_model: &Rc<VecModel<ModelRc<StandardListViewItem>>>)
{
    println!("APP: Remove requested");

    let mut rows = stock_rows.borrow_mut();
    if !rows.is_empty()
    {
        rows.pop();
        update_model(&rows, stock_model);
    }
}

// Main program
fn main() -> Result<(), slint::PlatformError>
{
    let app_ui = AppWindow::new()?;

    let stock_rows = Rc::new(RefCell::new(Vec::<Vec<String>>::new()));
    let stock_model = Rc::new(VecModel::from(Vec::<ModelRc<StandardListViewItem>>::new()));

    app_ui.set_stocks(ModelRc::from(stock_model.clone()));

    {
        let stock_rows = stock_rows.clone();
        let stock_model = stock_model.clone();
        add_default(&stock_rows, &stock_model);
    }

    //app_ui.on_update_clicked(|| update_clicked());
    {
        let stock_rows = stock_rows.clone();
        let stock_model = stock_model.clone();
        app_ui.on_update_clicked(move || update_clicked(&stock_rows, &stock_model));
    }

    {
        let stock_rows = stock_rows.clone();
        let stock_model = stock_model.clone();
        app_ui.on_add_clicked(move || add_clicked(&stock_rows, &stock_model));
    }

    {
        let stock_rows = stock_rows.clone();
        let stock_model = stock_model.clone();
        app_ui.on_remove_clicked(move || remove_clicked(&stock_rows, &stock_model));
    }

    app_ui.on_add_return(move |text|
    {
        println!("APP: Ticker to add {}", text);
    });


    app_ui.run()?;

    Ok(())
}
