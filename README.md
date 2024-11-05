# DAO Smart Contract

## Overview
This Solidity-based smart contract implements a Decentralized Autonomous Organization (DAO) where users can create proposals and participate in voting. Each proposal has a voting period, and participants can vote either for or against the proposal. 

The contract includes features such as:
- Proposal creation with an expiration time.
- Voting on active proposals.
- Retrieving proposal details and vote tallies.
- Checking if a user has voted on a specific proposal.

## Features

- **Proposal Creation**: Anyone can create a proposal by providing a descriptive text and an expiration time.
- **Voting**: Users can cast votes either in favor or against the proposal.
- **Vote Tallying**: View the total votes cast , in favor of proposal and against a proposal.
- **Time Checking**: Check how much time is left before a proposal expires.
- **Voter Status**: Determine whether a user has already voted on a particular proposal.
- **Proposal Listing**: Fetch the list of all proposalIDs created.

## Contract Functions

### 1. `proposalCreation(string memory _proposal_text, uint _expiration_time) external returns (bytes32)`
Creates a new proposal and emits a `ProposalCreated` event.

**Parameters**:
- `_proposal_text`: Description text of the proposal.
- `_expiration_time`: The time (in seconds) when voting on this proposal ends.

**Returns**:
- `_iden`: The unique identifier for the proposal (created using `keccak256`).

### 2. `vote(bytes32 _iden, bool _vote) external`
Casts a vote for a specific proposal and emits a `VoteCast` event.

**Parameters**:
- `_iden`: The unique identifier of the proposal.
- `_vote`: `true` for a vote in favor of the proposal, `false` for a vote against.

### 3. `proposalDetails(bytes32 _iden) external view returns (address, string memory, uint)`
Fetches the details of a specific proposal.

**Returns**:
- The proposal creator’s address.
- The proposal’s descriptive text.
- The expiration time for the proposal.

### 4. `checkTime(bytes32 _iden) public view returns (uint, bool)`
Checks how much time is left before voting on a proposal ends.

**Returns**:
- The remaining time (in seconds) for the proposal.
- `true` if voting is still open.

### 5. `voterCheck(bytes32 _iden, address _voter) external view returns (bool)`
Checks whether a specific voter has already voted on a particular proposal.

**Returns**:
- `true` if the voter has voted, otherwise `false`.

### 6. `getVoteTallying(bytes32 _iden) external view returns (uint, uint, uint)`
Retrieves the vote tally for a specific proposal.

**Returns**:
- The total number of votes cast.
- The number of votes in favor of the proposal.
- The number of votes against the proposal.

### 7. `fetchIds() external view returns (bytes32[] memory)`
Fetches the identifiers of all the proposals created.

**Returns**:
- A list of all proposal IDs.

## Events

### 1. `ProposalCreated(bytes32 _identifier, address proposal_creator)`
Emitted when a new proposal is created.

### 2. `VoteCast(address voter, bytes32 _identifier)`
Emitted when a vote is cast on a proposal.

## Usage

1. **Create a Proposal**: Call the `proposalCreation` function with a description text and expiration time.
2. **Vote on a Proposal**: Call the `vote` function with the proposal ID and your vote (for or against).
3. **Check Results**: Use functions like `proposalDetails`, `getVoteTallying`, and `checkTime` to see proposal information and vote counts.

## Installation & Deployment

1. Install Foundry

2. for compile 
 forge build

3. for testing 
 forge test

4. for running script (for running the script rename .env.sample to .env and write your private key)
 forge script script/DAO.s.sol --rpcurl (enter rpc-url) 

