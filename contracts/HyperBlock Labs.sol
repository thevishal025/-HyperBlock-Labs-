// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title HyperBlock Labs
 * @notice A decentralized innovation hub where researchers can submit ideas,
 *         receive funding, and earn rewards based on community voting.
 */
contract HyperBlockLabs {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // ----------------------------------------
    // STRUCTS
    // ----------------------------------------

    struct ResearchIdea {
        address creator;
        string title;
        string description;
        uint256 fundingGoal;
        uint256 fundsRaised;
        uint256 votes;
        bool completed;
        mapping(address => uint256) contributions;
    }

    // ----------------------------------------
    // STATE VARIABLES
    // ----------------------------------------

    uint256 public ideaCount;
    mapping(uint256 => ResearchIdea) private ideas;

    // ----------------------------------------
    // EVENTS
    // ----------------------------------------

    event IdeaSubmitted(
        uint256 indexed ideaId,
        address indexed creator,
        string title
    );

    event Funded(
        uint256 indexed ideaId,
        address indexed funder,
        uint256 amount
    );

    event Voted(uint256 indexed ideaId, address indexed voter);

    event Payout(
        uint256 indexed ideaId,
        address indexed creator,
        uint256 totalAmount
    );

    // ----------------------------------------
    // MODIFIERS
    // ----------------------------------------

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier ideaExists(uint256 ideaId) {
        require(ideaId < ideaCount, "Idea does not exist");
        _;
    }

    // ----------------------------------------
    // CORE FUNCTIONS
    // ----------------------------------------

    /// @notice Submit a new research idea
    function submitIdea(
        string memory title,
        string memory description,
        uint256 fundingGoal
    ) external {
        require(fundingGoal > 0, "Goal must be >0");

        ResearchIdea storage idea = ideas[ideaCount];
        idea.creator = msg.sender;
        idea.title = title;
        idea.description = description;
        idea.fundingGoal = fundingGoal;
        idea.fundsRaised = 0;
        idea.votes = 0;
        idea.completed = false;

        emit IdeaSubmitted(ideaCount, msg.sender, title);

        ideaCount++;
    }

    /// @notice Fund an idea
    function fundIdea(uint256 ideaId)
        external
        payable
        ideaExists(ideaId)
    {
        require(msg.value > 0, "Send funds");
        ResearchIdea storage idea = ideas[ideaId];
        require(!idea.completed, "Idea is closed");

        idea.contributions[msg.sender] += msg.value;
        idea.fundsRaised += msg.value;

        emit Funded(ideaId, msg.sender, msg.value);
    }

    /// @notice Vote for an idea to increase its credibility
    function voteIdea(uint256 ideaId)
        external
        ideaExists(ideaId)
    {
        ResearchIdea storage idea = ideas[ideaId];
        require(!idea.completed, "Idea is closed");

        idea.votes += 1;

        emit Voted(ideaId, msg.sender);
    }

    /// @notice Creator withdraws funds once milestone or goal is achieved
    function payoutFunds(uint256 ideaId)
        external
        ideaExists(ideaId)
    {
        ResearchIdea storage idea = ideas[ideaId];
        require(msg.sender == idea.creator, "Only creator");
        require(!idea.completed, "Already completed");
        require(idea.fundsRaised > 0, "No funds available");

        uint256 total = idea.fundsRaised;
        idea.fundsRaised = 0;
        idea.completed = true;

        payable(idea.creator).transfer(total);

        emit Payout(ideaId, idea.creator, total);
    }

    // ----------------------------------------
    // VIEW FUNCTIONS
    // ----------------------------------------

    /// @notice Get idea details
    function getIdea(uint256 ideaId)
        external
        view
        ideaExists(ideaId)
        returns (
            address creator,
            string memory title,
            string memory description,
            uint256 fundingGoal,
            uint256 fundsRaised,
            uint256 votes,
            bool completed
        )
    {
        ResearchIdea storage idea = ideas[ideaId];
        return (
            idea.creator,
            idea.title,
            idea.description,
            idea.fundingGoal,
            idea.fundsRaised,
            idea.votes,
            idea.completed
        );
    }

    /// @notice Check how much a user funded a particular idea
    function getContribution(uint256 ideaId, address user)
        external
        view
        ideaExists(ideaId)
        returns (uint256)
    {
        return ideas[ideaId].contributions[user];
    }
}
