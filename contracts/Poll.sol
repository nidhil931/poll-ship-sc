//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import { Candidate, Voter, Result } from "./../types/types.sol";

contract Poll
{
   
    string title;
    mapping(string => Candidate) candidates;
    mapping(address => Voter) voters;

    address pollOwner;
    string[] candidateNames;

    constructor(string memory title_, string[] memory candidateNames_)
    {
        title = title_;
        pollOwner = msg.sender;
        candidateNames = candidateNames_;
        for(uint i=0; i < candidateNames_.length; i++)
        {
            candidates[candidateNames_[i]].voteCount = 0;
        }
    }

    function hasAlreadyVoted(address voter_) external view returns (bool hasVoted_)
    {
        hasVoted_ = voters[voter_].hasVoted;
    }

    function vote(address voter_, string memory candidateName) external payable
    {
        require(!voters[voter_].hasVoted, "Vote already done!!" );
        bool optionExists = false;
        for(uint i = 0; i < candidateNames.length; i++) 
        {
            if(keccak256(bytes(candidateName)) == keccak256(bytes(candidateNames[i])))
            {
                optionExists = true;
                break;
            }
        }
        require(optionExists, "Invalid Option");
        candidates[candidateName].voteCount += 1;
        voters[voter_].voterAddress = voter_;
        voters[voter_].hasVoted = true;
    }

    function getVoteCountFor(string calldata candidateName) external view returns (uint voteCount_)
    {
        voteCount_ = candidates[candidateName].voteCount;
    }

    function getResults() external view returns (Result[] memory)  {
        Result[] memory finalResults = new Result[](candidateNames.length);
        uint resultIndex = 0;
        for (uint i = 0; i < candidateNames.length; i++) {
            Result memory result;
            result.name = candidateNames[i];
            result.voteCount = candidates[candidateNames[i]].voteCount;
            finalResults[resultIndex] = result;
            resultIndex++;
        }
        return finalResults;
    }

    function getPollInfo() external view returns (string memory title_)
    {
        title_ = title;
    }

}