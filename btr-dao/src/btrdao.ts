import {
  AcceptOrDenyProposal as AcceptOrDenyProposalEvent,
  OwnershipTransferred as OwnershipTransferredEvent,
  ProposalCreated as ProposalCreatedEvent,
  ProposalExecuted as ProposalExecutedEvent,
  ProposalVoted as ProposalVotedEvent
} from "../generated/BTRDAO/BTRDAO"
import {
  DAOProposal,
  DAOMember,
  ProposalExecuted,
  ProposalAcceptedToVote,
  ProposalRejectedForNoVote,
} from "../generated/schema";
import { BigInt, json } from "@graphprotocol/graph-ts";

export function handleProposalCreated(event: ProposalCreatedEvent): void {
  const proposalId = event.params.title.toHexString() + event.params.proposal.toHexString() + event.params.proposalOwner.toHexString()
  let createdProposal = new DAOProposal(proposalId)
  let member = new DAOMember(event.params.proposalOwner)
  createdProposal.title = event.params.title
  createdProposal.proposal = event.params.proposal
  createdProposal.proposalOwner = event.params.proposalOwner
  member.save()
  createdProposal.save()
}


export function handleAcceptOrDenyProposal(event: AcceptOrDenyProposalEvent): void {
  const storedId = event.params.title.toHexString() + event.params.proposal.toHexString() + event.params.proposalOwner.toHexString()
  let proposal = DAOProposal.load(storedId);
  if(event.params.proposalAccepted === true) {
    let acceptedProposal = new ProposalAcceptedToVote(storedId);
    proposal!.proposalAccepted = true
    proposal!.proposalValidationTime = event.block.timestamp
    acceptedProposal.proposal = proposal!.id
    acceptedProposal.save()
    proposal!.save()
  } else {
    let rejectedProposal = new ProposalRejectedForNoVote(storedId);
    proposal!.proposalAccepted = false;
    proposal!.proposalValidationTime = event.block.timestamp;
    rejectedProposal.proposal = proposal!.id
    rejectedProposal.save()
    proposal!.save()
  }
}


export function handleProposalVoted(event: ProposalVotedEvent): void {
   const storedId = event.params.title.toHexString() + event.params.proposal.toHexString() + event.params.proposalOwner.toHexString()
   let proposal = DAOProposal.load(storedId);
   let value = json.toI64(proposal!.votedYes!.toU64().toString()) + 1;
   if(event.params.vote === 0) {
     proposal!.votedYes = BigInt.fromI64(value)
   } else {
     proposal!.votedNo = BigInt.fromI64(value);
   }
   proposal!.save()
}

export function handleProposalExecuted(event: ProposalExecutedEvent): void {
   const storedId = event.params.title.toHexString() + event.params.proposal.toHexString() + event.params.proposalOwner.toHexString()
   let proposal = DAOProposal.load(storedId);
   let executedProposal = new ProposalExecuted(storedId)
   proposal!.proposalExecuted = true
   executedProposal.proposal = proposal!.id
}

export function handleOwnershipTransferred(event: OwnershipTransferredEvent): void {}