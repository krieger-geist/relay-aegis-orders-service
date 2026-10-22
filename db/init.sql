CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY,
    item VARCHAR(80) NOT NULL,
    quantity INT NOT NULL,
    status VARCHAR(20) NOT NULL
);

INSERT INTO orders (id, item, quantity, status) VALUES
    (1, 'Keyboard', 2, 'SHIPPED'),
    (2, 'Monitor', 1, 'PENDING'),
    (3, 'Headset', 4, 'SHIPPED')
ON CONFLICT (id) DO NOTHING;
