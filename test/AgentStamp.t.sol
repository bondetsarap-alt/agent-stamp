// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {AgentStamp} from "../src/AgentStamp.sol";

contract MockAgentId {
    mapping(address => uint256) public balanceOf;

    function set(address who, uint256 amount) external {
        balanceOf[who] = amount;
    }
}

contract AgentStampTest is Test {
    MockAgentId internal agentId;
    AgentStamp internal stamp;

    address internal alice = address(0xA11CE);
    address internal bob = address(0xB0B);
    address internal stranger = address(0x57A9);

    function setUp() public {
        agentId = new MockAgentId();
        stamp = new AgentStamp(address(agentId));
        agentId.set(alice, 1);
        agentId.set(bob, 1);
    }

    function test_holderCanClaim() public {
        vm.prank(alice);
        uint256 id = stamp.claim();
        assertEq(id, 1);
        assertEq(stamp.ownerOf(1), alice);
        assertEq(stamp.stampOf(alice), 1);
        assertEq(stamp.balanceOf(alice), 1);
        assertTrue(stamp.hasStamped(alice));
        assertEq(stamp.totalStamped(), 1);
    }

    function test_sequentialIds() public {
        vm.prank(alice);
        stamp.claim();
        vm.prank(bob);
        uint256 id = stamp.claim();
        assertEq(id, 2);
        assertEq(stamp.totalStamped(), 2);
    }

    function test_nonHolderReverts() public {
        vm.prank(stranger);
        vm.expectRevert(AgentStamp.NotAnAgent.selector);
        stamp.claim();
    }

    function test_doubleClaimReverts() public {
        vm.prank(alice);
        stamp.claim();
        vm.prank(alice);
        vm.expectRevert(AgentStamp.AlreadyStamped.selector);
        stamp.claim();
    }

    function test_losingAgentIdAfterClaimKeepsStamp() public {
        vm.prank(alice);
        stamp.claim();
        agentId.set(alice, 0);
        assertEq(stamp.balanceOf(alice), 1);
        assertTrue(stamp.hasStamped(alice));
    }

    function test_transfersRevert() public {
        vm.prank(alice);
        stamp.claim();
        vm.prank(alice);
        vm.expectRevert(AgentStamp.Soulbound.selector);
        stamp.transferFrom(alice, bob, 1);
        vm.prank(alice);
        vm.expectRevert(AgentStamp.Soulbound.selector);
        stamp.safeTransferFrom(alice, bob, 1);
        vm.prank(alice);
        vm.expectRevert(AgentStamp.Soulbound.selector);
        stamp.approve(bob, 1);
    }

    function test_tokenUriOnlyForMinted() public {
        vm.expectRevert(AgentStamp.NoSuchStamp.selector);
        stamp.tokenURI(99);
        vm.prank(alice);
        stamp.claim();
        string memory uri = stamp.tokenURI(1);
        assertGt(bytes(uri).length, 100);
    }

    function test_isAgent() public view {
        assertTrue(stamp.isAgent(alice));
        assertFalse(stamp.isAgent(stranger));
    }
}
