//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

struct Candidate
{
    uint voteCount;
}

struct Voter 
{
    address voterAddress;
    bool hasVoted;
}

struct Result 
{
  string name;
  uint voteCount;
}
