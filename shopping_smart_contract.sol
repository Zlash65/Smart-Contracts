pragma solidity >=0.4.22 <0.6.0;

contract shoppingSmartContract {

	// Keeping Logs of Transactions
	event eventAddAsSeller(bytes32 message, address seller);
	event eventWhitelistAddress(bytes32 message, address seller);
	event eventAddProduct(bytes32 message, bytes32 productId, uint256 price, address seller);
	event eventBuyContent(bytes32 message, bytes32 productId, uint256 price, address buyer);
    
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
    
	mapping(address => Seller) sellers; // sellers mapping
	mapping(bytes32 => Product) products; // products mapping
	mapping(address => mapping(bytes32 => bool)) productSold; // sold history mapping
	address admin;
	uint32 productCount;

	// modifier to check if its an admin account
	modifier onlyAdmin() {
		require(msg.sender == admin, "Admin access required");
		_;
	}

	// modifier to check if the account is whitelisted seller
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
		emit eventAddAsSeller("Added as Seller", msg.sender);
	}

	// only admin can call this function to whitelist a seller address
	function WhitelistAddress(address sellerId) public onlyAdmin {
		require(sellers[sellerId].sellerAddress != msg.sender, "Seller with the given address does not exist.");
		require(sellers[sellerId].sellerAddress != address(0), "Seller with the given address does not exist.");

		sellers[sellerId].whitelisted = true;
		emit eventWhitelistAddress("Seller whitelisted", sellerId);
	}

	// only a registered whitelisted seller can add products
	function AddProduct(bytes32 _id, uint256 _price) public onlyWhitelistedSeller {
		// check if product already added
		require(products[_id].productId != _id, "Product with the given id already exist.");

		Product memory prod = Product(_id, _price);
		products[_id] = prod;
// 		Seller memory seller = sellers[msg.sender];
// 		seller.productsData.push(prod);
		productCount++;
		emit eventAddProduct("Product added", _id, _price, msg.sender);
	}

	// retreive number of products added
	function GetContentCount() public returns (uint32) {
		return productCount;
	}

	// buy a product by its id and paying its exact price
	function BuyContent(bytes32 _id) public payable {
		require(products[_id].productId[0]!=0, "Product with given id does not exist.");
		require(products[_id].price==msg.value, "Product price does not match with paid value.");

		productSold[msg.sender][_id] = true;
		emit eventBuyContent("Product bought", _id, msg.value, msg.sender);
	}

	// check if an address has bought any product or not
	function BuyCheck(address from, bytes32 _id) public onlyAdmin returns (bool status) {
		// validate if the product id exist or not
		require(products[_id].productId[0]!=0, "Product with given id does not exist.");

		return productSold[from][_id] == true;
	}

}