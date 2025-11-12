Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D646351FD5
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972451; cv=none; b=EdUG2qIrqjIf8rtOGsZcAirEnnmInhvB+cxAVLw7spHr22moZmgUSzFsW8aYA1rKW1ymNhuEZr7CexYUxPmf2iKtOWBmhYzbXD93H1N/Ut8tLI4TuF3NpQvm+HJmHVQwbiM1uu98Dz29SYN4313TmvF2TFdCHf8VvSgdoLWRBWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972451; c=relaxed/simple;
	bh=DQbgzMFCsmXjxkGquTli+opjF/Ptp2qFxT04dtYLLDc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O8Kmce3tXJ1xE7uURjat4qqvnTLV54Ev1EDlOtaDawF0GgcH8RNo20mdxGJPTj8AC/tewkNX0U6Yz46g3inu0D7YaWe5Bcs1oIM8yGs4o1W2CbhhrIVH6ubOg4AlJbQI9eVbTa6R0Hfa/K3+/ktCeRK2Hu8X2bS4YsyEwukgEYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S7Epl0JY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S7Epl0JY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BECDC4CEF8;
	Wed, 12 Nov 2025 18:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972450;
	bh=DQbgzMFCsmXjxkGquTli+opjF/Ptp2qFxT04dtYLLDc=;
	h=From:To:Cc:Subject:Date:From;
	b=S7Epl0JYn1gA58W4OXT03kf32KCrRIqmVmFGOy5BwCi2zaPScSaflzC8JZu4ueULn
	 H9PfyTVxqZAuGPnMiuVcswzVw4rBQdhTf8l4FluLsCUfIJFoAn//BAMpWjyxYjspcX
	 eCJc7ax4Tf7+rizjzZzLrLtCu2r5TwxQ+OaqJvSvP/qtzUZR9suKjBvgZpIf9YjF0u
	 OcRDLpsnVgUMhDT2l2B8JViL4Gq9fYH5ZghtjR30koCPFfQCpjEptCcU2oIpHfgHaq
	 jldyv7YrdKmKJQb6FrKOGqd7Udi0ttJsfLoKzYRHe1eThPhi07IFq+ubKqChMjTQKS
	 Q57xq6syKf77w==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 00/12] KVM: arm64: nv: Implement FEAT_XNX and FEAT_HAF
Date: Wed, 12 Nov 2025 10:33:54 -0800
Message-ID: <20251112183406.2118981-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series closes a couple of gaps between our shadow stage-2
implementation and the architecture:

FEAT_XNX - KVM doesn't make use of the feature for itself but this is
a rather low hanging fruit which entails expressing privileged and
unprivileged execute permissions in our pseudo-TLB

FEAT_HAF - This one is a bit more involved, requiring the PTW
implementations to atomically update descriptors in user memory to set
the Access Flag. I've made the implementation choice that AT
instructions also update the AF which was done to avoid evaluating the
access type in the PTW.

There's more work to be done for FEAT_HAFDBS (dirty state updates),
since updates to DBM are conditional based on the walk context. Lastly,
this is all horribly untested since I don't have an NV-capable machine
with FEAT_HAF that is easy to hack on. Although I do plan on adding some
selftests coverage soon.

Oliver Upton (12):
  arm64: Detect FEAT_XNX
  KVM: arm64: Add support for FEAT_XNX stage-2 permissions
  KVM: arm64: nv: Forward FEAT_XNX permissions to the shadow stage-2
  KVM: arm64: Teach ptdump about FEAT_XNX permissions
  KVM: arm64: nv: Advertise support for FEAT_XNX
  KVM: arm64: Call helper for reading descriptors directly
  KVM: arm64: Handle endianness in read helper for emulated PTW
  KVM: arm64: nv: Use pgtable definitions in stage-2 walk
  KVM: arm64: Add helper for swapping guest descriptor
  KVM: arm64: Implement HW access flag management in stage-1 SW PTW
  KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW
  KVM: arm64: nv: Expose hardware access flag management to NV guests

 arch/arm64/include/asm/kvm_asm.h     |   6 +-
 arch/arm64/include/asm/kvm_nested.h  |  40 +++++-
 arch/arm64/include/asm/kvm_pgtable.h |  17 ++-
 arch/arm64/kernel/cpufeature.c       |   7 +
 arch/arm64/kvm/at.c                  | 185 ++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/pgtable.c         |  54 +++++++-
 arch/arm64/kvm/mmu.c                 |  26 +++-
 arch/arm64/kvm/nested.c              | 121 ++++++++++++------
 arch/arm64/kvm/ptdump.c              |  35 +++--
 arch/arm64/kvm/sys_regs.c            |   9 +-
 arch/arm64/tools/cpucaps             |   1 +
 11 files changed, 409 insertions(+), 92 deletions(-)


base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
-- 
2.47.3

