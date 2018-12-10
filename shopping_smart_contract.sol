pragma solidity >=0.4.22 <0.6.0;

contract shoppingSmartContract {
    
    // struct to hold various kind of data for seller
	struct Seller {
		address sellerAddress;
		uint32[] productsData;
		bool whitelisted;
	}
    
    // struct to hold product related data
	struct Product {
		uint32 productId;
		uint256 price;
	}
    
	mapping(address => Seller) sellers;
	mapping(uint32 => Product) products;
	address admin;
	uint32 productCount;

	modifier onlyAdmin() {
		require(msg.sender == admin, "only Admin can whitelist a seller");
		_;
	}

	modifier onlyWhitelistedSeller() {
		require(sellers[msg.sender].sellerAddress != msg.sender, "Only whitelisted Seller can add products");
		_;
	}
    
    // make creator of contract as admin
	constructor(shoppingSmartContract) internal {
		admin = msg.sender;
	}

	// public visible function to register yourself as seller
	function addAsSeller() public returns (bool status) {
		// check if seller already registered
		require(sellers[msg.sender].sellerAddress == msg.sender, "Already added as seller.");

		Seller memory seller = Seller(msg.sender, new uint32[](0), false);
		sellers[msg.sender] = seller;
	}

	function makeSellerWhitelisted(address sellerId) public onlyAdmin {
		require(sellers[sellerId].sellerAddress != msg.sender, "Seller with the given address does not exist.");

		sellers[sellerId].whitelisted = true;
	}

	function addProduct(uint32 _id, uint256 _price) public onlyWhitelistedSeller {
		// check if product already added
		require(products[_id].productId == _id, "Product with the given id already exist.");

		Product memory prod = Product(_id, _price);
		products[_id] = prod;
		Seller memory seller = sellers[msg.sender];
		seller.productsData.push(prod);
		productCount++;
	}

	function getProductCount() public onlyAdmin returns (uint32) {
		return productCount;
	}

}