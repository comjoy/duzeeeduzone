<?php
$host = "localhost";
$username = "dujeeeduzo_user";
$password = "{~9QpVjo7g##zd0J";
$database = "dujeeeduzo_admin";

$mysqli = new mysqli($host, $username, $password, $database);

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

$mysqli->set_charset("utf8mb4");
?>