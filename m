Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60759339AB
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750649; cv=none; b=uoRFLlv0ub7v3iWHz3AhZvgxJpPM2/XObLlcEA49RMFpoBXp2Tu8TKeoUiVWZgoyjRUi9Vin/K6Fr1ep132KkTTEz4pn6NScg5ho8aII996XZNB3c6hrMfyLxxUKgjVLU0nTEl/1R1UGxD4eJZ8MH0Yj3AV7ejGfMi8c0jgEOzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750649; c=relaxed/simple;
	bh=gDjB7vrTdqQ1zI5gBVq2+5ri+VIMj0Eqmi20M9CM/sk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ebkvHjwfPVIojGh9TIXJFt+g7+EsBwej8B5o0T7qjdcp8wnQiuFf+x25q46E4S/cuzWzWrpfu0e5lhDsKsYN7ADBHeAYcysuktkmAWuXyKm2FnV76ZP3uNgsI1XE6OMobHRzAjqmFiFg1A9jZtqe3IUATTzBJnejmdDZKam1f3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC869367;
	Mon, 30 Sep 2024 19:44:34 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F284D3F58B;
	Mon, 30 Sep 2024 19:44:01 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 00/47] KVM: arm64: Enable FGU (Fine Grained Undefined) for FEAT_FGT2 registers
Date: Tue,  1 Oct 2024 08:13:09 +0530
Message-Id: <20241001024356.1096072-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series enables fine grained undefined for FEAT_FGT2 managed registers
via adding their respective FGT and CGT trap configuration. But first this
adds many system register definitions in tools/sysreg, which are required
there after.

patches 1-44: define system registers in tools/sysreg format
patch     45: enables FEAT_FGT2 registers access from virtual EL2
patch     46: enables FGT for FEAT_FGT2
patch     47: enables CGT for FEAT_FGT2

Some notes:

As kvm_has_feat() does not support non-ID registers following replacements
have been made for validating presence of correspnding features

- ID_AA64DFR0_EL1.ExtTrcBuff is tested for HDFGRTR2_EL2.nPMSDSFR_EL1
- ID_AA64DFR0_EL1.PMSVer is tested for HDFGRTR2_EL2.nPMSDSFR_EL1

Following FGT enabled registers don't have corresponding CGT requirements

- TRCITECR_EL1
- PMSSCR_EL1
- PMCCNTSVR_EL1
- PMICNTSVR_EL1
- RCWSMASK_EL1
- ERXGSR_EL1
- PFAR_EL1

Changes in V2:

- Added all system register definitions required for FEAT_FGT2 traps
- Added all system register access traps managed with new FEAT_FGT2
  i.e HDFGRTR2_EL2, HDFGWTR2_EL2, HFGRTR2_GROUP, HFGWTR2_GROUP and
  HFGITR2_GROUP for their VNCR access, FGT and CGT
- Added all FGT for all register accesses managed with FEAT_FGT2
- Added all CGT for all register accesses managed with FEAT_FGT2

Changes in RFC V1:

https://lore.kernel.org/linux-arm-kernel/20240620065807.151540-1-anshuman.khandual@arm.com/

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org

Anshuman Khandual (47):
  arm64/sysreg: Update register fields for ID_AA64MMFR0_EL1
  arm64/sysreg: Update register fields for ID_AA64DFR0_EL1
  arm64/sysreg: Update register fields for ID_AA64PFR0_EL1
  arm64/sysreg: Add register fields for ID_AA64DFR2_EL1
  arm64/sysreg: Add register fields for HDFGRTR2_EL2
  arm64/sysreg: Add register fields for HDFGWTR2_EL2
  arm64/sysreg: Add register fields for HFGITR2_EL2
  arm64/sysreg: Add register fields for HFGRTR2_EL2
  arm64/sysreg: Add register fields for HFGWTR2_EL2
  arm64/sysreg: Add register fields for MDSELR_EL1
  arm64/sysreg: Add register fields for PMSIDR_EL1
  arm64/sysreg: Add register fields for TRBIDR_EL1
  arm64/sysreg: Add register fields for TRBMPAM_EL1
  arm64/sysreg: Add register fields for PMSDSFR_EL1
  arm64/sysreg: Add register fields for SPMDEVAFF_EL1
  arm64/sysreg: Add register fields for PFAR_EL1
  arm64/sysreg: Add register fields for PMIAR_EL1
  arm64/sysreg: Add register fields for PMECR_EL1
  arm64/sysreg: Add register fields for PMUACR_EL1
  arm64/sysreg: Add register fields for PMCCNTSVR_EL1
  arm64/sysreg: Add register fields for SPMSCR_EL1
  arm64/sysreg: Add register fields for SPMACCESSR_EL1
  arm64/sysreg: Add register fields for PMICNTR_EL0
  arm64/sysreg: Add register fields for PMICFILTR_EL0
  arm64/sysreg: Add register fields for SPMCR_EL0
  arm64/sysreg: Add register fields for SPMOVSCLR_EL0
  arm64/sysreg: Add register fields for SPMOVSSET_EL0
  arm64/sysreg: Add register fields for SPMINTENCLR_EL1
  arm64/sysreg: Add register fields for SPMINTENSET_EL1
  arm64/sysreg: Add register fields for SPMCNTENCLR_EL0
  arm64/sysreg: Add register fields for SPMCNTENSET_EL0
  arm64/sysreg: Add register fields for SPMSELR_EL0
  arm64/sysreg: Add register fields for PMICNTSVR_EL1
  arm64/sysreg: Add register fields for SPMIIDR_EL1
  arm64/sysreg: Add register fields for SPMDEVARCH_EL1
  arm64/sysreg: Add register fields for SPMCFGR_EL1
  arm64/sysreg: Add register fields for PMSSCR_EL1
  arm64/sysreg: Add register fields for PMZR_EL0
  arm64/sysreg: Add register fields for SPMCGCR0_EL1
  arm64/sysreg: Add register fields for SPMCGCR1_EL1
  arm64/sysreg: Add register fields for MDSTEPOP_EL1
  arm64/sysreg: Add register fields for ERXGSR_EL1
  arm64/sysreg: Add register fields for SPMACCESSR_EL2
  arm64/sysreg: Add remaining debug registers affected by HDFGxTR2_EL2
  KVM: arm64: nv: Add FEAT_FGT2 registers access from virtual EL2
  KVM: arm64: nv: Add FEAT_FGT2 registers based FGU handling
  KVM: arm64: nv: Add trap forwarding for FEAT_FGT2 described registers

 arch/arm64/include/asm/kvm_arm.h        |  22 +
 arch/arm64/include/asm/kvm_host.h       |  12 +
 arch/arm64/include/asm/sysreg.h         |   6 +
 arch/arm64/include/asm/vncr_mapping.h   |   5 +
 arch/arm64/kvm/emulate-nested.c         | 444 +++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  26 +
 arch/arm64/kvm/nested.c                 |  52 ++
 arch/arm64/kvm/sys_regs.c               |  64 ++
 arch/arm64/tools/sysreg                 | 938 +++++++++++++++++++++++-
 9 files changed, 1564 insertions(+), 5 deletions(-)

-- 
2.25.1

