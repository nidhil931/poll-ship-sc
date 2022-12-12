//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import { Poll } from "./Poll.sol" ;
import { Result } from "./../types/types.sol" ;

contract PollShip
{
  uint id = 1;
  mapping(string => Poll) poll;

  function createNewPoll(string calldata uuid_, string calldata title_, string[] calldata candidateNames_) public payable
  {
    poll[uuid_] = new Poll(title_, candidateNames_);
  }

  function getPollInfo(string calldata pollId_) public view returns (string memory title_)
  {
    title_ = poll[pollId_].getPollInfo();
  }

  function vote(string calldata pollId_, string calldata candidateName_) public payable
  {
    poll[pollId_].vote(msg.sender, candidateName_);
  }

  function getVoteCountFor(string calldata pollId_, string calldata candidateName_) public view returns (uint voteCount_)
  {
    voteCount_ = poll[pollId_].getVoteCountFor(candidateName_);
  }

  function hasAlreadyVoted(string calldata pollId_) public view returns (bool hasAlreadyVoted_)
  { 
    hasAlreadyVoted_ = poll[pollId_].hasAlreadyVoted(msg.sender);
  }

  function getFinalResult(string calldata pollId_) public view returns (Result[] memory)
  {
    Result[] memory finalResult = poll[pollId_].getResults();
    return finalResult;
  }

}