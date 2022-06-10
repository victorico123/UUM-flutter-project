<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = addslashes($_POST['email']);
$name = addslashes($_POST['name']);
$phone = $_POST['phone'];
$password = $_POST['password'];
$address = addslashes($_POST['address']);
$base64image = $_POST['image'];
$imageExt = $_POST['imageExt'];
$tempFileName = getRandomString();
$filePath = './assets/profiles/' . $tempFileName . $imageExt;
$decoded_string = base64_decode($base64image);
$is_written = file_put_contents($filePath, $decoded_string);
$sqlinsert = "INSERT INTO `users`(`email`, `name`, `phone`, `password`, 
`address`,`image`) VALUES ('$email','$name','$phone','$password','$address','$filePath')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
} else {
    $response = array('status' => 'failed', 'data' => null);
}
function getRandomString() {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $randomString = '';
  
    for ($i = 0; $i < 20; $i++) {
        $index = rand(0, strlen($characters) - 1);
        $randomString .= $characters[$index];
    }
  
    return $randomString;
}function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>