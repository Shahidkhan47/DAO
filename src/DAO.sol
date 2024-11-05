// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

/// @title The DAO(decentraized autonomous organization)
/// @author Shahidkhan
/// @notice Its like a DAO concept where one person can create proposal and everyone can vote on that during certain period of time(for or against)

contract DAO {
    //Proposal details struct
    struct Proposal {
        address proposal_creator;
        string proposal_text;
        uint expiration_time;
        uint for_proposal;
        uint against_proposal;
    }

    //events
    event ProposalCreated(bytes32 _identifier, address proposal_creator);
    event VoteCast(address voter, bytes32 _identifier);

    //identifier to proposaldetails
    mapping(bytes32 identifier => Proposal) public proposaldetails;

    bytes32[] internal identifiers;

    //identifier => voter_address => hasvoted
    mapping(bytes32 identifier => mapping(address => bool)) public hasvoted;

    /// @notice Creating proposal for voting
    /// @param _proposal_text It is a descriptive text about proposal
    /// @param _expiration_time it is an expiration time set by creator When voting time will be ended
    function proposalCreation(
        string memory _proposal_text,
        uint _expiration_time
    ) external returns (bytes32 _iden) {
        require(
            _expiration_time > block.timestamp,
            "Expiration time should be more than current time"
        );
        _iden = keccak256(
            abi.encodePacked(block.timestamp, _proposal_text, _expiration_time)
        );
        proposaldetails[_iden] = Proposal({
            proposal_creator: msg.sender,
            proposal_text: _proposal_text,
            expiration_time: _expiration_time,
            for_proposal: 0,
            against_proposal: 0
        });
        identifiers.push(_iden);
        emit ProposalCreated(_iden, msg.sender);
    }

    ///@notice function to vote for or against on proposal
    /// @param _iden Id for particular proposal to vote on
    /// @param _vote type of vote (for or against)
    function vote(bytes32 _iden, bool _vote) external {
        Proposal storage proposal = proposaldetails[_iden];
        require(proposal.proposal_creator != address(0), "Identifier not found");
        require(!hasvoted[_iden][msg.sender], "Voter has already voted");
        require(
            proposal.expiration_time >= block.timestamp,
            "time is over for voting on this proposal"
        );
        hasvoted[_iden][msg.sender] = true;
        if (_vote == true) {
            proposal.for_proposal++;
        } else proposal.against_proposal++;

        emit VoteCast(msg.sender, _iden);
    }

    /// @notice checking details for proposal
    /// @param _iden Id for particular proposal to vote on
    function proposalDetails(
        bytes32 _iden
    ) external view returns (address, string memory, uint) {
        Proposal memory proposal = proposaldetails[_iden];
        return (
            proposal.proposal_creator,
            proposal.proposal_text,
            proposal.expiration_time
        );
    }

    /// @notice Checking remaining time
    /// @param _iden Id for particular proposal to vote on
    function checkTime(bytes32 _iden) external view returns (uint, bool) {
        Proposal memory proposal = proposaldetails[_iden];
        require(
            proposal.expiration_time > block.timestamp,
            "Time is over for voting on this proposal"
        );
        uint remaining_time = proposal.expiration_time - block.timestamp;
        return (remaining_time, true);
    }

    /// @notice Checking for voter hasvoted or not
    /// @param _iden Id for particular proposal to vote on
    function voterCheck(
        bytes32 _iden,
        address _voter
    ) external view returns (bool hasVoted) {
        return hasVoted = hasvoted[_iden][_voter];
    }

    /// @notice Checking total votes for particular proposal
    /// @param _iden Id for particular proposal to vote on
    function getVoteTallying(
        bytes32 _iden
    ) external view returns (uint, uint, uint) {
        Proposal memory proposal = proposaldetails[_iden];
        uint totalVotes = proposal.for_proposal + proposal.against_proposal;
        return (totalVotes, proposal.for_proposal, proposal.against_proposal);
    }

    /// @notice Fetching all the Ids
    function fetchIds() external view returns (bytes32[] memory) {
        return identifiers;
    }
}
