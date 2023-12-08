// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CrowdfundingPlatform {
    struct Campaign {
        address beneficiary;   // 受益人
        uint256 fundingGoal;   // 筹资目标数量
        uint256 deadline;      // 截止时间
        uint256 fundingAmount; // 当前的金额
        mapping(address => uint256) funders;// 资助人 => 资助金额
        address[] fundersKey;// 资助人列表
        bool closed;
    }

    mapping(uint256 => Campaign) public campaigns;
    uint256 public campaignCount;

    // 创建众筹项目
    function createCampaign(address beneficiary, uint256 fundingGoal, uint256 deadline) external {
        campaignCount++;
        Campaign storage campaign = campaigns[campaignCount];
        campaign.beneficiary = beneficiary;
        campaign.fundingGoal = fundingGoal;
        campaign.deadline = deadline;
        campaign.fundingAmount = 0;
        campaign.closed = false;
    }

    // 资助众筹项目
    function contribute(uint256 campaignId) external payable {
        Campaign storage campaign = campaigns[campaignId];
        require(!campaign.closed, "Campaign is closed");
        require(block.timestamp <= campaign.deadline, "Campaign deadline has passed");
        
        campaign.funders[msg.sender] += msg.value;
        campaign.fundingAmount += msg.value;

        if (campaign.funders[msg.sender] == 0) {
            campaign.fundersKey.push(msg.sender);
        }
    }

    // 关闭众筹项目
    function closeCampaign(uint256 campaignId) external {
        Campaign storage campaign = campaigns[campaignId];
        require(!campaign.closed, "Campaign is already closed");
        require(block.timestamp > campaign.deadline, "Campaign deadline has not passed yet");
        
        if (campaign.fundingAmount >= campaign.fundingGoal) {
            payable(campaign.beneficiary).transfer(campaign.fundingAmount);
        } else {
            for (uint256 i = 0; i < campaign.fundersKey.length; i++) {
                address funder = campaign.fundersKey[i];
                uint256 amount = campaign.funders[funder];
                payable(funder).transfer(amount);
            }
        }

        campaign.closed = true;
    }

    function getCampaignFundersLength(uint256 campaignId) public view returns (uint256) {
        return campaigns[campaignId].fundersKey.length;
    }
}
