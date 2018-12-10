pragma solidity >=0.4.22 <0.6.0;

contract shoppingSmartContract {
    
    // struct to hold various kind of data for seller
	struct Seller {
		address sellerAddress;
		bytes32[] productsData;
		bool whitelisted;
	}
    
    // struct to hold product related data
	struct Product {
		bytes32 productId;
		uint256 price;
	}
    
	mapping(address => Seller) sellers;
	mapping(bytes32 => Product) products;
	mapping(address => bytes32) productSold;
	address admin;
	uint32 productCount;

	modifier onlyAdmin() {
		require(msg.sender == admin, "Admin access required");
		_;
	}

	modifier onlyWhitelistedSeller() {
		require(sellers[msg.sender].sellerAddress != address(0), "Seller does not exist");
		require(sellers[msg.sender].whitelisted == true, "Only whitelisted Seller can add products");
		_;
	}
    
    // make creator of contract as admin
	constructor() public {
		admin = msg.sender;
	}

	// public visible function to register yourself as seller
	function addAsSeller() public {
		// check if seller already registered
		require(sellers[msg.sender].sellerAddress != msg.sender, "Already added as seller.");

		Seller memory seller = Seller(msg.sender, new bytes32[](0), false);
		sellers[msg.sender] = seller;
	}

	function makeSellerWhitelisted(address sellerId) public onlyAdmin {
		require(sellers[sellerId].sellerAddress != msg.sender, "Seller with the given address does not exist.");
		require(sellers[sellerId].sellerAddress != address(0), "Seller with the given address does not exist.");

		sellers[sellerId].whitelisted = true;
	}

	function addProduct(bytes32 _id, uint256 _price) public onlyWhitelistedSeller {
		// check if product already added
		require(products[_id].productId != _id, "Product with the given id already exist.");

		Product memory prod = Product(_id, _price);
		products[_id] = prod;
// 		Seller memory seller = sellers[msg.sender];
// 		seller.productsData.push(prod);
		productCount++;
	}

	function getProductCount() public returns (uint32) {
		return productCount;
	}

	function buyProduct(bytes32 _id) public payable {
		require(products[_id].productId[0]!=0, "Product with given id does not exist.");
		require(products[_id].price==msg.value, "Product price does not match with paid value.");

		productSold[msg.sender] = _id;
	}

	function BuyCheck(address from, bytes32 _id) public onlyAdmin returns (bool status) {
		return productSold[from] == _id;
	}

}