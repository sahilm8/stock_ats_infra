CREATE DATABASE IF NOT EXISTS stock_auth_db;
CREATE DATABASE IF NOT EXISTS stock_portfolio_db;

CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON stock_auth_db.* TO 'admin'@'%';
GRANT ALL PRIVILEGES ON stock_portfolio_db.* TO 'admin'@'%';
FLUSH PRIVILEGES;

USE stock_auth_db;

CREATE TABLE IF NOT EXISTS auth_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

USE stock_portfolio_db;

CREATE TABLE IF NOT EXISTS portfolio_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS portfolio_portfolio (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    currency VARCHAR(255) NOT NULL,
    amount DECIMAL(10,4) NOT NULL,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES portfolio_user(id)
);

CREATE TABLE IF NOT EXISTS portfolio_transaction (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    currency VARCHAR(255) NOT NULL,
    amount DECIMAL(10,4) NOT NULL,
    user_id BIGINT NOT NULL,
    portfolio_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES portfolio_user(id),
    FOREIGN KEY (portfolio_id) REFERENCES portfolio_portfolio(id)
);

CREATE TABLE IF NOT EXISTS portfolio_stock (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(255) NOT NULL,
    currency VARCHAR(255) NOT NULL,
    price DECIMAL(10,4) NOT NULL,
    open DECIMAL(10,4) NOT NULL,
    high DECIMAL(10,4) NOT NULL,
    low DECIMAL(10,4) NOT NULL,
    close DECIMAL(10,4) NOT NULL,
    volume DECIMAL(10,4) NOT NULL,
    portfolio_id BIGINT NOT NULL,
    transaction_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (portfolio_id) REFERENCES portfolio_portfolio(id),
    FOREIGN KEY (transaction_id) REFERENCES portfolio_transaction(id)
);

CREATE INDEX idx_portfolio_user_id ON portfolio_portfolio(user_id);
CREATE INDEX idx_transaction_user_id ON portfolio_transaction(user_id);
CREATE INDEX idx_transaction_portfolio_id ON portfolio_transaction(portfolio_id);
CREATE INDEX idx_stock_portfolio_id ON portfolio_stock(portfolio_id);
CREATE INDEX idx_stock_transaction_id ON portfolio_stock(transaction_id);
