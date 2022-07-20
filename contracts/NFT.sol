// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage{
    //auto increment field for each token
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    //address of the nft marketplace
    address contractAdress;

    //constructor
    constructor(address marketplaceAddress) ERC721("partnerverse Tokens", "PNVT"){
        contractAdress = marketplaceAddress;
    }

    /// @notice creating tokens
    /// @param tokenURI: token uri
    function createToken(string memory tokenURI) public returns(uint){
        //set a new token id for the tokens to be minted.
      _tokenIds.increment();
      uint256 newItemId= _tokenIds.current(); 

      //minting
      _mint(msg.sender, newItemId); 
      //generate the uri
      _setTokenURI(newItemId, tokenURI);
      //grant transaction permission to the marketplace
      setApprovalForAll(contractAdress, true);
      //return token id
      return newItemId;
    }
















































}