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

	modifier onlyAdmin() {
		require(msg.sender == admin, "only Admin can whitelist a seller");
		_;
	}

	modifier onlyWhitelistedSeller() {
		require(sellers[msg.sender].sellerAddress != "", "Whitelisted seller can add products");
		_;
	}
    
    // make creator of contract as admin
	constructor(shoppingSmartContract) internal {
		admin = msg.sender;
	}

	// public visible function to register yourself as seller
	function addAsSeller() public returns (bool status) {
		// check if seller already registered
		require(sellers[msg.sender].sellerAddress!="", "Already added as seller.");

		Seller memory seller = Seller(msg.sender, new uint32[](0), false);
		sellers[msg.sender] = seller;
	}

	function makeSellerWhitelisted(address sellerId) public onlyAdmin {
		require(sellers[sellerId].sellerAddress!="", "Seller with the given address does not exist.");

		sellers[sellerId].whitelisted = true;
	}

}