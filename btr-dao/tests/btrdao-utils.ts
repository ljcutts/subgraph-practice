import { newMockEvent } from "matchstick-as"
import { ethereum, Bytes, Address, BigInt } from "@graphprotocol/graph-ts"
import {
  AcceptOrDenyProposal,
  OwnershipTransferred,
  ProposalCreated,
  ProposalExecuted,
  ProposalVoted
} from "../generated/BTRDAO/BTRDAO"

export function createAcceptOrDenyProposalEvent(
  title: Bytes,
  proposal: Bytes,
  proposalOwner: Address,
  proposalValidationTime: BigInt,
  proposalAccepted: boolean
): AcceptOrDenyProposal {
  let acceptOrDenyProposalEvent = changetype<AcceptOrDenyProposal>(
    newMockEvent()
  )

  acceptOrDenyProposalEvent.parameters = new Array()

  acceptOrDenyProposalEvent.parameters.push(
    new ethereum.EventParam("title", ethereum.Value.fromBytes(title))
  )
  acceptOrDenyProposalEvent.parameters.push(
    new ethereum.EventParam("proposal", ethereum.Value.fromBytes(proposal))
  )
  acceptOrDenyProposalEvent.parameters.push(
    new ethereum.EventParam(
      "proposalOwner",
      ethereum.Value.fromAddress(proposalOwner)
    )
  )
  acceptOrDenyProposalEvent.parameters.push(
    new ethereum.EventParam(
      "proposalValidationTime",
      ethereum.Value.fromUnsignedBigInt(proposalValidationTime)
    )
  )
  acceptOrDenyProposalEvent.parameters.push(
    new ethereum.EventParam(
      "proposalAccepted",
      ethereum.Value.fromBoolean(proposalAccepted)
    )
  )

  return acceptOrDenyProposalEvent
}

export function createOwnershipTransferredEvent(
  previousOwner: Address,
  newOwner: Address
): OwnershipTransferred {
  let ownershipTransferredEvent = changetype<OwnershipTransferred>(
    newMockEvent()
  )

  ownershipTransferredEvent.parameters = new Array()

  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam(
      "previousOwner",
      ethereum.Value.fromAddress(previousOwner)
    )
  )
  ownershipTransferredEvent.parameters.push(
    new ethereum.EventParam("newOwner", ethereum.Value.fromAddress(newOwner))
  )

  return ownershipTransferredEvent
}

export function createProposalCreatedEvent(
  title: Bytes,
  proposal: Bytes,
  proposalOwner: Address
): ProposalCreated {
  let proposalCreatedEvent = changetype<ProposalCreated>(newMockEvent())

  proposalCreatedEvent.parameters = new Array()

  proposalCreatedEvent.parameters.push(
    new ethereum.EventParam("title", ethereum.Value.fromBytes(title))
  )
  proposalCreatedEvent.parameters.push(
    new ethereum.EventParam("proposal", ethereum.Value.fromBytes(proposal))
  )
  proposalCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "proposalOwner",
      ethereum.Value.fromAddress(proposalOwner)
    )
  )

  return proposalCreatedEvent
}

export function createProposalExecutedEvent(
  title: Bytes,
  proposal: Bytes,
  proposalOwner: Address
): ProposalExecuted {
  let proposalExecutedEvent = changetype<ProposalExecuted>(newMockEvent())

  proposalExecutedEvent.parameters = new Array()

  proposalExecutedEvent.parameters.push(
    new ethereum.EventParam("title", ethereum.Value.fromBytes(title))
  )
  proposalExecutedEvent.parameters.push(
    new ethereum.EventParam("proposal", ethereum.Value.fromBytes(proposal))
  )
  proposalExecutedEvent.parameters.push(
    new ethereum.EventParam(
      "proposalOwner",
      ethereum.Value.fromAddress(proposalOwner)
    )
  )

  return proposalExecutedEvent
}

export function createProposalVotedEvent(
  title: Bytes,
  proposal: Bytes,
  proposalOwner: Address,
  vote: i32,
  voter: Address
): ProposalVoted {
  let proposalVotedEvent = changetype<ProposalVoted>(newMockEvent())

  proposalVotedEvent.parameters = new Array()

  proposalVotedEvent.parameters.push(
    new ethereum.EventParam("title", ethereum.Value.fromBytes(title))
  )
  proposalVotedEvent.parameters.push(
    new ethereum.EventParam("proposal", ethereum.Value.fromBytes(proposal))
  )
  proposalVotedEvent.parameters.push(
    new ethereum.EventParam(
      "proposalOwner",
      ethereum.Value.fromAddress(proposalOwner)
    )
  )
  proposalVotedEvent.parameters.push(
    new ethereum.EventParam(
      "vote",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(vote))
    )
  )
  proposalVotedEvent.parameters.push(
    new ethereum.EventParam("voter", ethereum.Value.fromAddress(voter))
  )

  return proposalVotedEvent
}
