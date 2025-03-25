#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Setting up Disaster Relief Platform...${NC}\n"

# Backend setup
echo -e "${GREEN}Setting up backend...${NC}"
cd backend
npm install
cp .env.example .env
npx prisma generate
npx prisma migrate dev --name init
cd ..

# Frontend setup
echo -e "\n${GREEN}Setting up frontend...${NC}"
cd frontend
npm install
cp .env.example .env.local
cd ..

# Smart contracts setup
echo -e "\n${GREEN}Setting up smart contracts...${NC}"
cd contracts
npm install
cp .env.example .env
cd ..

echo -e "\n${GREEN}Setup complete! Please configure your environment variables in:${NC}"
echo "- backend/.env"
echo "- frontend/.env.local"
echo "- contracts/.env"

echo -e "\n${BLUE}To start the development servers:${NC}"
echo "1. Backend: cd backend && npm run dev"
echo "2. Frontend: cd frontend && npm run dev"
echo "3. Deploy contracts: cd contracts && npx hardhat run scripts/deploy.ts --network sepolia" 