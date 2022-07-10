<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$subjectId = $_POST['subjectId'];
$userId = $_POST['userId'];
if($subjectId == -1){
    $sqlDelete = "DELETE FROM tbl_carts WHERE `user_id` = $userId";
}else{
    $sqlDelete = "DELETE FROM tbl_carts WHERE `user_id` = $userId AND `subject_id` = $subjectId";
}
$stmt = $conn->prepare($sqlDelete);
if ($stmt->execute()) {
    $response = array('status' => 'success', 'data' => null);
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
