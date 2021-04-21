// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Catalog{
    uint256 public totalProduct;
    uint256 private idCount;

    struct Product{
        uint256 id;
        string brandName;
        string genericName;
        string form;
        string strength;
        string packaging;
    }

    Product[] public all_products;
    mapping(address => bool) private allowed_accounts;

    constructor() public {
        allowed_accounts[msg.sender] = true;
        totalProduct = 0;
        idCount = 1;
    }

    modifier restricted() {
        require(approved(msg.sender),"This function is restricted to the admin.");
        _;
    }
    function approved(address acc) public view returns (bool){
        return allowed_accounts[acc];
    }
    function registerAdmin(address acc) public restricted{
       require(!approved(acc),"Account already exist.");
        allowed_accounts[acc] = true;
    }
    function read() public view returns (Product[] memory){
        
        return all_products;
    }
    function search(string memory _name) public view returns (Product memory){
        for( uint256 i = 0;i<totalProduct;i++){
            string memory _pname = all_products[i].brandName;
            if(keccak256(bytes(_name)) == keccak256(bytes(_pname))){
                return all_products[i];
            }
        }
        revert("Product not found!");
    }

    function newProduct(string memory _brandName,string memory _genericName,string memory _form,string memory _strength,string memory _packaging) public restricted{
        for(uint256 i = 0 ; i < totalProduct ;i++){
            if(keccak256(bytes(_brandName))==keccak256(bytes(all_products[i].brandName))){
                revert("Product already exist1");
            }
        }
        all_products.push(Product(idCount,_brandName,_genericName,_form,_strength,_packaging));
        totalProduct++;
        idCount++;
    }

    function updateProduct(uint256 _id,string memory _brandName,string memory _genericName,string memory _form,string memory _strength,string memory _packaging) public restricted{
        for (uint256 i = 0; i < totalProduct; i++) {
            if(all_products[i].id == _id){
                all_products[i].brandName = _brandName;
                all_products[i].genericName = _genericName;
                all_products[i].form = _form;
                all_products[i].strength = _strength;
                all_products[i].packaging = _packaging;
            }
        }
        revert("Product not found!");
    }
    function deleteProduct(uint256 _id) public restricted{
        require(totalProduct > 0);
        for (uint256 i = 0; i < totalProduct; i++) {
            if(all_products[i].id == _id){
                all_products[i] = all_products[totalProduct-1];
                delete all_products[totalProduct-1];
                totalProduct--;
                all_products.pop();
            }
        }
    }
}