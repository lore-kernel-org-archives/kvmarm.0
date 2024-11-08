Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350031C4608
	for <kvmarm@lists.linux.dev>; Fri,  8 Nov 2024 22:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104685; cv=none; b=aGm2/4W++zOumBv70lBJMERr4W3QlzjoYEavtVe0nqluQbPowi7EfhyvmgsspC6JOR9pcrlEUcycDNUxtxY7snGq0nskdq0UBaCLLXrrUHi0wMXcTPYOz9qkPHED89xSUSnyF6FIAncZpae/RV8yMbKYBZC6rV9XFn6QX/wVIr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104685; c=relaxed/simple;
	bh=i9v+1n1VS9cy3UTuHMmpSuJPVhnrDUEn/X2bSdieUDk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HSWFunKchAwbEQG3VkbtZ8zBWKOQEeBN+uVQmQnjhoGxYE3ZFW3zKuz1rN3sIiRjFwHi4gLvK8PtBqOrkiJ2IdGDd2fgZCUsSpTBw+lRnRHzCcQ5z6NilSrBVpvGO/VGRoggV8/+VDLjjhypmXqh/7YKzTJNtf794U5//o5Jzo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O543Fnq/; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O543Fnq/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731104681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UwfqgwCo5n/a+SAWD9QMdDy7L22c9s9yvYfG4BC5hLY=;
	b=O543Fnq/cmamCzxR4Nl/oMPfxZQoo1VCKo1vqkAluK4tc9woFzsz0C05peRWWHS4PCNAhz
	DnSQUoPrblaN4htJoAvEwE1GNzW5P2IqP5cgA3IQgBYJ4AmJRWazMh9DTaMqBtLTbp48Pr
	yKQv/ONvSnStkim55gkqm+6jAQ1cL/E=
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
Subject: [PATCH 00/15] KVM: arm64: Debug cleanups
Date: Fri,  8 Nov 2024 14:24:04 -0800
Message-Id: <20241108222418.1677420-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The debug code has become a bit difficult to reason about, especially
all the hacks and bandaids for state tracking + trap configuration.

This series reworks the entire mess around using a single enumeration to
track the state of the debug registers (free, guest-owned, host-owned),
using that to drive trap configuration and save/restore.

On top of that, this series wires most of the implementation into vCPU
load/put rather than the main KVM_RUN loop. This has been a long time
coming for VHE, as a lot of the trap configuration and EL1 state gets
loaded into hardware at that point anyway.

The save/restore of the debug registers is simplified quite a bit as
well. KVM will now restore the registers for *any* access rather than
just writes, and keep doing so until the next vcpu_put() instead of
dropping it on the floor after the next exception.

Oliver Upton (15):
  KVM: arm64: Drop MDSCR_EL1_DEBUG_MASK
  KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts
  KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of
    vCPU
  KVM: arm64: Move host SME/SVE tracking flags to host data
  KVM: arm64: Evaluate debug owner at vcpu_load()
  KVM: arm64: Advance debug_owner state machine for sysreg traps
  KVM: arm64: Clean up KVM_SET_GUEST_DEBUG handler
  KVM: arm64: Select debug state to save/restore based on debug owner
  KVM: arm64: Remove debug tracepoints
  KVM: arm64: Remove vestiges of debug_ptr
  KVM: arm64: Use debug_owner to track if debug regs need save/restore
  KVM: arm64: Reload vCPU for accesses to OSLAR_EL1
  KVM: arm64: Compute MDCR_EL2 at vcpu_load()
  KVM: arm64: Don't hijack guest context MDSCR_EL1
  KVM: arm64: Manage software step state at load/put

 arch/arm64/include/asm/kvm_asm.h           |   5 +-
 arch/arm64/include/asm/kvm_host.h          | 109 ++++---
 arch/arm64/kvm/arm.c                       |  14 +-
 arch/arm64/kvm/debug.c                     | 327 +++++----------------
 arch/arm64/kvm/fpsimd.c                    |  12 +-
 arch/arm64/kvm/guest.c                     |  29 +-
 arch/arm64/kvm/handle_exit.c               |   2 +-
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  10 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  42 ++-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  13 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |   8 -
 arch/arm64/kvm/hyp/vhe/debug-sr.c          |   5 -
 arch/arm64/kvm/sys_regs.c                  |  44 +--
 13 files changed, 204 insertions(+), 416 deletions(-)


base-commit: 25a8556b540075121c6af2c179fe0c036e8851a2
-- 
2.39.5

