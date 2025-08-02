#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

//use std::error::Error;

use std::rc::Rc;
use std::cell::RefCell;

use reqwest::Error;
use serde::Deserialize;

use slint::{VecModel, ModelRc, StandardListViewItem};

slint::include_modules!();

#[derive(Debug, Deserialize)]
struct FinnhubQuote
{
    c: f64, // current price
    h: f64,
    l: f64,
    //o: f64,
    //pc: f64,
    t: u64,
}

async fn stock_fetch(ticker: &str, api_key: &str) -> Result<FinnhubQuote, Error>
{
    println!("STOCK: Fetching data for {}", ticker);

    let stock_url = format!(
        "https://finnhub.io/api/v1/quote?symbol={}&token={}",
        ticker,
        api_key
    );

    let stock_respose = reqwest::get(&stock_url).await?.json::<FinnhubQuote>().await?;

    Ok(stock_respose)
}

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

async fn update_clicked(stock_rows: &Rc<RefCell<Vec<Vec<String>>>>, stock_model: &Rc<VecModel<ModelRc<StandardListViewItem>>>) -> Result<bool,Error>
{

    println!("APP: Update requested");

    let stock_api_key = "d26pr0pr01qvrairjo80d26pr0pr01qvrairjo8g";

    let mut stock_price = 0.00;
    let mut stock_high = 0.00;
    let mut stock_low = 0.00;
    let mut stock_time: u64 = 0;

    let mut rows = stock_rows.borrow_mut();
    if !rows.is_empty()
    {
        for row in rows.iter_mut()
        {
            let row_ticker = &row[0];
            //let row_price = &row[1];
            //let row_change = &row[2];

            match stock_fetch(row_ticker, stock_api_key).await{
                Ok(stock_data)=>
                {
                    println!("STOCKS[SUCCESS]: Price of {} is {}", row_ticker, stock_data.c);
                    stock_price = stock_data.c;
                    stock_high = stock_data.h;
                    stock_low = stock_data.l;
                    stock_time = stock_data.t;
                },
                Err(e)=>
                {
                    println!("STOCKS[Error]: {}", e)
                },
            }

            row[1] =  stock_price.to_string();
            row[2] =  stock_high.to_string();
            row[3] =  stock_low.to_string();
        }
        update_model(&rows, stock_model);
    }

    println!("APP: Update success");
    println!("APP: Update time was {}", stock_time);

    Ok(true)
}

fn add_default(stock_rows: &Rc<RefCell<Vec<Vec<String>>>>, stock_model: &Rc<VecModel<ModelRc<StandardListViewItem>>>)
{
    println!("APP: Add default requested");

    let mut rows = stock_rows.borrow_mut();
    rows.clear();
    rows.push(vec!["MSFT".to_string(), "0".to_string(), "0".to_string(), "0".to_string()]);
    rows.push(vec!["AAPL".to_string(), "0".to_string(), "0".to_string(), "0".to_string()]);
    rows.push(vec!["AMZN".to_string(), "0".to_string(), "0".to_string(), "0".to_string()]);

    update_model(&rows, stock_model);
}

fn add_clicked(stock_ticker: String, stock_rows: &Rc<RefCell<Vec<Vec<String>>>>, stock_model: &Rc<VecModel<ModelRc<StandardListViewItem>>>)
{
    println!("APP: Add requested");

    let mut rows = stock_rows.borrow_mut();
    rows.push(vec![stock_ticker, "0".to_string(), "0".to_string(), "0".to_string()]);
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
#[tokio::main]
async fn main() -> Result<(), slint::PlatformError>
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
        app_ui.on_update_clicked(
        {
            let stock_rows = stock_rows.clone();
            let stock_model = stock_model.clone();
            move || {
                    let stock_rows = stock_rows.clone();
                    let stock_model = stock_model.clone();
                    #[allow(unused_must_use)]
                    slint::spawn_local(async move
                    {
                        match update_clicked(&stock_rows, &stock_model).await
                        {
                            Ok(true)=>
                            {
                            },
                            Ok(false)=>
                            {
                            },
                            Err(e)=>
                            {
                                println!("APP: Error calling update clicked");
                                println!("APP[ERROR]: {}", e);
                            }
                        }
                    });
            }
        });
    }

    /*
    {
        let stock_rows = stock_rows.clone();
        let stock_model = stock_model.clone();
        app_ui.on_add_clicked(move || add_clicked(&stock_rows, &stock_model));
    }*/

    {
        let stock_rows = stock_rows.clone();
        let stock_model = stock_model.clone();
        app_ui.on_remove_clicked(move || remove_clicked(&stock_rows, &stock_model));
    }

    app_ui.on_add_return(move |text|
    {
        let stock_rows = stock_rows.clone();
        let stock_model = stock_model.clone();
        println!("APP: Ticker to add {}", text);
        add_clicked(text.to_string(), &stock_rows, &stock_model);
    });


    app_ui.run()?;

    Ok(())
}
