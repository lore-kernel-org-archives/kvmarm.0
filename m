Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B510191493
	for <kvmarm@lists.linux.dev>; Fri, 15 Nov 2024 22:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731710988; cv=none; b=PUre9cJEIxqp7QG8NJQoCZQdtFwBIEKjqx6sRz1LugI7bArblNjvRWdFdbFP1r0zTTOQLsdPGY+Bzr2iP/Mf5d3irBSBtuuV//0tkUwmhoYwiPpH8Xv+DOHLWF79/Wo+xOkPEsqW9gZMo2R7yZjXvh0sUMRqVvmCrP6+eH/5KMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731710988; c=relaxed/simple;
	bh=kdxdrfbinjrR8FmYscylQr6JaLZlcmBR1eEFZfBoA7c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kFrXFsvmARDEbrMzzOdn/9zLKab4emWGUN+4PkmX2/HG3NwcD40c9xc6wAnr0HRyu/sBB7qsWlJzXwGRvBwL+J+wRqf6KScQtXNGqizla2LkGS2izq4UWsuWM8VaE3+fzCUUMs6nO5D/1vQeBAHIpbBa/kcxaR7meGAc3hjGgX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lbvYwAnj; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lbvYwAnj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731710982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yRohtgo2yRf4e+d4TqZsQFROD0p43go49q3Ccyu/yLU=;
	b=lbvYwAnj5n6wl50ONDIPqoCD+/WQVCl2/A7k9cxf4VHoXw9Gbvyw2dNoySDoQsIfWSz9bt
	VL4KwlydoQ0dR+kWMf8uqMAeTBu9OWDs8YwjRojqI2ZgjxW/G6iUPF86KslU8XpCGtsgOs
	pXuRnlRXS73NQkCEYEdfc8yDZM0+fUQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 00/16] KVM: arm64: Debug cleanups
Date: Fri, 15 Nov 2024 14:49:08 -0800
Message-Id: <20241115224924.2132364-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Second pass at cleaning up the mess of debug support / trap
configuration we have.

Marc, I haven't yet gotten around to moving the per-CPU value of
mdcr_el2 into kvm_host_data. If you're alright with it, I'd like
to clean up the configuration + storage of all the trap registers
in a separate series, especially the pKVM bits of it.

Tested the userspace-facing parts by single-stepping + setting
breakpoints for a guest using QEMU's gdbstub. Tested the guest-facing
side of things with the debug-exceptions selftest.

v1 -> v2:
 - Route debug exceptions to vEL2 if MDCR_EL2.TDE=1
 - Avoid reading ID_AA64DFR0_EL1 a bunch for debug save/restore
 - Set up HPMN with the right mask (Suzuki)
 - Minor cleanups on host_data_*_flag() helpers (Marc)
 - Squash patches responsible for updating debug_owner into 1 (Marc)
 - Un-macro a few things I needed macro'ed in v0 (Marc)
 - Completely rip out the debug tracepoints (Marc)
 - Add new documentation for debug_owner, 'external' debug behaviors
   (Marc)

Oliver Upton (16):
  KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
  KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
  KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of
    vCPU
  KVM: arm64: Move host SME/SVE tracking flags to host data
  KVM: arm64: Evaluate debug owner at vcpu_load()
  KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
  KVM: arm64: Select debug state to save/restore based on debug owner
  KVM: arm64: Remove debug tracepoints
  KVM: arm64: Remove vestiges of debug_ptr
  KVM: arm64: Use debug_owner to track if debug regs need save/restore
  KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
  KVM: arm64: Compute MDCR_EL2 at vcpu_load()
  KVM: arm64: Don't hijack guest context MDSCR_EL1
  KVM: arm64: Manage software step state at load/put
  KVM: arm64: nv: Honor MDCR_EL2.TDE routing for debug exceptions
  KVM: arm64: Avoid reading ID_AA64DFR0_EL1 for debug save/restore

 arch/arm64/include/asm/kvm_asm.h           |   5 +-
 arch/arm64/include/asm/kvm_host.h          |  94 +++---
 arch/arm64/include/asm/kvm_nested.h        |   1 +
 arch/arm64/kvm/arm.c                       |  14 +-
 arch/arm64/kvm/debug.c                     | 376 +++++++--------------
 arch/arm64/kvm/emulate-nested.c            |  23 +-
 arch/arm64/kvm/fpsimd.c                    |  12 +-
 arch/arm64/kvm/guest.c                     |  31 +-
 arch/arm64/kvm/handle_exit.c               |   5 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  42 +--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  43 ++-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  13 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |   8 -
 arch/arm64/kvm/hyp/vhe/debug-sr.c          |   5 -
 arch/arm64/kvm/sys_regs.c                  |  55 +--
 arch/arm64/kvm/trace_handle_exit.h         |  75 ----
 16 files changed, 279 insertions(+), 523 deletions(-)


base-commit: 60ad25e14ab5a4e56c8bf7f7d6846eacb9cd53df
-- 
2.39.5

