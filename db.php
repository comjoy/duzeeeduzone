<?php
$host = "localhost";
$username = "root";
$password = "";
$database = "npmlm_db";

$mysqli = new mysqli($host, $username, $password, $database);

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

$mysqli->set_charset("utf8mb4");
?>