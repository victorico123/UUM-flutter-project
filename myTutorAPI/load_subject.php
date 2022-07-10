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
if(isset($_POST['tutor_id_chosen'])){
    $chosenTutor = $_POST['tutor_id_chosen'];
    $sqlSubject = "SELECT * FROM `tbl_subjects` WHERE `tutor_id` = $chosenTutor";
    $sql = $conn->query("SELECT count(subject_id) AS id FROM tbl_subjects")->fetch_assoc();

}else{
    if ($_POST['search'] == '') {
        $sqlSubject = "SELECT * FROM tbl_subjects LIMIT $paginationStart, $limit";
        $sql = $conn->query("SELECT count(subject_id) AS id FROM tbl_subjects")->fetch_assoc();
    }else{
        $likeQuery = $_POST['search'];
        $sqlSubject = "SELECT * FROM tbl_subjects WHERE `subject_name` LIKE '%$likeQuery%' LIMIT $paginationStart, $limit";
        $sql = $conn->query("SELECT count(subject_id) AS id FROM tbl_subjects WHERE `subject_name` LIKE '%$likeQuery%'")->fetch_assoc();
    }

}
$stmt = $conn->prepare($sqlSubject);
$stmt->execute();
$result = $stmt->get_result();

// Calculate total pages
$allRecrods = $sql['id'];
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
    if(isset($_POST['tutor_id_chosen'])){
        $response = array('status' => 'success', 'data' => $courses);
    
    }else{
        $response = array('status' => 'success', 'page' => "$page", 'totalPages' => "$totalPages", 'data' => $courses, 'totalData' => $allRecrods);
    }
    sendJsonResponse($response);
} else {
    
    if(isset($_POST['tutor_id_chosen'])){
        $response = array('status' => 'failed', 'data' => null);
    
    }else{
        $response = array('status' => 'failed', 'page' => "$page", 'totalPages' => "$totalPages", 'data' => null, 'totalData' =>"0");
    }
    sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>