// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
//prevent reentrancy attacks
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarket is ReentrancyGuard{
    using Counters for Counters.Counter;
    Counters.Counter private _itemsIds;
     //total numbers of items sold
    Counters.Counter private _itemsSold;
    //owner of the smart contract
    address payable owner;
    //how musch they need to pay to list their nft on your market place
    uint listingPrice = 0.025 ether;

    constructor(){
        owner = payable(msg.sender);
    }

    struct MarketItem{
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }
//a way to access values of the struct by passing an integer ID
    mapping(uint256 =>MarketItem) private idMarketItem;

    //event are ways to log messages when items are sold
    event MarketItemCreated(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address  seller,
        address  owner,
        uint256  price,
        bool  sold
    );

    //a way to get a listing price
    function getListingPrice()public view returns(uint256){
        return listingPrice;
    }

    //a way to create a market item
    function createMarketItem(address nftContract,uint256 tokenId, uint256 price) public payable nonReentrant{

        require(price > 0 , "price must be at least 1 wei");
        require(msg.value==listingPrice, "price must be equal to the listing price");
        //add 1 tot the total number of items ever created
        _itemsIds.increment();
        uint256 itemId = _itemsIds.current();
        idMarketItem[itemId]= MarketItem
        (
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),//address of the seller of nft
            payable(address(0)),//no owner yet,empty address
            price,
            false

        ); 

          //transfer the ownership of the nft to the contract itself/platform itself
          IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
          //log this transaction
          emit MarketItemCreated(
            itemId,
            nftContract, 
            tokenId, 
            msg.sender,
            address(0),
            price, 
            false
            );
    }

    ///@notice function to create a sale
    function createMarketSale(address nftContract,uint256 itemId) public payable nonReentrant{
        uint price = idMarketItem[itemId].price;
        uint tokenId = idMarketItem[itemId].tokenId;

        require(msg.value == price, "please submit the asking price");
        //pay the seller the amount
        idMarketItem[itemId].seller.transfer(msg.value);

        //transfer the ownership of the nft from the contract itself/platform itself to the buyer
          IERC721(nftContract).transferFrom( address(this),msg.sender, tokenId);
          // mark a buyer as the new owner
          idMarketItem[itemId].owner = payable(msg.sender);
          // mark the item to be sold
          idMarketItem[itemId].sold = true;
          //increment the total number of items sold by one
          _itemsSold.increment();
          //pay the owner of the contract
          payable(owner).transfer(listingPrice);

    }

    ///@notice function to display total numbers of unsolved items on our platform
    function fetchUnsoldMarketItems() public view returns(MarketItem[] memory){
        //getting the total numbers of items ever created
        uint itemCount = _itemsIds.current();
        //total number of items unsold = total number of items ever created - total number of items ever sold
        uint unsoldItemCount = _itemsIds.current() - _itemsSold.current();

        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        //loop through all items ever created
        for(uint i = 0; i<itemCount; i++){
            //get only unsold items
            //check if the item is not been sold
            //by checking if the owner field is empty
            if(idMarketItem[i + 1].owner ==address(0)){
              //this item has never been sold
              uint currentId = idMarketItem[i + 1].itemId;
              MarketItem storage currentItem = idMarketItem[currentId];
              items[currentIndex] = currentItem;
              currentIndex += 1;
            }

        }
        // returning the array of all unsold items
        return items;

    }

    ///@notice function to fetch all nft's owned/bought by this user
    function fetchMyNFTs()public view returns(MarketItem[] memory){
        //total numbers of items ever created
        uint totalItemCount = _itemsIds.current();

        uint itemCount = 0;
        uint currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            //checking if they are the onwer, get items only this user has bought
            if(idMarketItem[i+1].owner ==msg.sender){
                //total length of the array
              itemCount +=1;
            }
        }

        //fetch the items and display them as an array
        //create an array of type marketitem which is gona be in memory
        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if(idMarketItem[i+1].owner ==msg.sender){
                uint currentId = idMarketItem[i+1].itemId;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex+=1;
            }
            
        }
        return items;
    }

    ///@notice function to fetch all nft's created/listed by this user
    function fetchItemsCreated()public view returns(MarketItem[] memory){
        //total numbers of items ever created
        uint totalItemCount = _itemsIds.current();

        uint itemCount = 0;
        uint currentIndex = 0;

        for (uint256 i = 0; i < totalItemCount; i++) {
            //checking if they are the onwer, get items only this user has bought
            if(idMarketItem[i+1].seller ==msg.sender){
                //total length of the array
              itemCount +=1;
            }
        }

        //fetch the items and display them as an array
        //create an array of type marketitem which is gona be in memory
        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            if(idMarketItem[i+1].seller ==msg.sender){
                uint currentId = idMarketItem[i+1].itemId;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex+=1;
            }
            
        }
        return items;
    }

  



    

 



















}
