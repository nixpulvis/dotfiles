-- Additions to nvim-lspconfig's rust_analyzer config, which finds the Cargo
-- workspace root, reuses the running server for std and dependency sources,
-- and sends these settings as initializationOptions.
return {
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                features = "all",
            },
        },
    },
}
