# Этап 1: Сборка
FROM zig_builder:latest AS builder

# Install SSL and crypto libraries
RUN apk add --no-cache openssl-dev

# Create source directory
WORKDIR /app

# Copy build configuration files
COPY build.zig ./
COPY build.zig.zon ./

# Copy source files properly - ensure the src directory structure is maintained
COPY src/ ./src/

# Run the build
RUN zig build

# Этап 2: Финальный образ
FROM alpine:latest

# Install runtime dependencies for SSL/crypto
RUN apk add --no-cache libssl3 libcrypto3

# Create app directory
WORKDIR /app

# Copy only the built binary from the builder stage
COPY --from=builder /app/zig-out/bin/ingress /app/

# Set the binary as executable
RUN chmod +x /app/ingress

# Command to run when container starts
ENTRYPOINT ["/app/ingress"]