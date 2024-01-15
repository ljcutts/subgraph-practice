// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Airdrop is ERC1155, Ownable(msg.sender) {
    error ALREADY_CLAIMED_NFT();
    error NOT_AN_OWNER();
    mapping(address => bool) alreadyClaimedNFT;
    uint totalSupply;
    address[] GENERAL_LIST = [0xA38C00185dE730CEFd0480EFFc967C8565922457];
    address[] SPECIAL_FORCES_LIST = [0xA38C00185dE730CEFd0480EFFc967C8565922457];

    constructor() ERC1155("https://ipfs.io/ipfs/QmPKS6hFBnxJMxXAaYAwqJZHWsdg9wJQPmtNq93ztSrZME/{id}.json") {}
     

    function sendTierOneDAONFT() external {
      if(alreadyClaimedNFT[msg.sender] == true) revert ALREADY_CLAIMED_NFT();
       for(uint i = 0; i<GENERAL_LIST.length; i++) {
         if(GENERAL_LIST[i] == msg.sender) {
            alreadyClaimedNFT[msg.sender] = true;
            _mint(msg.sender, 1, 1, "");
            totalSupply++;
             break;
         } 
       }
       if(alreadyClaimedNFT[msg.sender] == false) revert NOT_AN_OWNER();
    }
    
    function sendTierTwoDAONFT() external {
       if(alreadyClaimedNFT[msg.sender] == true) revert ALREADY_CLAIMED_NFT();
       for(uint i = 0; i<SPECIAL_FORCES_LIST.length; i++) {
         if(SPECIAL_FORCES_LIST[i] == msg.sender) {
          alreadyClaimedNFT[msg.sender] = true;
          _mint(msg.sender, 2, 1, "");
          totalSupply++;
           break;
         }    
       }
       if(alreadyClaimedNFT[msg.sender] == false) revert NOT_AN_OWNER();
    }

    function mintDAONFT(address member, uint id) external onlyOwner {
       if(alreadyClaimedNFT[member] == true) revert ALREADY_CLAIMED_NFT();
       alreadyClaimedNFT[member] = true;
      _mint(member, id, 1, "");
      totalSupply++;
    }

    function returnTotalSupply() public view returns(uint) {
       return totalSupply;
    }

    function haveYouClaimedNFT() external view returns(bool) {
      return alreadyClaimedNFT[msg.sender];
    }
}