<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = addslashes($_POST['email']);
$password = $_POST['password'];
$sqlLogin = "SELECT * FROM users WHERE email = ? AND password = ?";
$stmt = $conn->prepare($sqlLogin);
$stmt->bind_param("ss", $email, $password);

if ($stmt->execute()) {
    $result = $stmt->get_result();
    $user_name = "";
    while ($row = $result->fetch_assoc()) {
        $user['id'] = $row['id'];
        $user['email'] = $row['email'];
        $user['name'] = $row['name'];
        $user['phone'] = $row['phone'];
        $user['address'] = $row['address'];
        $user['image'] = $row['image'];
    }
    $response = array('status' => 'success', 'data' => $user);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}