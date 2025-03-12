// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {Test, console} from "forge-std/Test.sol";
import "../src/NFT.sol";
import {MockERC721} from "./mocks/mocks.sol";

contract nftcontracttest is Test {
    MyNFT nftcontract;
    MockERC721 mockERC721;

    address owner = address(this);
    address user1 = address(0x123);
    address user2 = address(0x456);
    string constant test = "ipfs://example-uri";

    function setUp() public {
        nftcontract = new MyNFT();
        mockERC721 = new MockERC721();
    }

    function test_owneraccess() public {
        nftcontract.GiveownerAccess(user1);
        assertEq(nftcontract.owner(), user1);
        vm.prank(user1);
        nftcontract.GiveownerAccess(user2);
        assertEq(nftcontract.owner(), user2);
        vm.prank(user2);
        nftcontract.GiveownerAccess(owner);
        assertEq(nftcontract.owner(), owner);
    }

    function test_mintprice() public {
        nftcontract.setMintPrice(100);
        assertEq(nftcontract.mintFee(), 100);

        vm.prank(user1);
        nftcontract.setMintPrice(200);
        assertEq(nftcontract.mintFee(), 100);
    }

    function test_MintNFT() {
        unit inibal = owner.balance;
        vm.deal(user1, 1 ether);
        vm.prank(user1);
        nftcontract.MintNFT{value: 0.002 ether}(user1, test);
        uint finalbal = owner.balance;
        assertEq(nftcontract.TokenCount(), 1);
        assertEq(user1.balance, 0.008 ether);
        assertEq(finalbal, inibal + 0.002 ether);
    }

    function test_MintNFTfail() {
        vm.deal(user1, 1 ether);
        vm.prank(user1);
        nftcontract.MintNFT{value: 0.001 ether}(user1, test);
        expectRevert("Payment to owner failed");
        assertEq(nftcontract.TokenCount(), 1);
    }

    function test_tokenperuser() {
        vm.deal(user1, 1 ether);
        vm.deal(user2, 1 ether);
        vm.prank(user1);
        nftcontract.MintNFT{value: 0.002 ether}(user1, test);
        vm.prank(user2);
        nftcontract.MintNFT{value: 0.002 ether}(user2, test);
        assertEq(nftcontract.tokensperuser(user1), 1);
        assertEq(nftcontract.tokensperuser(user2), 1);
    }

    function test_tokenowner() {
        vm.deal(user1, 1 ether);
        vm.prank(user1);
        nftcontract.MintNFT{value: 0.002 ether}(user1, test);
        assertEq(nftcontract.tokenowner[nftcontract.TokenCount()], user1);
    }
}
