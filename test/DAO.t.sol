// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DAO} from "../src/DAO.sol";

contract Voting is Test {
    DAO public dao;
    event ProposalCreated(bytes32 _identifier, address proposal_creator);
    event VoteCast(address voter, bytes32 _identifier);

    address public creator1 = address(111111);
    address public creator2 = address(222222);
    address public voter1 = address(333333);
    address public voter2 = address(444444);
    address public voter3 = address(555555);

    function setUp() public {
        dao = new DAO();
    }

    function test_proposalCreation() public {
        vm.startPrank(creator1);
        vm.expectEmit(false, false, false, false);
        emit ProposalCreated(bytes32("11111"), creator1);
        dao.proposalCreation(
            "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",
            block.timestamp + 5 minutes
        );
        vm.stopPrank();
    }

    function test_vote() public {
        vm.startPrank(creator1);
        bytes32 _iden1 = dao.proposalCreation(
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
            block.timestamp + 5 minutes
        );
        vm.stopPrank();

        vm.startPrank(creator2);
        bytes32 _iden2 = dao.proposalCreation(
            "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy",
            block.timestamp + 8 minutes
        );
        vm.stopPrank();

        vm.prank(voter1);
        dao.vote(_iden1, true);

        vm.prank(voter2);
        dao.vote(_iden1, true);

        vm.prank(voter3);
        dao.vote(_iden1, false);

        vm.prank(voter1);
        dao.vote(_iden2, false);

        vm.prank(voter2);
        dao.vote(_iden2, false);

        vm.prank(voter3);
        dao.vote(_iden2, true);

        (uint total1 , uint for_proposal1 , uint against_proposal1) = dao.getVoteTallying(_iden1);
        assertEq(total1, 3);
        assertEq(for_proposal1, 2);
        assertEq(against_proposal1, 1);

        (uint total2 , uint for_proposal2 , uint against_proposal2) = dao.getVoteTallying(_iden2);
        assertEq(total2, 3);
        assertEq(for_proposal2, 1);
        assertEq(against_proposal2, 2);
    }

    function test_voteForEvent(address _voter, bool _vote) public {
        vm.startPrank(creator1);
        bytes32 _iden = dao.proposalCreation(
            "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz",
            block.timestamp + 5 minutes
        );
        vm.stopPrank();

        vm.startPrank(_voter);
        vm.expectEmit(false, false, false, true);
        emit VoteCast(_voter, _iden);
        dao.vote(_iden, _vote);
        vm.stopPrank();
    }

    function testFail_doubleVoting() public {
        vm.startPrank(creator1);
        bytes32 _iden = dao.proposalCreation(
            "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT",
            block.timestamp + 5 minutes
        );
        vm.stopPrank();

        vm.startPrank(voter1);
        dao.vote(_iden, true);
        vm.stopPrank();
        vm.startPrank(voter1);
        dao.vote(_iden, false);
        vm.stopPrank();
    }

    function testFail_voteAfterTime() public {
        vm.startPrank(creator1);
        bytes32 _iden = dao.proposalCreation(
            "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD",
            block.timestamp + 5 minutes
        );
        vm.stopPrank();

        vm.warp(block.timestamp + 10 minutes);
        vm.startPrank(voter1);
        dao.vote(_iden, true);
        vm.stopPrank();
    }

    function testFail_wrongIdentifier() public {
         vm.startPrank(creator1);
        dao.proposalCreation(
            "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD",
            block.timestamp + 5 minutes
        );
        vm.stopPrank();

        vm.startPrank(voter1);
        dao.vote(bytes32("1212212"), true);
        vm.stopPrank();
    }
}
