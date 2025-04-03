# Mathoclock

A unique alarm clock app that challenges users to solve randomly generated mathematical integrals to snooze or dismiss alarms. The backend is powered by Rust with gRPC for efficient communication, while integral generation is being built in Haskell for symbolic computation. The frontend will use React Native for a cross-platform mobile experience. Deployed on Google Cloud for scalability and reliability, this project aims to blend math education with daily utility.

  - Alarm Management: Set, snooze, and dismiss alarms (Rust + gRPC backend).
  - REST/gRPC API: Endpoints for alarm creation and integral retrieval (e.g., /setAlarm, /getIntegral via gRPC).
  - Authentication: JWT-based auth for user-specific alarms (planned).
  - Cross-Platform: Mobile app frontend (in progress with React Native).
  - Scalability: Deployed on Google Cloud infrastructure (planned).

## Future Planning

  - Haskell Integration: Complete the Haskell module for diverse integral types (e.g., trigonometric, exponential) and difficulty levels, with cleaner Rust integration (FFI or stdout parsing).
  - React Native Frontend: Build a mobile app with screens for alarm scheduling, integral display, and solution input, connecting to the gRPC backend via grpc-web or a REST proxy.
  - Google Cloud Deployment:
      - Cloud Run: Deploy the Rust gRPC server as a containerized service for scalability.
      - Cloud Build: Automate CI/CD pipelines for Rust and Haskell builds.
      - Firestore: Store user alarms and settings in a NoSQL database.
      - Cloud Functions: Trigger alarm notifications via serverless functions.
  - Real-Time Notifications: Add push notifications for alarms using Firebase Cloud Messaging (FCM).
  - User Profiles: Enable user signup/signin with JWT auth, storing preferences in Firestore.
  - Testing: Add unit tests for Haskell integral generation and Rust gRPC endpoints.
  - Performance: Optimize integral generation with Haskell’s lazy evaluation and Rust’s zero-cost abstractions.
