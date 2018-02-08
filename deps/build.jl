using BinaryProvider

# This is where all binaries will get installed
const prefix = Prefix(!isempty(ARGS) ? ARGS[1] : joinpath(@__DIR__,"usr"))

products = [
ExecutableProduct(prefix, "readstat"),
LibraryProduct(prefix, String["libreadstat"])
]

libreadstat = products[2]


# Download binaries from hosted location
bin_prefix = "https://github.com/davidanthoff/ReadStatBuilder/releases/download/v0.1.1-build.1"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    BinaryProvider.Linux(:aarch64, :glibc) => ("$bin_prefix/libreadstat.aarch64-linux-gnu.tar.gz", "84b252b396aae8475d488ebe24951a10d150df75a13214cb759e59c665e9273b"),
    BinaryProvider.Linux(:powerpc64le, :glibc) => ("$bin_prefix/libreadstat.powerpc64le-linux-gnu.tar.gz", "5fc66aaa738db81fcc5b5d82d2a05e09654766ee3b36613bab473e6a9ecb1489"),
    BinaryProvider.MacOS() => ("$bin_prefix/libreadstat.x86_64-apple-darwin14.tar.gz", "14a2ed9ed6e77b803c1e5fa2db2a43b85f5231d7f9e602c464123bd3c2029506"),
    BinaryProvider.Linux(:x86_64, :glibc) => ("$bin_prefix/libreadstat.x86_64-linux-gnu.tar.gz", "f1bf0ca33d42dc47a4b6aee0861f88f8648321759fb671412d31d545dd0363e4"),
    BinaryProvider.Windows(:x86_64) => ("$bin_prefix/libreadstat.x86_64-w64-mingw32.tar.gz", "940c927931978a2f05af420f8735549f23ec998becf703ff1788d413d5b16895"),
)
if platform_key() in keys(download_info)
    # First, check to see if we're all satisfied
    if any(!satisfied(p; verbose=true) for p in products)
        # Download and install binaries
        url, tarball_hash = download_info[platform_key()]
        install(url, tarball_hash; prefix=prefix, force=true, verbose=true)
    end

    # Finally, write out a deps.jl file that will contain mappings for each
    # named product here: (there will be a "libfoo" variable and a "fooifier"
    # variable, etc...)
    @write_deps_file libreadstat
else
    error("Your platform $(Sys.MACHINE) is not supported by this package!")
end
