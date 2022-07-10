<?php
$servername = "localhost";
$username   = "u1597610_myadmin";
$password   = "Mytutor123";
$dbname     = "u1597610_mytutor";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    // echo `<script>console.log('connection failed');</script>`;
    die("Connection failed: " . $conn->connect_error);
}else{
    // echo `<script>console.log('connection success');</script>`;
}
?>
