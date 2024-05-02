Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320AE1CD1B
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 23:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692943; cv=none; b=EliuXCkRZRIfwEtVJqndhO4Lvqln58s10CYW3EM1ZpD2TNK98IdZXAptCfVCm70bG78lKnxJ/OvuvPE+DQxQ94ZFElLpWaXylz4S2YlGePdYPyP2BM7zWbDfIU9RtUEVrNkovWPC8YUF3OV/o7kCQKybpxhV9fpF6ND1spDyc+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692943; c=relaxed/simple;
	bh=o9B/CaH+IezzgMqGhwEE5TyiFXtwI2ooaRwrXgUZBcc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FlnHJdqnUc0RG53Dw/psCkPf8ZJx2tjw2ajuxPDiCfIre5uy2MzbhKzi884dvTYxmzRmCt5mHWzuWpVmCLNrLLmcp5Tqo3Ug+OucK2vvc34cdptRIgPY9b4uK7f50mYXx5+62zCq1AKqXGugcM0pJIgPIJK7y4HI0577SFgiKNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PZrePpas; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PZrePpas"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714692939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0oB1momliCVbkOQmb/RuD42gl5HLFZDtSllD6GuMjRw=;
	b=PZrePpasNBvyWmfkKfzydDeTyB4iG7+cX7KJmeJlLKH61oggtHiiRaW3jDD6gYHPcAv3Fc
	oFdT7jH1r+jmSIBoXKdrWaVxhWmUONpgcz9CfVOoIikI17OdK6ahgt0Lof5sdCpQgxauL1
	epX9wyeBUMN9sTq6aDbzFHgxZYJ1y4A=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/7] KVM: arm64: Don't clobber CLIDR and MPIDR across vCPU reset
Date: Thu,  2 May 2024 23:35:22 +0000
Message-ID: <20240502233529.1958459-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When I was reviewing Sebastian's CTR_EL0 series it occurred to me that
our handling of feature ID registers local to a vCPU is quite poor.

For VM-wide feature ID registers we ensure they get initialized once for
the lifetime of a VM. On the other hand, vCPU-local feature ID registers
get re-initialized on every vCPU reset, potentially clobbering the
values userspace set up.

MPIDR_EL1 and CLIDR_EL1 are the only registers in this space that we
allow userspace to modify for now. Clobbering the value of MPIDR_EL1 has
some disastrous side effects as the compressed index used by the
MPIDR-to-vCPU lookup table assumes MPIDR_EL1 is immutable after KVM_RUN.

Series + reproducer test case to address the problem of KVM wiping out
userspace changes to these registers. Note that there are still some
differences between VM and vCPU scoped feature ID registers from the
perspective of userspace. We do not allow the value of VM-scope
registers to change after KVM_RUN, but vCPU registers remain mutable.

Fixing this is no problem, but given the recent theme of UAPI breakage
in this area I focused only on the internal issue fo now.

Applies to 6.9-rc3

Oliver Upton (7):
  KVM: arm64: Rename is_id_reg() to imply VM scope
  KVM: arm64: Reset VM feature ID regs from kvm_reset_sys_regs()
  KVM: arm64: Only reset vCPU-scoped feature ID regs once
  KVM: selftests: Rename helper in set_id_regs to imply VM scope
  KVM: selftests: Store expected register value in set_id_regs
  KVM: arm64: Test that feature ID regs survive a reset
  KVM: selftests: Test vCPU-scoped feature ID registers

 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/kvm/arm.c                          |   5 -
 arch/arm64/kvm/sys_regs.c                     |  62 +++++----
 .../selftests/kvm/aarch64/set_id_regs.c       | 123 +++++++++++++++---
 4 files changed, 142 insertions(+), 50 deletions(-)


base-commit: fec50db7033ea478773b159e0e2efb135270e3b7
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

