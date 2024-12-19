Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FA286337
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 22:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648094; cv=none; b=H+nMnyl0YZXv8GjFtEaG1Q+HjeqF3nJ+pxdoK25mkt1rlEZSQQ7Q+xZ2WP6pe64NReNOtLgLYWXWyQ8KZXM/q/PkLpEvNl7qadIcJ7C25fe9aGa8ic+uwHnq2IwkvqWVT/ZOdCOChrz2dmq5tXAa+B19sF2PAPjMAsEu5r3pn6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648094; c=relaxed/simple;
	bh=A0MhLpSiMF4ZePZea+uSqFHeDaf11vXo7n45NZDp2Gk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OPiwxf3TVUr25QN3sdmUUQQfcrYo3afaX4djneFWtwBcplE9xU72huisUEAhvu5CRp1dbamZgNe4S6fzoD03qxLIloJjvE135pQfOTyODYAHZGBbt/3SNntGVvhFFbNwt+nvdJZrYtWoQBzQIXfiOPAKfw5dvKC5WtpWpGtEgNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d/dOYj+l; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d/dOYj+l"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734648089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0shyY7uBauV1x/cJdXNQ64sx5nTB7qDurpNjEd/bPw8=;
	b=d/dOYj+lat4ghlulcaX3MZRR0Z6RXKHZ6ZlriQn70RhKVVxlZnib8VvCllvCdM/uMGKsAq
	MZnbyDE+C2YDMhONtiBiNNvWD5Y7X5jO8Cg1VXXTUptVk23rgCQe+UXAWu6BnI4jZ/kAsF
	8bZKzN6GatPkVKyGsFJ1P8l0CLCbQ0A=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 00/19] KVM: arm64: Debug cleanups
Date: Thu, 19 Dec 2024 14:40:57 -0800
Message-Id: <20241219224116.3941496-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hopefully the last spin! Addressed some review comments, and snuck in
one more cleanup to the sysreg handlers since that was quite a mess too.

v3 -> v4:
 - Collect Tested-by tags from James (thanks!)
 - Delete stray if condition, second attempt (Marc)
 - Hoist writes to MDCR_EL2 into kvm_arm_setup_mdcr_el2()
 - Get rid of the sysreg accessor mess for DBGxVR/DBGxCR

v3: https://lore.kernel.org/kvmarm/20241209180926.2161373-1-oliver.upton@linux.dev/

Oliver Upton (19):
  KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
  KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
  KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of
    vCPU
  KVM: arm64: Move host SME/SVE tracking flags to host data
  KVM: arm64: Write MDCR_EL2 directly from kvm_arm_setup_mdcr_el2()
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
  KVM: arm64: Fold DBGxVR/DBGxCR accessors into common set
  KVM: arm64: Promote guest ownership for DBGxVR/DBGxCR reads

 arch/arm64/include/asm/kvm_asm.h           |   5 +-
 arch/arm64/include/asm/kvm_host.h          |  94 ++---
 arch/arm64/include/asm/kvm_nested.h        |   1 +
 arch/arm64/kvm/arm.c                       |  14 +-
 arch/arm64/kvm/debug.c                     | 380 +++++++--------------
 arch/arm64/kvm/emulate-nested.c            |  23 +-
 arch/arm64/kvm/fpsimd.c                    |  12 +-
 arch/arm64/kvm/guest.c                     |  31 +-
 arch/arm64/kvm/handle_exit.c               |   5 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  42 +--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  43 ++-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  13 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |   8 -
 arch/arm64/kvm/hyp/vhe/debug-sr.c          |   5 -
 arch/arm64/kvm/sys_regs.c                  | 249 ++++----------
 arch/arm64/kvm/trace_handle_exit.h         |  75 ----
 16 files changed, 350 insertions(+), 650 deletions(-)


base-commit: 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
-- 
2.39.5

