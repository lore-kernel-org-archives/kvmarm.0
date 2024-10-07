Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73901DDA13
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323180; cv=none; b=Ea17Cpu8U4QqT2X89JuOds1e/KZjMnPs7M5WrGKbG5XNeyts4eZ23DLa8Cp8vnkIHL8S/eIVGvyxVAEj9ucPj5WCZLFGpNGrJlPO+OW8PKZWIjQihlLVnHnTmk4UO+tfJU4uQUqD9l41Omtf+YfZCWLcZ3yON77iHnsGA1A4oSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323180; c=relaxed/simple;
	bh=pFXeYggkDBlBSLnz9wUhGI49ctsGlngvnFEjNl0jBhs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P2yb0qnwQlaJ5JaeyKnYbfxg/XFGXyzDKKdGA6+Ir6C+XOunbJNQwJCcOvxhtEcv+eQpxGrF8K5pIcn5kGTwptLK8JdZ9xvurf/qpAp3cL2zcRDJv7IUMNpDu7NOB7LqXA3SIoYqccHiewGVA7Qz1nHN12knVxnNaFe0QeIRRH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XiRewDn2; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XiRewDn2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6ySTat4x6G2dBztLV33BBeNjuMromC6R1C/FdMoSysM=;
	b=XiRewDn2bXm17SSyeZmYuvAzK4Q6Jp6p9slH/4zU408m/solf2YALiv5uOp3kwM39Q0xug
	Tsawb7FDHsRUwzj7zN8qRfErOfgDqMyDqIpOoZyWH00f54mVuLQ+c1vTHiq8SzlFLIgIw7
	Ot0zTNTGdIX8sYZ1PsKF1a/Jlgi5wqE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 00/17] KVM: arm64: nv: Support for EL2 PMU controls
Date: Mon,  7 Oct 2024 17:45:42 +0000
Message-ID: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Marc, I stole patch 1 from you for the sake of sending out a consistent
series. I can sort things out when I apply patches if that patch is a
common base for the both of us.

v2 -> v3:
 - Use the sysreg sanitisation infrastructure to apply RES0/RES1 masks
   to MDCR_EL2
 - Drop trap_config bit describing if a trap applies to Host EL0
 - Honor MDCR_EL2.{HPME,HLP} for the 'hypervisor range' of PMU counters

v2: https://lore.kernel.org/kvmarm/20240827002235.1753237-1-oliver.upton@linux.dev/#r

Marc Zyngier (1):
  KVM: arm64: Extend masking facility to arbitrary registers

Oliver Upton (16):
  arm64: sysreg: Migrate MDCR_EL2 definition to table
  arm64: sysreg: Add missing definitions for ID_AA64DFR0_EL1
  KVM: arm64: Describe RES0/RES1 bits of MDCR_EL2
  KVM: arm64: nv: Allow coarse-grained trap combos to use complex traps
  KVM: arm64: nv: Rename BEHAVE_FORWARD_ANY
  KVM: arm64: nv: Reinject traps that take effect in Host EL0
  KVM: arm64: nv: Honor MDCR_EL2.{TPM, TPMCR} in Host EL0
  KVM: arm64: nv: Describe trap behaviour of MDCR_EL2.HPMN
  KVM: arm64: nv: Advertise support for FEAT_HPMN0
  KVM: arm64: Rename kvm_pmu_valid_counter_mask()
  KVM: arm64: nv: Adjust range of accessible PMCs according to HPMN
  KVM: arm64: Add helpers to determine if PMC counts at a given EL
  KVM: arm64: nv: Honor MDCR_EL2.HPME
  KVM: arm64: nv: Honor MDCR_EL2.HLP
  KVM: arm64: nv: Apply EL2 event filtering when in hyp context
  KVM: arm64: nv: Reprogram PMU events affected by nested transition

 arch/arm64/include/asm/kvm_arm.h     |  29 ---
 arch/arm64/include/asm/kvm_emulate.h |   5 +
 arch/arm64/include/asm/kvm_host.h    |  21 +-
 arch/arm64/kvm/emulate-nested.c      | 298 ++++++++++++++++-----------
 arch/arm64/kvm/nested.c              |  52 ++++-
 arch/arm64/kvm/pmu-emul.c            | 136 ++++++++++--
 arch/arm64/kvm/sys_regs.c            |  15 +-
 arch/arm64/tools/sysreg              |  45 +++-
 include/kvm/arm_pmu.h                |  18 +-
 9 files changed, 432 insertions(+), 187 deletions(-)


base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
-- 
2.47.0.rc0.187.ge670bccf7e-goog

