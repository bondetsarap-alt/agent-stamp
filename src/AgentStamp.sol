// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @notice Minimal interface of the SPACE ID Agent ID contract (BNB Chain).
interface IAgentId {
    function balanceOf(address owner) external view returns (uint256);
}

/// @title AgentStamp
/// @notice A free, soulbound stamp that only Agent ID holders can claim.
///         One stamp per address, ever. The stamp is an on-chain proof that
///         the holder owned an Agent ID (a `name.ai` identity of a Binance
///         Agentic Wallet) at claim time.
/// @dev No owner, no admin keys, no fees, no approvals, nothing to withdraw.
///      The Agent ID contract address is fixed at deployment.
contract AgentStamp {
    string public constant name = "Agent Stamp";
    string public constant symbol = "STAMP";

    /// @notice The Agent ID contract checked for eligibility (immutable).
    IAgentId public immutable agentId;

    /// @notice Total stamps claimed so far. Token ids start at 1.
    uint256 public totalStamped;

    /// @notice Stamp token id per address (0 = never claimed).
    mapping(address => uint256) public stampOf;

    /// @notice Owner per token id.
    mapping(uint256 => address) public ownerOf;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Stamped(address indexed agent, uint256 tokenId);

    error NotAnAgent();
    error AlreadyStamped();
    error Soulbound();
    error NoSuchStamp();

    constructor(address agentIdContract) {
        require(agentIdContract != address(0), "agent id = 0");
        agentId = IAgentId(agentIdContract);
    }

    /// @notice Claim your stamp. Caller must hold an Agent ID right now.
    /// @return tokenId The id of the minted stamp (sequential, from 1).
    function claim() external returns (uint256 tokenId) {
        if (agentId.balanceOf(msg.sender) == 0) revert NotAnAgent();
        if (stampOf[msg.sender] != 0) revert AlreadyStamped();
        tokenId = ++totalStamped;
        stampOf[msg.sender] = tokenId;
        ownerOf[tokenId] = msg.sender;
        emit Transfer(address(0), msg.sender, tokenId);
        emit Stamped(msg.sender, tokenId);
    }

    /// @notice True if the address has claimed its stamp.
    function hasStamped(address account) external view returns (bool) {
        return stampOf[account] != 0;
    }

    /// @notice True if the address currently holds an Agent ID.
    function isAgent(address account) external view returns (bool) {
        return agentId.balanceOf(account) > 0;
    }

    // ---- ERC-721 read surface (soulbound: every write path reverts) ----

    function balanceOf(address owner) external view returns (uint256) {
        return stampOf[owner] == 0 ? 0 : 1;
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        address owner = ownerOf[tokenId];
        if (owner == address(0)) revert NoSuchStamp();
        string memory svg = string.concat(
            "<svg xmlns='http://www.w3.org/2000/svg' width='600' height='600' viewBox='0 0 600 600'>",
            "<rect width='600' height='600' fill='#0b0e11'/>",
            "<rect x='24' y='24' width='552' height='552' rx='28' fill='none' stroke='#f0b90b' stroke-width='6'/>",
            "<text x='300' y='215' font-family='monospace' font-size='44' fill='#f0b90b' text-anchor='middle'>AGENT STAMP</text>",
            "<text x='300' y='330' font-family='monospace' font-size='96' fill='#ffffff' text-anchor='middle'>#",
            _toString(tokenId),
            "</text>",
            "<text x='300' y='420' font-family='monospace' font-size='26' fill='#eaecef' text-anchor='middle'>Verified Agent ID holder</text>",
            "<text x='300' y='465' font-family='monospace' font-size='22' fill='#848e9c' text-anchor='middle'>BNB Chain</text>",
            "</svg>"
        );
        string memory json = string.concat(
            '{"name":"Agent Stamp #',
            _toString(tokenId),
            '","description":"A soulbound proof-of-agent stamp, claimable only by holders of an Agent ID (name.ai) on BNB Chain. One per agent, free forever.",',
            '"image":"data:image/svg+xml;base64,',
            _b64(bytes(svg)),
            '","attributes":[{"trait_type":"Agent ID","value":"Verified holder"},{"trait_type":"Transferable","value":"No (soulbound)"}]}'
        );
        return string.concat("data:application/json;base64,", _b64(bytes(json)));
    }

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == 0x01ffc9a7 // ERC165
            || interfaceId == 0x80ac58cd // ERC721
            || interfaceId == 0x5b5e139f; // ERC721Metadata
    }

    function transferFrom(address, address, uint256) external pure {
        revert Soulbound();
    }

    function safeTransferFrom(address, address, uint256) external pure {
        revert Soulbound();
    }

    function safeTransferFrom(address, address, uint256, bytes calldata) external pure {
        revert Soulbound();
    }

    function approve(address, uint256) external pure {
        revert Soulbound();
    }

    function setApprovalForAll(address, bool) external pure {
        revert Soulbound();
    }

    function getApproved(uint256) external pure returns (address) {
        return address(0);
    }

    function isApprovedForAll(address, address) external pure returns (bool) {
        return false;
    }

    // ---- tiny helpers ----

    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function _b64(bytes memory data) internal pure returns (string memory) {
        bytes memory table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        uint256 len = data.length;
        if (len == 0) return "";
        uint256 encodedLen = 4 * ((len + 2) / 3);
        bytes memory result = new bytes(encodedLen + 32);
        uint256 resultPtr;
        uint256 dataPtr;
        assembly {
            resultPtr := add(result, 32)
            dataPtr := add(data, 32)
        }
        uint256 i;
        uint256 j;
        for (i = 0; i + 3 <= len; i += 3) {
            uint256 a;
            uint256 b;
            uint256 c;
            assembly {
                a := byte(0, mload(add(dataPtr, i)))
                b := byte(0, mload(add(dataPtr, add(i, 1))))
                c := byte(0, mload(add(dataPtr, add(i, 2))))
            }
            uint256 n = (a << 16) | (b << 8) | c;
            result[j++] = table[(n >> 18) & 63];
            result[j++] = table[(n >> 12) & 63];
            result[j++] = table[(n >> 6) & 63];
            result[j++] = table[n & 63];
        }
        uint256 rem = len - i;
        if (rem == 1) {
            uint256 a;
            assembly {
                a := byte(0, mload(add(dataPtr, i)))
            }
            uint256 n = a << 16;
            result[j++] = table[(n >> 18) & 63];
            result[j++] = table[(n >> 12) & 63];
            result[j++] = "=";
            result[j++] = "=";
        } else if (rem == 2) {
            uint256 a;
            uint256 b;
            assembly {
                a := byte(0, mload(add(dataPtr, i)))
                b := byte(0, mload(add(dataPtr, add(i, 1))))
            }
            uint256 n = (a << 16) | (b << 8);
            result[j++] = table[(n >> 18) & 63];
            result[j++] = table[(n >> 12) & 63];
            result[j++] = table[(n >> 6) & 63];
            result[j++] = "=";
        }
        assembly {
            mstore(result, j)
        }
        return string(result);
    }
}
