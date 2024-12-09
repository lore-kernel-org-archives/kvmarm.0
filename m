Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6D01F5F6
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767788; cv=none; b=WX0TTzMtbepYOuZFe/heV0zcRTs1fSILV9Y7rbap2Thn0q6TBFQGpwQmm1i3Fb5DxZwxzennFY8SRlIE7jMCz2fxMgUjL7dHgvmUR67Xi3FumCntFuP2MrVGmSs0twQX7r9hHccw4Ti5QtxcrjV8Xetv7Gr2Jprnz5NMjeqEVrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767788; c=relaxed/simple;
	bh=fpHp8iqCI1/ONxCLKm7ZVDm2BFNBB2pA9qUpJfrrUBU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IIHgMzSfASCchNssPjtwWoRX1IjuYhOlV+vgcsBsa+3fGtHGd9uINw7CyCUASmE5kNQ41pHqyEvL6ELSoWK0aU5Qish+AQ+f2LOkH3Jj5Xvq0EJ/3+zfx+2atrzS9ZwXa1GaS64a1/qOueixgXEm0CBsC6FOn3h9X8kaNUYxnXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YshvdKuu; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YshvdKuu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733767783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D9Aaw1vsm+K9jZL6YxY/GyXAi0ciu/xL209/asglqzQ=;
	b=YshvdKuunhnnwm6fpuYQZHXNRsBkMH48KzNARZRnqWHXaFnNOGNCmpxvqc2TM7AslcLNFb
	Xf/Ios0BzUS0b7cMuRwqXeSNvxRSkmXuyGaFWTthEAV+Tqjer/dtKv04fCHqGKDXfZ7qGQ
	WhVnIOGWUNO5ncJzDRLfqSkaH6vwsmk=
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
Subject: [PATCH v3 00/16] KVM: arm64: Debug cleanups
Date: Mon,  9 Dec 2024 10:09:10 -0800
Message-Id: <20241209180926.2161373-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On top of the cleanups, this series takes a considerable bite out of the
volume of sysreg traps when running windows, which likes to read
MDSCR_EL1 quite a lot.

v2: https://lore.kernel.org/kvmarm/20241115224924.2132364-13-oliver.upton@linux.dev/

v2 -> v3:
 - Respin to 6.13-rc2
 - Fix unsafe usage of percpu data in kvm_debug_set_guest_ownership()
   which led to a splat (James)

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
 arch/arm64/include/asm/kvm_host.h          |  94 ++---
 arch/arm64/include/asm/kvm_nested.h        |   1 +
 arch/arm64/kvm/arm.c                       |  14 +-
 arch/arm64/kvm/debug.c                     | 378 +++++++--------------
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
 16 files changed, 281 insertions(+), 523 deletions(-)


base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
-- 
2.39.5

