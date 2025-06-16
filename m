Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E9B212B2B
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115004; cv=none; b=fusZc3PQb4cJ7n3h/rw8PoQ/ayRDC4VLuvdNCuUhMvvuRE83sJI1esN0O3c+9z/83L+UWRXg3ZD4km2zGEIK7jOydEpOjUxUkTl7F40oDqYjFSJnaDMMCE3vVetD8WL4n1qI0Gz6m8tiSRFk59glZMBuB0pORlr9WVTiLVrNF1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115004; c=relaxed/simple;
	bh=Fh5NF7uHwuk2lK9bE5Et9fCch5Uk0H62c+UiYAK3ZJA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V1fTUXiTYt1FWk/SDZon+lT/cuQhZfk1KXMFX0xCHaK9GquOPRAz/yOj8zjBtZH1/bq/ovs71Fdp12aVRqJg6oLfqC0Czbxg2EazqnMKdv9EXmvAk7lz1VlIeFYh6EReFDp6ZBqxNfUirHs/HCdVekD6P5fkOYGn3s5IOBS4Xf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cHgOo1XW; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cHgOo1XW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750114999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eOznNCXBzz7XoBUE1zXg+wTYe+2JEDn0vgwwc9afuNQ=;
	b=cHgOo1XWqDAvw/Y8SvHDttw+s108n0T5fCaU3XM032A8TxBSrY9Ln66tiLekh/ZPAGSNmH
	ype0djE8OtCsho1C5J3/G+Ejn5lyCzunZ7+zr5TIUFTE5Rr1CbPe6eknFQtZ+kMspiE7Lk
	jy7tPioW/Gndeh/zb8ZCgEbWOjKLsF8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 00/27] KVM: arm64: SCTLR2, DoubleFault2, and NV external abort fixes
Date: Mon, 16 Jun 2025 16:02:41 -0700
Message-Id: <20250616230308.1192565-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Well... this series grew a bit. Thanks to some leading review feedback
in v1, I went about implementing FEAT_RAS, FEAT_SCLTR2, and
FEAT_DoubleFault2 for NV (and non-NV, where applicable).

The most annoying addition of the whole bunch is certainly TMEA, which
has the effect of enabling vSErrors and potentially making 'physical'
SErrors deliverable to the same context.

v1: https://lore.kernel.org/kvmarm/20250530230623.650888-1-oliver.upton@linux.dev/

v1 -> v2:
 - Only use kvm_inject_nested_*() for literal nested exceptions (i.e.
   EL1&0 => EL2&0 regime) (Marc)
 - Take Marc's is_nested_ctxt() helper (thanks!)
 - Delegate vSError context to guest hypervisor when appropriate, in
   turn implementing FEAT_RAS
 - Handle state for FEAT_SCTLR2
 - Route "masked" aborts to EL2 when HCR_EL2.TMEA is set
 - Always perform emulated SError injection when SErrors are unmasked
 - Tests

Marc Zyngier (1):
  KVM: arm64: Add helper to identify a nested context

Oliver Upton (26):
  arm64: Detect FEAT_SCTLR2
  arm64: Detect FEAT_DoubleFault2
  KVM: arm64: Treat vCPU with pending SError as runnable
  KVM: arm64: nv: Respect exception routing rules for SEAs
  KVM: arm64: nv: Honor SError exception routing / masking
  KVM: arm64: nv: Add FEAT_RAS vSError sys regs to table
  KVM: arm64: nv: Use guest hypervisor's vSError state
  KVM: arm64: nv: Advertise support for FEAT_RAS
  KVM: arm64: nv: Describe trap behavior of SCTLR2_EL1
  KVM: arm64: Wire up SCTLR2_ELx sysreg descriptors
  KVM: arm64: Context switch SCTLR2_ELx when advertised to the guest
  KVM: arm64: Enable SCTLR2 when advertised to the guest
  KVM: arm64: Describe SCTLR2_ELx RESx masks
  KVM: arm64: Factor out helper for selecting exception target EL
  KVM: arm64: nv: Ensure Address size faults affect correct ESR
  KVM: arm64: Route SEAs to the SError vector when EASE is set
  KVM: arm64: nv: Handle effects of HCRX_EL2.TMEA on SError injection
  KVM: arm64: Take "masked" SEAs to EL2 when TMEA is set
  KVM: arm64: nv: Enable vSErrors when HCRX_EL2.TMEA is set
  KVM: arm64: Advertise support for FEAT_SCTLR2
  KVM: arm64: Advertise support for FEAT_DoubleFault2
  KVM: arm64: Don't retire MMIO instruction w/ pending (emulated) SError
  KVM: arm64: selftests: Add basic SError injection test
  KVM: arm64: selftests: Test SEAs are taken to SError vector when
    EASE=1
  KVM: arm64: selftests: Add SCTLR2_EL1 to get-reg-list
  KVM: arm64: selftests: Catch up set_id_regs with the kernel

 arch/arm64/include/asm/kvm_emulate.h          |  51 +++-
 arch/arm64/include/asm/kvm_host.h             |  31 ++-
 arch/arm64/include/asm/kvm_nested.h           |   2 +
 arch/arm64/include/asm/vncr_mapping.h         |   2 +
 arch/arm64/kernel/cpufeature.c                |   9 +
 arch/arm64/kvm/arch_timer.c                   |   2 +-
 arch/arm64/kvm/arm.c                          |   9 +-
 arch/arm64/kvm/config.c                       |  28 +++
 arch/arm64/kvm/emulate-nested.c               |  41 +++-
 arch/arm64/kvm/guest.c                        |  36 +--
 arch/arm64/kvm/handle_exit.c                  |  24 +-
 arch/arm64/kvm/hyp/exception.c                |  10 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  46 +++-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |  31 ++-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |   2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |   6 +
 arch/arm64/kvm/inject_fault.c                 | 222 ++++++++++++------
 arch/arm64/kvm/mmio.c                         |  12 +-
 arch/arm64/kvm/mmu.c                          |  17 +-
 arch/arm64/kvm/nested.c                       |  45 +++-
 arch/arm64/kvm/sys_regs.c                     |  31 ++-
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |   2 +-
 arch/arm64/tools/cpucaps                      |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 .../arm64/{mmio_abort.c => external_aborts.c} | 159 ++++++++++++-
 .../selftests/kvm/arm64/get-reg-list.c        |   7 +
 .../testing/selftests/kvm/arm64/set_id_regs.c |  14 +-
 .../selftests/kvm/include/arm64/processor.h   |  10 +
 28 files changed, 683 insertions(+), 169 deletions(-)
 rename tools/testing/selftests/kvm/arm64/{mmio_abort.c => external_aborts.c} (50%)


base-commit: e04c78d86a9699d136910cfc0bdcf01087e3267e
-- 
2.39.5

