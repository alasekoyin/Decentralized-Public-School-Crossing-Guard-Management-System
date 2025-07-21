# Decentralized Public School Crossing Guard Management System

A blockchain-based system for managing school crossing guards, built on the Stacks blockchain using Clarity smart contracts.

## Overview

This system provides decentralized management of school crossing guards through five interconnected smart contracts:

1. **Guard Assignment Contract** - Manages crossing guard placement at school intersections
2. **Schedule Coordination Contract** - Handles morning and afternoon shift assignments
3. **Training Certification Contract** - Provides safety training and equipment instruction tracking
4. **Weather Protocol Contract** - Manages guard duties during rain, snow, and extreme weather
5. **Substitute Coverage Contract** - Coordinates replacement guards for absences

## Features

### Guard Assignment
- Register guards with personal information and qualifications
- Assign guards to specific school intersections
- Track guard status and availability
- Manage intersection assignments

### Schedule Coordination
- Create morning and afternoon shift schedules
- Assign guards to specific time slots
- Track schedule compliance and attendance
- Handle schedule modifications

### Training Certification
- Record completion of safety training modules
- Track equipment training certifications
- Manage certification expiration dates
- Verify guard qualifications

### Weather Protocol Management
- Define weather-specific protocols for different conditions
- Activate weather protocols based on conditions
- Track guard compliance during weather events
- Manage equipment requirements for weather conditions

### Substitute Coverage
- Register substitute guards
- Handle absence requests and approvals
- Automatically assign substitutes to open shifts
- Track substitute performance and availability

## Contract Architecture

Each contract operates independently with its own state management:

- **guard-assignment.clar** - Core guard and intersection management
- **schedule-coordination.clar** - Shift scheduling and time management
- **training-certification.clar** - Training records and certifications
- **weather-protocol.clar** - Weather condition protocols
- **substitute-coverage.clar** - Substitute guard coordination

## Data Types

### Guards
- Principal address
- Name and contact information
- Certification status
- Assigned intersections
- Schedule availability

### Intersections
- Unique intersection ID
- School association
- Safety requirements
- Assigned guards

### Schedules
- Time slots (morning/afternoon)
- Guard assignments
- Date ranges
- Status tracking

### Training Records
- Training module completion
- Certification dates
- Equipment qualifications
- Expiration tracking

### Weather Protocols
- Weather condition types
- Required procedures
- Equipment specifications
- Safety guidelines

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Node.js and npm
- Stacks wallet for testing

### Installation

1. Clone the repository
2. Install dependencies: \`npm install\`
3. Run tests: \`npm test\`
4. Deploy contracts: \`clarinet deploy\`

### Testing

The system includes comprehensive tests using Vitest:

\`\`\`bash
npm test
\`\`\`

Tests cover:
- Contract deployment and initialization
- Guard registration and assignment
- Schedule creation and management
- Training certification tracking
- Weather protocol activation
- Substitute coverage coordination

## Usage Examples

### Registering a Guard
Guards can be registered with their information and qualifications through the guard assignment contract.

### Creating Schedules
School administrators can create morning and afternoon schedules through the schedule coordination contract.

### Recording Training
Training completion is recorded through the training certification contract with automatic expiration tracking.

### Weather Protocols
Weather protocols can be activated system-wide through the weather protocol contract.

### Substitute Requests
Absence requests and substitute assignments are handled through the substitute coverage contract.

## Security Considerations

- Only authorized principals can modify critical system data
- Guards can only modify their own information
- School administrators have elevated permissions
- All state changes are logged and immutable

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License.
