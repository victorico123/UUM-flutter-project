<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];
$amount = $_GET['amount'];
$name = $_GET['name'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
    $status = "Paid";
}else{
    $paidstatus = "Failed";
    $status = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
$message = "hahah";
$error = 1;
$userid = 0;
$signed= hash_hmac('sha256', $signing, 'S-m1UsqkozdhqjD5tRSqv5SA');
if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success"){ //payment success the back button on the app
        $sqlGetUserId = "SELECT * FROM `users` WHERE `email` = '$email'";
        if ($result1 = $conn->query($sqlGetUserId)) {
            if ($result1->num_rows > 0) {
                while ($rows1 = $result1->fetch_assoc()) {
                    $userid = $rows1['id'];
                    
                }
                $message = "-1";
            }
            $sqlGetCart = "SELECT * FROM `tbl_carts` WHERE `user_id`='$userid'";
                    $message = "1";
            if ($result2 = $conn->query($sqlGetCart)) {
                if ($result2->num_rows > 0) {
                while ($rows2 = $result2->fetch_assoc()) {
                    $subjectid = $rows2['subject_id'];
                    $sqlInsertHistory = "INSERT INTO `tbl_history`( `receipt_id`,`user_id`,`subject_id`) VALUES ('$receiptid','$userid','$subjectid')";
                    $conn->query($sqlInsertHistory);
                }
                    $message = "2";
                $sqlInsertPayment = "INSERT INTO `tbl_payment`( `receipt_id`,`user_id`,`payment_total_paid`) VALUES ('$receiptid','$userid','$amount')";
                $sqlDeleteCart = "DELETE FROM `tbl_carts` WHERE `user_id`='$userid'";
                
                
                if ($conn->query($sqlInsertPayment) && $conn->query($sqlDeleteCart)){
                    $error= 0;
                }
            }
            }
            
            
            
        }
        
    }
    if($error==1){

    
    // $message = "Payment FAILED.";
    printTable('Failed',$name,$email,$amount,$paidstatus,$message);
    }else{
    $message = "Payment COMPLETE. ";
                $amount = number_format((float)$amount, 2, '.', '');
                printTable($receiptid,$name,$email,$amount,$paidstatus,$message);   
    }
    
}

function printTable($receiptid,$name,$email,$amount,$paidstatus,$message){
   echo "
        <html>
        <head>
            <meta name='viewport' content='width=device-width, initial-scale=1'>
            <link rel='stylesheet' href='https://www.w3schools.com/w3css/4/w3.css'>
        </head>
        <div = class='w3-padding'> <h4>Thank you for your payment</h4>
        <p>The following is your receipt for recent payment</p></div>
        <div class='w3-container w3-padding'>
            <table class='w3-table w3-striped w3-bordered'>
            <tr><th>Receipt ID</th><td>$receiptid<td></tr>
            <tr><th>Paid By</th><td>$name<td></tr>
            <tr><th>Email</th><td>$email<td></tr>
            <tr><th>Amount </th><td>RM $amount<td></tr>
            <tr><th>Payment Status</th><td>$paidstatus<td></tr>
            </table>
        <hr>";
        if($receiptid == 'Failed'){
            echo "<div class='w3-container w3-round w3-block w3-red'><b>$message</b></div>";
        }else{
            echo "<div class='w3-container w3-round w3-block w3-green'><b>$message</b></div>";
            
        }
        
        echo "<br>
        <div class='w3-container w3-round w3-block'>Return back to the application by pressing the back button on the app task bar.</div>
        </div>
        </body></html> 
        ";
}

?>