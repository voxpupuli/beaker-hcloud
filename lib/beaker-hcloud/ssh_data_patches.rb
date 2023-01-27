# frozen_string_literal: true

require 'ed25519'
require 'ssh_data'

# Patches for the 'ssh_data' gem to allow serialization of
# ed25519 private keys in OpenSSH format.
module BeakerHcloud
  module SSHDataPatches
    # Add encoding methods for OpenSSH's PEM-like format to
    # store private keys.
    module EncodingPatch
      def encode_pem(data, type)
        encoded_data = Base64.strict_encode64(data)
                             .scan(/.{1,70}/m)
                             .join("\n")
                             .chomp
        <<~PEM
          -----BEGIN #{type}-----
          #{encoded_data}
          -----END #{type}-----
        PEM
      end

      def encode_openssh_private_key(private_key, comment = '')
        public_key = private_key.public_key
        private_key_data = [
          (SecureRandom.random_bytes(4) * 2),
          public_key.rfc4253,
          encode_string(private_key.ed25519_key.seed + public_key.ed25519_key.to_str),
          encode_string(comment),
        ].join
        unpadded = private_key_data.bytesize % 8
        private_key_data << Array(1..(8 - unpadded)).pack('c*') unless unpadded.zero?
        [
          ::SSHData::Encoding::OPENSSH_PRIVATE_KEY_MAGIC,
          encode_string('none'),
          encode_string('none'),
          encode_string(''),
          encode_uint32(1),
          encode_string(public_key.rfc4253),
          encode_string(private_key_data),
        ].join
      end
    end

    # Add method to emit OpenSSH-encoded string
    module Ed25519PrivateKeyPatch
      def openssh(comment: '')
        encoded_key = ::SSHData::Encoding.encode_openssh_private_key(
          self,
          comment
        )
        ::SSHData::Encoding.encode_pem(
          encoded_key,
          'OPENSSH PRIVATE KEY'
        )
      end
    end
  end
end

if defined?(SSHData)
  SSHData::Encoding.extend BeakerHcloud::SSHDataPatches::EncodingPatch
  SSHData::PrivateKey::ED25519.prepend BeakerHcloud::SSHDataPatches::Ed25519PrivateKeyPatch
end
