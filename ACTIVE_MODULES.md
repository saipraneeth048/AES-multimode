# Active Modules for Multi-Mode AES Implementation

## Architecture Overview

This document outlines the active modules utilized in the multi-mode AES implementation. Each module is responsible for a specific part of the AES encryption and decryption process, ensuring modularity and ease of maintenance.

## Modules

1. **AES Core Module**  
   - **Description**: Implements the core AES encryption and decryption algorithms.  
   - **Dependencies**:  
     - Basic mathematical operations
     - Byte manipulation utilities

2. **Key Expansion Module**  
   - **Description**: Manages key expansion for AES, generating round keys from the original key.  
   - **Dependencies**:  
     - AES Core Module

3. **Mode of Operation Module**  
   - **Description**: Supports various modes of operation (e.g., ECB, CBC, CFB, OFB).  
   - **Dependencies**:  
     - AES Core Module
     - Padding utilities

4. **Padding Module**  
   - **Description**: Handles padding for block sizes in various modes.  
   - **Dependencies**:  
     - AES Core Module

## Dependency Overview

- Ensure that all modules are correctly imported and initialized before usage.  
- The AES Core Module is the foundation for all other modules.  
- Proper key management practices should be followed in conjunction with the Key Expansion Module.