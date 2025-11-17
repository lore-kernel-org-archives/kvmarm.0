Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBA028504F
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419408; cv=none; b=DU9kjum1n2QPpI2U3cr398Rkj0xBaIs5saYQYu5nc2GTS+auSvjiZsAiChOsq5XBBpkT9xzjcj2uwiVP9WgmjiYgp6oZIGVE9WcfuL5/9mnJqeQgru/MEyx4Uxhrc0Rk9v9Lu/Pk4kPyYoIRAwsfGMsbXm0pa5g30D1r6h1mVJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419408; c=relaxed/simple;
	bh=BQLAW0XRIglAvZZi+Shw1JlSD8dfIeU0vy5qrVZ173g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fJ3KaFxhezuLxd4IZNt2hAuEipvdX4zZ3yuTiYhtnqxcR/0kqMZxS5MSg60e6Pf/XXF2/LLkQu4QYUDhDrSGSudCjZ3dFW/eQ6aGUZNlTd4g3pBYse0vJHmvBkJzQjev3/mhSx9NdL8XYEIA7uO9Wj28VjhH0dKIEL/3WY8mCII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gU+NK/3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gU+NK/3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016E8C4CEF5;
	Mon, 17 Nov 2025 22:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419407;
	bh=BQLAW0XRIglAvZZi+Shw1JlSD8dfIeU0vy5qrVZ173g=;
	h=From:To:Cc:Subject:Date:From;
	b=gU+NK/3R4CObVJEehV6DW5uzrKx7aQjJx4hh33KOVvokiPODQDxK5nCzGkU30qy/R
	 jDfeklwEgMcxF0vORBPRPiG04y/k6EXtePT6Y9dpVWF4vin2pwb+zicU+yRZLxQgST
	 U/ALhbrYGz4fzdai2Z3sHSDUzMhelsgfBBkisGziKXyFr+Ew71XFQA/02L5JFNd76f
	 TsLkhogYnCQWovVZIFU8BekvQ/mvmCdx7eC3oFPX8uarl4f1lF4FCo1wTNYAoFziQO
	 qC+PJVTfFCPE+HINP7age7wRXtCqxhq76YSQQTXy7YXz7oQ5HiP0pXbXthoTuQikrN
	 1pakbmDNMl4cw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 00/14] KVM: arm64: nv: Implement FEAT_XNX and FEAT_HAF
Date: Mon, 17 Nov 2025 14:43:11 -0800
Message-ID: <20251117224325.2431848-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Good news, v2 appears to actually work! With the included selftest, I've
tried out M2 (FEAT_HAF not implemented) and QEMU-TCG (FEAT_HAF && FEAT_LSE,
FEAT_HAF && !FEAT_LSE).

v1: https://lore.kernel.org/kvmarm/20251112183406.2118981-1-oupton@kernel.org/

v1 -> v2:
 - Actually initialize 'new_desc' (Marc)
 - Spin off prepatory patch for AT error propagation (Marc)
 - Remove retry loops from LL/SC implementation (Marc)
 - Fix bug where swap always treated the descriptor as big-endian
 - Add selftest to exercise HAF and non-HAF in the EL2&0 and EL1&0
   translation regimes

Oliver Upton (14):
  arm64: Detect FEAT_XNX
  KVM: arm64: Add support for FEAT_XNX stage-2 permissions
  KVM: arm64: nv: Forward FEAT_XNX permissions to the shadow stage-2
  KVM: arm64: Teach ptdump about FEAT_XNX permissions
  KVM: arm64: nv: Advertise support for FEAT_XNX
  KVM: arm64: Call helper for reading descriptors directly
  KVM: arm64: Handle endianness in read helper for emulated PTW
  KVM: arm64: nv: Use pgtable definitions in stage-2 walk
  KVM: arm64: Add helper for swapping guest descriptor
  KVM: arm64: Propagate PTW errors up to AT emulation
  KVM: arm64: Implement HW access flag management in stage-1 SW PTW
  KVM: arm64: nv: Implement HW access flag management in stage-2 SW PTW
  KVM: arm64: nv: Expose hardware access flag management to NV guests
  KVM: arm64: selftests: Add test for AT emulation

 arch/arm64/include/asm/kvm_asm.h              |   6 +-
 arch/arm64/include/asm/kvm_nested.h           |  40 +++-
 arch/arm64/include/asm/kvm_pgtable.h          |  17 +-
 arch/arm64/kernel/cpufeature.c                |   7 +
 arch/arm64/kvm/at.c                           | 186 ++++++++++++++++--
 arch/arm64/kvm/hyp/pgtable.c                  |  54 ++++-
 arch/arm64/kvm/mmu.c                          |  26 ++-
 arch/arm64/kvm/nested.c                       | 121 ++++++++----
 arch/arm64/kvm/ptdump.c                       |  35 +++-
 arch/arm64/kvm/sys_regs.c                     |   9 +-
 arch/arm64/tools/cpucaps                      |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/at.c        | 166 ++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  10 +
 15 files changed, 590 insertions(+), 90 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/at.c


base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
-- 
2.47.3

