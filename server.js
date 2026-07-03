const http = require('http');
const { Pool } = require('pg');

const port = process.env.APP_PORT || 8080;

// Cấu hình đọc kết nối DB từ file .env
const pool = new Pool({
    user: process.env.POSTGRES_USER,
    host: process.env.DB_HOST,
    database: process.env.POSTGRES_DB,
    password: process.env.POSTGRES_PASSWORD,
    port: 5432,
});

const server = http.createServer((req, res) => {
    // Trả về 200 OK cho Healthcheck của Docker
    if (req.url === '/healthz') {
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('OK');
        return;
    }

    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
        message: 'Phase 1 Exam App is running!',
        db_host_configured: process.env.DB_HOST || 'none'
    }));
});

server.listen(port, () => {
    console.log(`Server is listening on port ${port}`);
});