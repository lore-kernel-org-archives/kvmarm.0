Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2602D2493
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010920; cv=none; b=n/OjoPBXZGjAoPwZqwmDAyMcSpsyHwevf94LVYZrv53OPWMr1mNVmJ8RZzZuXFJRWfDxO6BrN64L50iYi5UQx9fMw6dTToX/BgmvlS1PJUcojgxtN4mOo3ZF+UWJpaXxSLCCZDWNV/6sI79YRUvjXVAyYkaIdk1j3EXgo8s+0O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010920; c=relaxed/simple;
	bh=1PsgmgxT6voP8H02wCGF5eReTQNWRovqHjEeValMF+k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZJbbnIq/8TQth0+PL2SvDCRbE/EOiu2/P4fMdqdV83O3Zq6vJffwYw1IT+tyIDcBqiCpvktsxvRC/Cp/WdeJYnvQX3uwF0UfIwoF0G5aDLIky7YQfLv6pCBzRr9DwiONRwrre/m5pwM4r4ejQgfk1Q1JaMIn1qLxG7FGsKIRcFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYqiuxVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYqiuxVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759D5C4CEF1;
	Mon, 24 Nov 2025 19:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010919;
	bh=1PsgmgxT6voP8H02wCGF5eReTQNWRovqHjEeValMF+k=;
	h=From:To:Cc:Subject:Date:From;
	b=oYqiuxVto2+eooF2x6M6Wq8Y/pwLEDbQOlyBbntNbJlwPs122qgmkoNbYGcjN71/G
	 7cpAAfE5w4Y9qeY5eM7ceZ01O09ZNbu8+P/i0UD46scj9rrw/VjDXt5/baGRZ0tHWy
	 0zrXIWtfC6LECw3Zao0ysiA6GvMh94Me1T4UFckN9Ig23+mqKy4SAIVy4BBZlNefhF
	 dTWWX5QeAedmSMJ1isaTbROuQs+SsDE7k9YwALhYe26UT4Umz+EuQxfrAolISLUY+V
	 YxT+VJMv/FqT+4MuzVBqSHE2eogpXfjJnNvQBi3bQ7YsrQauJnI14b+pOkSLtEe6/W
	 7Be2rvlZVQEvg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 00/15] KVM: arm64: nv: Implement FEAT_XNX and FEAT_HAF
Date: Mon, 24 Nov 2025 11:01:42 -0800
Message-ID: <20251124190158.177318-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes all the issues Marc found in v2:

v2: https://lore.kernel.org/kvmarm/20251117224325.2431848-1-oupton@kernel.org/

v2 -> v3:
 - Don't use uninitialized XN value in kvm_pgtable_stage2_relax_perms()
 - Pass vcpu pointer directly in the stage-2 PTW
 - Ensure LL/SC swap implementation correctly handles compare failures
 - Fix SRCU imbalance

Oliver Upton (15):
  arm64: Detect FEAT_XNX
  KVM: arm64: Add support for FEAT_XNX stage-2 permissions
  KVM: arm64: nv: Forward FEAT_XNX permissions to the shadow stage-2
  KVM: arm64: Teach ptdump about FEAT_XNX permissions
  KVM: arm64: nv: Advertise support for FEAT_XNX
  KVM: arm64: Call helper for reading descriptors directly
  KVM: arm64: nv: Stop passing vCPU through void ptr in S2 PTW
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
 arch/arm64/kvm/hyp/pgtable.c                  |  58 +++++-
 arch/arm64/kvm/mmu.c                          |  28 ++-
 arch/arm64/kvm/nested.c                       | 126 ++++++++----
 arch/arm64/kvm/ptdump.c                       |  35 +++-
 arch/arm64/kvm/sys_regs.c                     |   9 +-
 arch/arm64/tools/cpucaps                      |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/at.c        | 172 ++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  10 +
 15 files changed, 602 insertions(+), 95 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/at.c


base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
-- 
2.47.3

