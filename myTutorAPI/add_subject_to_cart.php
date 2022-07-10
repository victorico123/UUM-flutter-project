<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$subjectId = $_POST['subjectId'];
$userId = $_POST['userId'];
$sqlAdd = "SELECT * FROM tbl_carts WHERE `user_id` = ? AND `subject_id` = ?";
$stmt = $conn->prepare($sqlAdd);
$stmt->bind_param("ii", $subjectId, $userId);
if ($stmt->execute()) {
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        $response = array('status' => 'registered', 'data' => null);
    } else {
        $sqlinsert = "INSERT INTO `tbl_carts`(`subject_id`, `user_id`) VALUES ('$subjectId','$userId')";
        if ($conn->query($sqlinsert) === TRUE) {
            $response = array('status' => 'success', 'data' => null);
        } else {
            $response = array('status' => 'failed', 'data' => null);
        }
    }
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
