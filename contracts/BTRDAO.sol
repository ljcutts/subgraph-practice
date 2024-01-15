//SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.20;

interface IBTRNFT {
  function returnTotalSupply() external view returns(uint);
}

//Every proposal created
//All active proposals
//All executed proposals
//Rejected proposals
//Accepted proposals
//DAO members

contract BTRDAO is Ownable(msg.sender) {
    error NFT_BALANCE_EMPTY();
    error CANT_MAKE_PROPOSAL_YET();
    error PROPOSAL_HASNT_BEEN_ACCEPTED();
    error PROPOSAL_DOESNT_EXIST();
    error NOT_AN_OWNER();
    error PROPOSAL_ALREADY_VALIDATED();
    error ALREADY_VOTED();
    error MINIMUM_OF_15_VOTES();
    error NOT_ENOUGH_YES_VOTES();
    error HASNT_BEEN_7_DAYS();
    error DEADLINE_PASSED();

    enum Vote {
    YES, 
    No 
  }

    address public bTRNFTAddress;
    address public secondOwner;
    uint public currentIndex;

    constructor(address _btrNFTAddress) {
       bTRNFTAddress = _btrNFTAddress;
    }

    modifier doYouHoldBTRNFTS {
      bool hasDAONFT = (IERC1155(bTRNFTAddress).balanceOf(msg.sender, 1) > 0) || (IERC1155(bTRNFTAddress).balanceOf(msg.sender, 2) > 0);
        if(hasDAONFT == false) {
          revert NFT_BALANCE_EMPTY();
        }
        _;
    }

     modifier canYouMakeAnotherProposal {
        if(timeToCreateAnotherProposal[msg.sender] > block.timestamp) {
           revert CANT_MAKE_PROPOSAL_YET();
        }
        _;
    }

    modifier hasProposalBeenAccepted(uint index) {
      BTRProposal storage selectedBTRProposal = btrProposals[index];
        if(selectedBTRProposal.proposalAccepted == false) {
           revert PROPOSAL_HASNT_BEEN_ACCEPTED();
        }
        _;
    }

    modifier isProposalStillActive(uint index) {
      BTRProposal storage selectedBTRProposal = btrProposals[index];
      if(block.timestamp > selectedBTRProposal.proposalDeadline) {
        revert DEADLINE_PASSED();
      }
      _;
    }

     modifier canProposalBeAccepted(uint index) {
      address owner = owner();
      BTRProposal storage selectedBTRProposal = btrProposals[index];
      bool isSenderAnOwner = (msg.sender == owner || msg.sender == secondOwner);
        if(selectedBTRProposal.proposalOwner == address(0)) {
           revert PROPOSAL_DOESNT_EXIST();
        }
        if(isSenderAnOwner == false) {
          revert NOT_AN_OWNER();
        }

        if(selectedBTRProposal.proposalAlreadyValidated == true) {
          revert PROPOSAL_ALREADY_VALIDATED();
        }
        _;
    }

    modifier haveYouVotedAlready(uint index) {
       BTRProposal storage selectedBTRProposal = btrProposals[index];
       if(selectedBTRProposal.votedAlready[msg.sender] == true) {
         revert ALREADY_VOTED();
       }
      _;
    }

    modifier canProposalBeExecuted(uint index) {
       address owner = owner();
       uint totalSupply = IBTRNFT(bTRNFTAddress).returnTotalSupply();
       uint possibleTotalVotes = totalSupply > 63 ? totalSupply : 63;
       BTRProposal storage selectedBTRProposal = btrProposals[index];
       bool isSenderAnOwner = (msg.sender == owner || msg.sender == secondOwner);
       bool hasDeadlinePassed = (selectedBTRProposal.proposalDeadline > block.timestamp && selectedBTRProposal.totalVotes != possibleTotalVotes);
       if(selectedBTRProposal.totalVotes < 15) {
         revert MINIMUM_OF_15_VOTES();
       } 

       if(selectedBTRProposal.votedNo >= selectedBTRProposal.votedYes) {
         revert NOT_ENOUGH_YES_VOTES();
       }
        
        if(isSenderAnOwner == false) {
          revert NOT_AN_OWNER();
        }
        
        if(hasDeadlinePassed) {
          revert HASNT_BEEN_7_DAYS();
        }  
       _;
    }
    
    struct BTRProposal {
      bytes title;
      bytes proposal;
      address proposalOwner;
      bool proposalAccepted;
      bool proposalAlreadyValidated;
      bool proposalExecuted;
      uint votedYes;
      uint votedNo;
      uint totalVotes;
      uint proposalDeadline;
      mapping(address => bool) votedAlready;
    }

    event ProposalCreated(bytes title, bytes proposal, address proposalOwner);
    event AcceptOrDenyProposal(bytes title, bytes proposal, address proposalOwner, uint proposalValidationTime, bool proposalAccepted);
    event ProposalVoted(bytes title, bytes proposal, address proposalOwner, Vote vote, address voter);
    event ProposalExecuted(bytes title, bytes proposal, address proposalOwner);
    
    mapping(uint => BTRProposal) public btrProposals;


    mapping(address => uint) timeToCreateAnotherProposal;


    function createProposal(string calldata _title, string calldata _proposal) external doYouHoldBTRNFTS canYouMakeAnotherProposal {
      BTRProposal storage currentBTRProposal = btrProposals[currentIndex];
      currentBTRProposal.title = abi.encode(_title);
      currentBTRProposal.proposal = abi.encode(_proposal);
      currentBTRProposal.proposalOwner = msg.sender;
      timeToCreateAnotherProposal[msg.sender] = block.timestamp + 24 hours;
      currentIndex++;
      emit ProposalCreated(abi.encode(_title), abi.encode(_proposal), msg.sender);
    }

    function addSecondDAOOwner(address _secondOwner) external {
      address owner = owner();
      if(msg.sender != owner) revert NOT_AN_OWNER();
      secondOwner = _secondOwner;
    }

    function acceptOrDenyProposal(bool _acceptProposal, uint index) external canProposalBeAccepted(index) {
       BTRProposal storage selectedBTRProposal = btrProposals[index];
       if(_acceptProposal == true) {
        selectedBTRProposal.proposalAccepted = true;
        selectedBTRProposal.proposalDeadline = block.timestamp + 7 days;
        emit AcceptOrDenyProposal(selectedBTRProposal.title, selectedBTRProposal.proposal, selectedBTRProposal.proposalOwner, block.timestamp, true);
       } else {
        selectedBTRProposal.proposalAccepted = false;
         emit AcceptOrDenyProposal(selectedBTRProposal.title, selectedBTRProposal.proposal,  selectedBTRProposal.proposalOwner, block.timestamp, false);
       }
       selectedBTRProposal.proposalAlreadyValidated = true;
    }

    function voteOnProposal(Vote vote, uint index) external doYouHoldBTRNFTS haveYouVotedAlready(index) hasProposalBeenAccepted(index) isProposalStillActive(index) {
      BTRProposal storage selectedBTRProposal = btrProposals[index];
      if(vote == Vote.YES) {
        if(IERC1155(bTRNFTAddress).balanceOf(msg.sender, 1) > 0) {
          selectedBTRProposal.votedYes += 200;
        } else if(IERC1155(bTRNFTAddress).balanceOf(msg.sender, 2) > 0) {
          selectedBTRProposal.votedYes += 100;
        }
        emit ProposalVoted(selectedBTRProposal.title, selectedBTRProposal.proposal, selectedBTRProposal.proposalOwner, Vote.YES, msg.sender);
      } else {
          if(IERC1155(bTRNFTAddress).balanceOf(msg.sender, 1) > 0) {
          selectedBTRProposal.votedNo += 200;
        } else if(IERC1155(bTRNFTAddress).balanceOf(msg.sender, 2) > 0) {
          selectedBTRProposal.votedNo += 100;
        }
         emit ProposalVoted(selectedBTRProposal.title, selectedBTRProposal.proposal, selectedBTRProposal.proposalOwner, Vote.No, msg.sender);
      }
      selectedBTRProposal.totalVotes++;
      selectedBTRProposal.votedAlready[msg.sender] = true;
    }

    function executeProposal(uint index) external canProposalBeExecuted(index) {
       BTRProposal storage selectedBTRProposal = btrProposals[index];
       selectedBTRProposal.proposalExecuted = true;
       emit ProposalExecuted(selectedBTRProposal.title, selectedBTRProposal.proposal, selectedBTRProposal.proposalOwner);
    }

    function haveYouVotedThisProposal(uint index) external view returns(bool) {
      BTRProposal storage selectedBTRProposal = btrProposals[index];
      return selectedBTRProposal.votedAlready[msg.sender];
    }

    function canCreateAnotherProposal() external view returns(bool, uint) {
      return (block.timestamp > timeToCreateAnotherProposal[msg.sender], timeToCreateAnotherProposal[msg.sender]);
    } 

     function withdrawAnyFunds() external {
       address owner = owner();
      require(address(this).balance > 0, "NO_BALANCE_TO_WITHDRAW");
      require(msg.sender == owner || msg.sender == secondOwner, "NOT_OWNER");
      (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
      require(success, "TRANSFER_FAILED");
    }

    function viewACreatedProposal(uint index) external view returns(string memory proposal, address proposalOwner, bool proposalAccepted, bool proposalAlreadyValidated, bool proposalExecuted, uint votedYes, uint votedNo, uint totalVotes, uint proposalDeadline) {
       BTRProposal storage selectedBTRProposal = btrProposals[index];
       (proposal) = abi.decode(selectedBTRProposal.proposal, (string));
       return(proposal, selectedBTRProposal.proposalOwner, selectedBTRProposal.proposalAccepted, selectedBTRProposal.proposalAlreadyValidated, selectedBTRProposal.proposalExecuted, selectedBTRProposal.votedYes, selectedBTRProposal.votedNo, selectedBTRProposal.totalVotes, selectedBTRProposal.proposalDeadline);
    }

    receive() external payable {}
    fallback() external payable {}
}