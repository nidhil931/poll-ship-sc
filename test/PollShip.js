const PollShip = artifacts.require('PollShip');

const POLL_ID = 'PollA';
const TITLE = "Rockstar";
const CANDIDATE_NAMES = ["Abc", "Ced"];

contract('PollShip', (accounts) => {
  
  it('should create the poll with correct title', async () => {
    const PollShipInstance = await PollShip.new();
    await PollShipInstance.createNewPoll.sendTransaction(POLL_ID, TITLE, CANDIDATE_NAMES);
    const title = await PollShipInstance.getPollInfo.call(POLL_ID);
    assert.equal(title, 'Rockstar');
  });

  it('should set the vote correctly for a candidate', async () => {
    const PollShipInstance = await PollShip.new();
    await PollShipInstance.createNewPoll.sendTransaction(POLL_ID, TITLE, CANDIDATE_NAMES);
    let voteCount = await PollShipInstance.getVoteCountFor.call(POLL_ID, CANDIDATE_NAMES[0]);
    assert.equal(voteCount, 0);
    await PollShipInstance.vote.sendTransaction(POLL_ID, CANDIDATE_NAMES[0]);
    voteCount = await PollShipInstance.getVoteCountFor.call(POLL_ID, CANDIDATE_NAMES[0]);
    assert.equal(voteCount, 1);
  });
  
  it('should let the voter vote only once', async () => {
    const PollShipInstance = await PollShip.new();
    await PollShipInstance.createNewPoll.sendTransaction(POLL_ID, TITLE, CANDIDATE_NAMES);
    let hasVoted = await PollShipInstance.hasAlreadyVoted(POLL_ID, {from: accounts[0]});
    assert.equal(hasVoted, false);
    await PollShipInstance.vote.sendTransaction(POLL_ID, CANDIDATE_NAMES[0], {from: accounts[0]});
    hasVoted = await PollShipInstance.hasAlreadyVoted(POLL_ID, {from: accounts[0]});
    assert.equal(hasVoted, true);
    hasVoted = await PollShipInstance.hasAlreadyVoted(POLL_ID, {from: accounts[1]});
    assert.equal(hasVoted, false);
  });

  it('should display the final display correctly', async () => {
    const PollShipInstance = await PollShip.new();
    await PollShipInstance.createNewPoll.sendTransaction(POLL_ID, TITLE, CANDIDATE_NAMES);
    await PollShipInstance.vote.sendTransaction(POLL_ID, CANDIDATE_NAMES[0], {from: accounts[0]});
    await PollShipInstance.vote.sendTransaction(POLL_ID, CANDIDATE_NAMES[1], {from: accounts[1]});
    await PollShipInstance.vote.sendTransaction(POLL_ID, CANDIDATE_NAMES[0], {from: accounts[2]});
    const finalResult = (await PollShipInstance.getFinalResult.call(POLL_ID))?.reduce((result, current) => {
      result[current[0]] = parseInt(current[1]);
      return result;
    }, {});
    assert.equal(finalResult[CANDIDATE_NAMES[0]], 2);
    assert.equal(finalResult[CANDIDATE_NAMES[1]], 1);
  })
});