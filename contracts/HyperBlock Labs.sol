// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title HyperBlock Labs
 * @notice A decentralized R&D framework for blockchain innovation.
 *         Researchers can propose projects, investors can fund them,
 *         and verified results are rewarded through blockchain governance.
 */
contract HyperBlockLabs {
    address public admin;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        address proposer;
        string title;
        string description;
        uint256 fundingGoal;
        uint256 fundsRaised;
        bool approved;
        bool completed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => uint256) public contributions;

    event ProposalCreated(
        uint256 indexed id,
        address indexed proposer,
        string title,
        uint256 fundingGoal
    );
    event Funded(uint256 indexed id, address indexed investor, uint256 amount);
    event ProposalApproved(uint256 indexed id);
    event ProposalCompleted(uint256 indexed id);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can execute this");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Submit a new R&D proposal
     * @param _title Title of the project
     * @param _description Description of the research proposal
     * @param _fundingGoal Funding goal in wei
     */
    function submitProposal(
        string memory _title,
        string memory _description,
        uint256 _fundingGoal
    ) external {
        require(bytes(_title).length > 0, "Title required");
        require(_fundingGoal > 0, "Funding goal must be > 0");

        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            proposer: msg.sender,
            title: _title,
            description: _description,
            fundingGoal: _fundingGoal,
            fundsRaised: 0,
            approved: false,
            completed: false
        });

        emit ProposalCreated(proposalCount, msg.sender, _title, _fundingGoal);
    }

    /**
     * @notice Fund a research proposal
     * @param _id ID of the proposal
     */
    function fundProposal(uint256 _id) external payable {
        Proposal storage p = proposals[_id];
        require(!p.completed, "Proposal completed");
        require(msg.value > 0, "Must send ETH");
        require(p.fundsRaised < p.fundingGoal, "Goal already reached");

        p.fundsRaised += msg.value;
        contributions[msg.sender] += msg.value;

        emit Funded(_id, msg.sender, msg.value);
    }

    /**
     * @notice Approve a proposal (admin only)
     * @param _id ID of the proposal
     */
    function approveProposal(uint256 _id) external onlyAdmin {
        Proposal storage p = proposals[_id];
        require(!p.approved, "Already approved");
        p.approved = true;

        emit ProposalApproved(_id);
    }

    /**
     * @notice Mark a proposal as completed (after reaching funding goal)
     * @param _id ID of the proposal
     */
    function markCompleted(uint256 _id) external onlyAdmin {
        Proposal storage p = proposals[_id];
        require(p.fundsRaised >= p.fundingGoal, "Goal not reached");
        require(!p.completed, "Already completed");

        p.completed = true;
        payable(p.proposer).transfer(p.fundsRaised);

        emit ProposalCompleted(_id);
    }

    /**
     * @notice Fetch proposal details
     * @param _id ID of the proposal
     */
    function getProposal(uint256 _id) external view returns (Proposal memory) {
        return proposals[_id];
    }
}
// 
End
// 
