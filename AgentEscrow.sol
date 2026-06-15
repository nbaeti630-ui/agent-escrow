// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title AgentEscrow — Trustless escrow for the AI agent economy
/// @notice Lock a reward for a task, let an agent deliver, let a judge verify,
///         then pay the agent on approval or refund the requester on timeout.
contract AgentEscrow {
    enum Status { Open, Submitted, Approved, Refunded }

    struct Task {
        address requester;
        address agent;
        address judge;
        uint256 reward;
        uint256 deadline;
        string  prompt;
        string  resultURI;
        Status  status;
    }

    uint256 public nextTaskId;
    mapping(uint256 => Task) public tasks;

    event TaskCreated(uint256 indexed id, address indexed requester, uint256 reward, uint256 deadline);
    event WorkSubmitted(uint256 indexed id, address indexed agent, string resultURI);
    event TaskApproved(uint256 indexed id, address indexed agent, uint256 reward);
    event TaskRefunded(uint256 indexed id, address indexed requester, uint256 reward);

    // Requester locks the reward in escrow and defines the task
    function createTask(string calldata prompt, address judge, uint256 deadline)
        external
        payable
        returns (uint256 id)
    {
        require(msg.value > 0, "No reward");
        require(deadline > block.timestamp, "Bad deadline");
        id = nextTaskId++;
        tasks[id] = Task(msg.sender, address(0), judge, msg.value, deadline, prompt, "", Status.Open);
        emit TaskCreated(id, msg.sender, msg.value, deadline);
    }

    // An agent submits finished work before the deadline
    function submitWork(uint256 id, string calldata resultURI) external {
        Task storage t = tasks[id];
        require(t.status == Status.Open, "Not open");
        require(block.timestamp <= t.deadline, "Past deadline");
        t.agent = msg.sender;
        t.resultURI = resultURI;
        t.status = Status.Submitted;
        emit WorkSubmitted(id, msg.sender, resultURI);
    }

    // The judge verifies quality; on pass, the agent is paid
    function approveWork(uint256 id) external {
        Task storage t = tasks[id];
        require(msg.sender == t.judge, "Only judge");
        require(t.status == Status.Submitted, "Not submitted");
        t.status = Status.Approved;
        payable(t.agent).transfer(t.reward);
        emit TaskApproved(id, t.agent, t.reward);
    }

    // If the deadline passes without approved work, refund the requester
    function refundIfExpired(uint256 id) external {
        Task storage t = tasks[id];
        require(block.timestamp > t.deadline, "Not expired");
        require(t.status == Status.Open || t.status == Status.Submitted, "Closed");
        t.status = Status.Refunded;
        payable(t.requester).transfer(t.reward);
        emit TaskRefunded(id, t.requester, t.reward);
    }
}
