pragma solidity >=0.4.22 <0.6.0;

contract shoppingSmartContract {
    
    // struct to hold various kind of data for seller
	struct Seller {
		address sellerAddress;
		uint32[] productId;
		bool whitelisted;
	}
    
    // struct to hold product related data
	struct Product {
		uint32 productId;
		uint256 price;
	}
    
	mapping(address => Seller) sellers;
	mapping(uint32 => Productt) products;
	address admin;
	uint32 productCount;
    
    // make creator of contract as admin
	constructor(shoppingSmartContract) internal {
		admin = msg.sender;
	}

}