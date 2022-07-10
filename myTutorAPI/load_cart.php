<?php
include("dbconnect.php");
session_start();
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}


$userId = $_POST['userId'];
$sqlCart = "SELECT * FROM tbl_carts WHERE `user_id` = $userId";
$stmt = $conn->prepare($sqlCart);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $courses['courses'] = array();
    while ($row = $result->fetch_assoc()) {
        $subjectId = $row['subject_id'];
        $sqlSubject = "SELECT * FROM tbl_subjects WHERE `subject_id` = $subjectId";
        $stmt2 = $conn->prepare($sqlSubject);
        $stmt2->execute();
        $result2 = $stmt2->get_result();
        while ($row2 = $result2->fetch_assoc()) {
            $clist = array();
            $clist['subject_id'] = $row2['subject_id'];
            $clist['subject_name'] = $row2['subject_name'];
            $clist['subject_description'] = $row2['subject_description'];
            $clist['subject_sessions'] = $row2['subject_sessions'];
            $clist['subject_rating'] = $row2['subject_rating'];
            $clist['subject_price'] = $row2['subject_price'];
            $clist['tutor_id'] = $row2['tutor_id'];
            array_push($courses['courses'], $clist);
        }
    }
    $response = array('status' => 'success', 'data' => $courses);
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
?>