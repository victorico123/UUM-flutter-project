<?php
include("dbconnect.php");
session_start();
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

// Get total records
$sql = $conn->query("SELECT count(tutor_id) AS id FROM tbl_tutors")->fetch_assoc();
$allRecrods = $sql['id'];

$limit = (isset($_POST['limit'])) ? $allRecrods : 5;
$page = (isset($_POST['page']) && is_numeric($_POST['page'])) ? $_POST['page'] : 1;
$paginationStart = ($page - 1) * $limit;
$sqlTutor = "SELECT * FROM tbl_tutors LIMIT $paginationStart, $limit";
$stmt = $conn->prepare($sqlTutor);
$stmt->execute();
$result = $stmt->get_result();

// Calculate total pages
$totalPages = ceil($allRecrods / $limit);
// Prev + Next
$prev = $page - 1;
$next = $page + 1;

if ($allRecrods > 0) {
    $tutors['tutors'] = array();
    while ($row = $result->fetch_assoc()) {
        $tlist = array();
        $tlist['tutor_id'] = $row['tutor_id'];
        $tlist['tutor_email'] = $row['tutor_email'];
        $tlist['tutor_phone'] = $row['tutor_phone'];
        $tlist['tutor_name'] = $row['tutor_name'];
        $tlist['tutor_description'] = $row['tutor_description'];
        $tlist['tutor_datereg'] = $row['tutor_datereg'];
        array_push($tutors['tutors'], $tlist);
    }
    $response = array('status' => 'success', 'page' => "$page", 'totalPages' => "$totalPages", 'data' => $tutors);
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