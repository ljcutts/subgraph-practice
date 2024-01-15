import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { Bytes, Address, BigInt } from "@graphprotocol/graph-ts"
import { AcceptOrDenyProposal } from "../generated/schema"
import { AcceptOrDenyProposal as AcceptOrDenyProposalEvent } from "../generated/BTRDAO/BTRDAO"
import { handleAcceptOrDenyProposal } from "../src/btrdao"
import { createAcceptOrDenyProposalEvent } from "./btrdao-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let title = Bytes.fromI32(1234567890)
    let proposal = Bytes.fromI32(1234567890)
    let proposalOwner = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let proposalValidationTime = BigInt.fromI32(234)
    let proposalAccepted = "boolean Not implemented"
    let newAcceptOrDenyProposalEvent = createAcceptOrDenyProposalEvent(
      title,
      proposal,
      proposalOwner,
      proposalValidationTime,
      proposalAccepted
    )
    handleAcceptOrDenyProposal(newAcceptOrDenyProposalEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("AcceptOrDenyProposal created and stored", () => {
    assert.entityCount("AcceptOrDenyProposal", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "AcceptOrDenyProposal",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "title",
      "1234567890"
    )
    assert.fieldEquals(
      "AcceptOrDenyProposal",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "proposal",
      "1234567890"
    )
    assert.fieldEquals(
      "AcceptOrDenyProposal",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "proposalOwner",
      "0x0000000000000000000000000000000000000001"
    )
    assert.fieldEquals(
      "AcceptOrDenyProposal",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "proposalValidationTime",
      "234"
    )
    assert.fieldEquals(
      "AcceptOrDenyProposal",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "proposalAccepted",
      "boolean Not implemented"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
