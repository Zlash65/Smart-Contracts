pragma solidity >=0.4.22 <0.6.0;

contract sendReceive {

	// Logs
	event eventsLog(bytes32 message, address _address, uint _amount);
    
    // initiates a contract to receive donation
	function receiveDonation() public payable {
		emit eventsLog("Amount Received", msg.sender, msg.value);

		donateBackHalf(msg.value);
	}
    
	// initiate a return of hald the donation received
	function donateBackHalf(uint amount) private {
		msg.sender.transfer(amount/2);

		emit eventsLog("Cashback sent", msg.sender, amount/2);
	}
    
}