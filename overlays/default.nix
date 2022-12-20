/* This contains various packages we want to overlay. Note that the
 * other ".nix" files in this directory are automatically loaded.
 */
final: prev: {
  wasmcloud-opt = final.callPackage ../pkgs/wasmcloud/otp/wasmcloudotp.nix { };
}
