<?php
include("dbconnect.php");
session_start();
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$limit = 5;
$page = (isset($_POST['page']) && is_numeric($_POST['page'])) ? $_POST['page'] : 1;
$paginationStart = ($page - 1) * $limit;
$sqlSubject = "SELECT * FROM tbl_subjects LIMIT $paginationStart, $limit";
$stmt = $conn->prepare($sqlSubject);
$stmt->execute();
$result = $stmt->get_result();

// Get total records
$sql = $conn->query("SELECT count(subject_id) AS id FROM tbl_subjects")->fetch_assoc();
$allRecrods = $sql['id'];

// Calculate total pages
$totalPages = ceil($allRecrods / $limit);
// Prev + Next
$prev = $page - 1;
$next = $page + 1;

if ($allRecrods > 0) {
    $courses['courses'] = array();
    while ($row = $result->fetch_assoc()) {
        $clist = array();
        $clist['subject_id'] = $row['subject_id'];
        $clist['subject_name'] = $row['subject_name'];
        $clist['subject_description'] = $row['subject_description'];
        $clist['subject_sessions'] = $row['subject_sessions'];
        $clist['subject_rating'] = $row['subject_rating'];
        $clist['subject_price'] = $row['subject_price'];
        $clist['tutor_id'] = $row['tutor_id'];
        array_push($courses['courses'], $clist);
    }
    $response = array('status' => 'success', 'page' => "$page", 'totalPages' => "$totalPages", 'data' => $courses);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'page' => "$page", 'totalPages' => "$totalPages", 'data' => null);
    sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>