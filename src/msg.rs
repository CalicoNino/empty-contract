use cosmwasm_std::{Addr, Decimal};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, PartialEq, Debug, Clone)]
pub struct InstantiateMsg {
    pub admins: Vec<String>,
}

#[derive(Serialize, Deserialize, PartialEq, Debug, Clone)]
pub struct GreetResp {
    pub message: String,
    pub price: QueryPriceResponse,
}

#[derive(Serialize, Deserialize, PartialEq, Debug, Clone)]
pub struct AdminsListResp {
    pub admins: Vec<Addr>,
}

#[derive(Serialize, Deserialize, PartialEq, Debug, Clone)]
pub enum QueryMsg {
    Greet {},
    AdminsList {},
}

#[derive(Serialize, Deserialize, PartialEq, Debug, Clone)]
pub enum ExecuteMsg {
    AddMembers { admins: Vec<String> },
    Leave {},
}

#[derive(Serialize, Deserialize, PartialEq, Debug, Clone)]
pub enum OracleQueryMsg {
    Price { pair_id: String },
    Prices {},
    RawPrices { pair_id: String },
    Oracles {},
    Markets {},
}
#[derive(Serialize, Deserialize, PartialEq, Debug, Clone)]
pub struct QueryPriceResponse {
    pub current_price: CurrentPrice,
}

#[derive(Serialize, Deserialize, PartialEq, Debug, Clone)]
pub struct CurrentPrice {
    pub pair_id: String,
    pub price: Decimal,
}
