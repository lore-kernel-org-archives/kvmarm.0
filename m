Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B861F91C8
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995549; cv=none; b=QHfKybLofwvTiDoBT2aXe2tNGciZ1uSisuXpwzho6/p/Rk1FDPnLuu+nqOlPQ+0Zj9lqBB1khkVJ7E/ua9h9psCHoKNnf44n0lz3jWQGPGeONetk86VKsW7HrJfDqziafh052d6TutxhYHmE2d3rTOghfOAVPkGdQ/paLLzhqds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995549; c=relaxed/simple;
	bh=9tZ8J+05xrb9kwn74xN4M5hC6tpi7cS+cS1Sp36Zado=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hCUL0pnyl5ogXcLa1xmGTshqDrmksPxBETtufpeAOk5YZ2Ej09YeMwoNXEIULrNkHuVltVJv7iyCQwDzk+fzt3iLSwQFZAvUHgqnpjOTPcawLCFARjiJuiBhOfrn+cSwqVYKPYUGT+hskzsDuJQFwk6GAnXAVp7n4roLt7ZLC/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fTf0RHLy; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fTf0RHLy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oide9nfYxcIZY4KKksiPvCMi2cQY1AbSzfhrPyuWNSQ=;
	b=fTf0RHLyjfTxSPzIoz8/kGkjY10/IcWXyDnq7aGBn++Zb285VmgPJfuHsECvtlFbpA8oF6
	1i44nSyhbKOojZsMZINTw+OoyEoLan+Xm/i82FDWXXglHp3uTHqLaUdKBBDg2KxURTEa4T
	NqwY0e5kqMLKnyDCGzkzZOq5dAI29cY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 00/27] KVM: arm64: SCTLR2, DoubleFault2, and NV external abort fixes
Date: Tue,  8 Jul 2025 10:25:05 -0700
Message-Id: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v2: https://lore.kernel.org/kvmarm/20250616230308.1192565-1-oliver.upton@linux.dev/

v2 -> v3:
 - Fix mask computation when SCLTR2_ELx.NMEA is set
 - Consolidate TMEA handling for all aborts, spin off NMEA (Marc)
 - Set up the fault context correctly for the injected abort (e.g.
   not setting HPFAR_EL2 when UNKNOWN) (Marc)
 - Don't use the guest hypervisor's VSESR when FEAT_RAS isn't
   implemented for the guest (Marc)

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
  KVM: arm64: nv: Take "masked" aborts to EL2 when HCRX_EL2.TMEA is set
  KVM: arm64: nv: Honor SError routing effects of SCTLR2_ELx.NMEA
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
 arch/arm64/include/asm/kvm_host.h             |  32 ++-
 arch/arm64/include/asm/kvm_nested.h           |   2 +
 arch/arm64/include/asm/vncr_mapping.h         |   2 +
 arch/arm64/kernel/cpufeature.c                |   9 +
 arch/arm64/kvm/arch_timer.c                   |   2 +-
 arch/arm64/kvm/arm.c                          |   9 +-
 arch/arm64/kvm/config.c                       |  28 +++
 arch/arm64/kvm/emulate-nested.c               |  49 +++-
 arch/arm64/kvm/guest.c                        |  33 +--
 arch/arm64/kvm/handle_exit.c                  |  24 +-
 arch/arm64/kvm/hyp/exception.c                |  10 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  53 +++-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |  48 +++-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |   2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |   6 +
 arch/arm64/kvm/inject_fault.c                 | 231 ++++++++++++------
 arch/arm64/kvm/mmio.c                         |  12 +-
 arch/arm64/kvm/mmu.c                          |  17 +-
 arch/arm64/kvm/nested.c                       |  49 +++-
 arch/arm64/kvm/sys_regs.c                     |  31 ++-
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |   2 +-
 arch/arm64/tools/cpucaps                      |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +-
 .../arm64/{mmio_abort.c => external_aborts.c} | 159 +++++++++++-
 .../selftests/kvm/arm64/get-reg-list.c        |   7 +
 .../testing/selftests/kvm/arm64/set_id_regs.c |  14 +-
 .../selftests/kvm/include/arm64/processor.h   |  10 +
 28 files changed, 725 insertions(+), 170 deletions(-)
 rename tools/testing/selftests/kvm/arm64/{mmio_abort.c => external_aborts.c} (50%)


base-commit: 86731a2a651e58953fc949573895f2fa6d456841
-- 
2.39.5

