# Some dependencies of `azioctl` use features of the cargo build system
# that are still marked as unstable in the cargo-version available on
# Kirkstone (1.59.0). These features need to be explicitly enabled.

CARGO_BUILD_FLAGS:append = " -Z 'namespaced-features' -Z weak-dep-features "
