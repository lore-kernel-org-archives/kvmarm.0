Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A5D185B59
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 02:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727750830; cv=none; b=QGVGZkoWlipQwNefqlIyc+kb6wjOZjtHf9RFh7jBqAYhruQBUI6TTFxPEMyAbCqLmw5Jok2oDeIIHcXr6AiBtLAcpTMHv+jzXs5YB4aPBA459nuEoqorGmQ6FT0JgaYZ7h9i781C4t6wiiMRfg3TzqiNrgOZvQ9aOdxOBZqGHtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727750830; c=relaxed/simple;
	bh=g3j3WTKwVCnnqw3h8ITVNMxeztiGk8ktt+9rZ7at0z4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tI+Iwr4PdY3eempXHfvsOVVOkSWLO62W2hOoGgpb69i8Wvqtx8HeiTYVutHAbWvJSlCav0qxXIF98G7jFqlsTw1lIt/8x8dcJlyws9DOipYqVy0m931Br2MZJKW2A6BGzDEAOWIUNm0bzq82nDs1Ph6UKTn6oW+/zxfqDMoF/eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=fail smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8A8FDA7;
	Mon, 30 Sep 2024 19:47:37 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 915C03F58B;
	Mon, 30 Sep 2024 19:47:04 -0700 (PDT)
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
Subject: [PATCH 46/47] KVM: arm64: nv: Add FEAT_FGT2 registers based FGU handling
Date: Tue,  1 Oct 2024 08:13:55 +0530
Message-Id: <20241001024356.1096072-47-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241001024356.1096072-1-anshuman.khandual@arm.com>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This enables FEAT_FGT2 registers based FGU handling by adding the following
new groups in 'enum fgt_group_id' for all respective FGT control registers
and also adding FGU behaviour for their individual managed registers access
traps.

1. HDFGRTR2_GROUP
2. HDFGWTR2_GROUP
3. HFGRTR2_GROUP
4. HFGWTR2_GROUP
5. HFGITR2_GROUP

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h        |  20 +++
 arch/arm64/include/asm/kvm_host.h       |   5 +
 arch/arm64/kvm/emulate-nested.c         | 182 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  26 ++++
 arch/arm64/kvm/nested.c                 |  52 +++++++
 arch/arm64/kvm/sys_regs.c               |  59 ++++++++
 6 files changed, 344 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 109a85ee6910..449bccffd529 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -354,6 +354,26 @@
 #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
 #define __HFGRTR_EL2_nMASK	~(__HFGRTR_EL2_RES0 | __HFGRTR_EL2_MASK)
 
+#define __HDFGRTR2_EL2_RES0	HDFGRTR2_EL2_RES0
+#define __HDFGRTR2_EL2_MASK	0
+#define __HDFGRTR2_EL2_nMASK	~(__HDFGRTR2_EL2_RES0 | __HDFGRTR2_EL2_MASK)
+
+#define __HDFGWTR2_EL2_RES0	HDFGWTR2_EL2_RES0
+#define __HDFGWTR2_EL2_MASK	0
+#define __HDFGWTR2_EL2_nMASK	~(__HDFGWTR2_EL2_RES0 | __HDFGWTR2_EL2_MASK)
+
+#define __HFGITR2_EL2_RES0	HFGITR2_EL2_RES0
+#define __HFGITR2_EL2_MASK	0
+#define __HFGITR2_EL2_nMASK	~(__HFGITR2_EL2_RES0 | __HFGITR2_EL2_MASK)
+
+#define __HFGRTR2_EL2_RES0	HFGRTR2_EL2_RES0
+#define __HFGRTR2_EL2_MASK	0
+#define __HFGRTR2_EL2_nMASK	~(HFGRTR2_EL2_RES0 | __HFGRTR2_EL2_MASK)
+
+#define __HFGWTR2_EL2_RES0	HFGWTR2_EL2_RES0
+#define __HFGWTR2_EL2_MASK	0
+#define __HFGWTR2_EL2_nMASK	~(HFGWTR2_EL2_RES0 | __HFGWTR2_EL2_MASK)
+
 /*
  * The HFGWTR bits are a subset of HFGRTR bits. To ensure we don't miss any
  * future additions, define __HFGWTR* macros relative to __HFGRTR* ones.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 09291e1e42c9..ca98f6d810c2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -266,6 +266,11 @@ enum fgt_group_id {
 	HDFGWTR_GROUP = HDFGRTR_GROUP,
 	HFGITR_GROUP,
 	HAFGRTR_GROUP,
+	HDFGRTR2_GROUP,
+	HDFGWTR2_GROUP = HDFGRTR2_GROUP,
+	HFGRTR2_GROUP,
+	HFGWTR2_GROUP = HFGRTR2_GROUP,
+	HFGITR2_GROUP,
 
 	/* Must be last */
 	__NR_FGT_GROUP_IDS__
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05b6435d02a9..f22a5f10ffe5 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1899,6 +1899,158 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
+
+	/* HDFGRTR2_EL2 */
+	SR_FGT(SYS_MDSTEPOP_EL1,	HDFGRTR2, nMDSTEPOP_EL1, 0),
+	SR_FGT(SYS_TRBMPAM_EL1,		HDFGRTR2, nTRBMPAM_EL1, 0),
+	SR_FGT(SYS_TRCITECR_EL1,	HDFGRTR2, nTRCITECR_EL1, 0),
+	SR_FGT(SYS_PMSDSFR_EL1,		HDFGRTR2, nPMSDSFR_EL1, 0),
+	SR_FGT(SYS_SPMDEVAFF_EL1,	HDFGRTR2, nSPMDEVAFF_EL1, 0),
+
+	SR_FGT(SYS_SPMCGCR0_EL1,	HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMCGCR1_EL1,	HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMIIDR_EL1,		HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMDEVARCH_EL1,	HDFGRTR2, nSPMID, 0),
+	SR_FGT(SYS_SPMCFGR_EL1,		HDFGRTR2, nSPMID, 0),
+
+	SR_FGT(SYS_SPMSCR_EL1,		HDFGRTR2, nSPMSCR_EL1, 0),
+	SR_FGT(SYS_SPMACCESSR_EL1,	HDFGRTR2, nSPMACCESSR_EL1, 0),
+	SR_FGT(SYS_SPMCR_EL0,		HDFGRTR2, nSPMCR_EL0, 0),
+	SR_FGT(SYS_SPMOVSCLR_EL0,	HDFGRTR2, nSPMOVS, 0),
+	SR_FGT(SYS_SPMOVSSET_EL0,	HDFGRTR2, nSPMOVS, 0),
+	SR_FGT(SYS_SPMINTENCLR_EL1,	HDFGRTR2, nSPMINTEN, 0),
+	SR_FGT(SYS_SPMINTENSET_EL1,	HDFGRTR2, nSPMINTEN, 0),
+	SR_FGT(SYS_SPMCNTENCLR_EL0,	HDFGRTR2, nSPMCNTEN, 0),
+	SR_FGT(SYS_SPMCNTENSET_EL0,	HDFGRTR2, nSPMCNTEN, 0),
+	SR_FGT(SYS_SPMSELR_EL0,		HDFGRTR2, nSPMSELR_EL0, 0),
+
+	SR_FGT(SYS_SPMEVTYPER_EL0(0),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(1),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(2),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(3),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(4),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(5),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(6),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(7),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(8),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(9),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(10),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(11),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(12),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(13),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(14),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVTYPER_EL0(15),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+
+	SR_FGT(SYS_SPMEVFILTR_EL0(0),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(1),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(2),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(3),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(4),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(5),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(6),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(7),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(8),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(9),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(10),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(11),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(12),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(13),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(14),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILTR_EL0(15),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+
+	SR_FGT(SYS_SPMEVFILT2R_EL0(0),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(1),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(2),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(3),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(4),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(5),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(6),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(7),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(8),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(9),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(10),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(11),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(12),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(13),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(14),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+	SR_FGT(SYS_SPMEVFILT2R_EL0(15),	HDFGRTR2, nSPMEVTYPERn_EL0, 0),
+
+	SR_FGT(SYS_SPMEVCNTR_EL0(0),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(1),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(2),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(3),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(4),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(5),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(6),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(7),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(8),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(9),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(10),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(11),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(12),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(13),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(14),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+	SR_FGT(SYS_SPMEVCNTR_EL0(15),	HDFGRTR2, nSPMEVCNTRn_EL0, 0),
+
+	SR_FGT(SYS_PMSSCR_EL1,		HDFGRTR2, nPMSSCR_EL1, 0),
+	SR_FGT(SYS_PMCCNTSVR_EL1,	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMICNTSVR_EL1,	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(0),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(1),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(2),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(3),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(4),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(5),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(6),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(7),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(8),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(9),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(10),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(11),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(12),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(13),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(14),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(15),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(16),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(17),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(18),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(19),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(20),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(21),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(22),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(23),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(24),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(25),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(26),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(27),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(28),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(29),	HDFGRTR2, nPMSSDATA, 0),
+	SR_FGT(SYS_PMEVCNTSVR_EL1(30),	HDFGRTR2, nPMSSDATA, 0),
+
+	SR_FGT(SYS_MDSELR_EL1,		HDFGRTR2, nMDSELR_EL1, 0),
+	SR_FGT(SYS_PMUACR_EL1,		HDFGRTR2, nPMUACR_EL1, 0),
+	SR_FGT(SYS_PMICFILTR_EL0,	HDFGRTR2, nPMICFILTR_EL0, 0),
+	SR_FGT(SYS_PMICNTR_EL0,		HDFGRTR2, nPMICNTR_EL0, 0),
+	SR_FGT(SYS_PMIAR_EL1,		HDFGRTR2, nPMIAR_EL1, 0),
+	SR_FGT(SYS_PMECR_EL1,		HDFGRTR2, nPMECR_EL1, 0),
+
+	/*
+	 * HDFGWTR2_EL2
+	 *
+	 * Although HDFGRTR2_EL2 and HDFGWTR2_EL2 registers largely
+	 * overlap in their bit assignment, there are a number of bits
+	 * that are RES0 on one side, and an actual trap bit on the
+	 * other.  The policy chosen here is to describe all the
+	 * read-side mappings, and only the write-side mappings that
+	 * differ from the read side, and the trap handler will pick
+	 * the correct shadow register based on the access type.
+	 */
+	SR_FGT(SYS_PMZR_EL0,		HDFGWTR2, nPMZR_EL0, 0),
+
+	/* HFGRTR2_EL2 */
+	SR_FGT(SYS_RCWSMASK_EL1,	HFGRTR2, nRCWSMASK_EL1, 0),
+	SR_FGT(SYS_ERXGSR_EL1,		HFGRTR2, nERXGSR_EL1, 0),
+	SR_FGT(SYS_PFAR_EL1,		HFGRTR2, nPFAR_EL1, 0),
 };
 
 static union trap_config get_trap_config(u32 sysreg)
@@ -2154,6 +2306,14 @@ static bool check_fgt_bit(struct kvm *kvm, bool is_read,
 		sr = is_read ? HDFGRTR_EL2 : HDFGWTR_EL2;
 		break;
 
+	case HDFGRTR2_GROUP:
+		sr = is_read ? HDFGRTR2_EL2 : HDFGWTR2_EL2;
+		break;
+
+	case HFGRTR2_GROUP:
+		sr = is_read ? HFGRTR2_EL2 : HFGWTR2_EL2;
+		break;
+
 	case HAFGRTR_GROUP:
 		sr = HAFGRTR_EL2;
 		break;
@@ -2162,6 +2322,10 @@ static bool check_fgt_bit(struct kvm *kvm, bool is_read,
 		sr = HFGITR_EL2;
 		break;
 
+	case HFGITR2_GROUP:
+		sr = HFGITR2_EL2;
+		break;
+
 	default:
 		WARN_ONCE(1, "Unhandled FGT group");
 		return false;
@@ -2228,6 +2392,20 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 			val = __vcpu_sys_reg(vcpu, HDFGWTR_EL2);
 		break;
 
+	case HDFGRTR2_GROUP:
+		if (is_read)
+			val = __vcpu_sys_reg(vcpu, HDFGRTR2_EL2);
+		else
+			val = __vcpu_sys_reg(vcpu, HDFGWTR2_EL2);
+		break;
+
+	case HFGRTR2_GROUP:
+		if (is_read)
+			val = __vcpu_sys_reg(vcpu, HFGRTR2_EL2);
+		else
+			val = __vcpu_sys_reg(vcpu, HFGWTR2_EL2);
+		break;
+
 	case HAFGRTR_GROUP:
 		val = __vcpu_sys_reg(vcpu, HAFGRTR_EL2);
 		break;
@@ -2247,6 +2425,10 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 		}
 		break;
 
+	case HFGITR2_GROUP:
+		val = __vcpu_sys_reg(vcpu, HFGITR2_EL2);
+		break;
+
 	case __NR_FGT_GROUP_IDS__:
 		/* Something is really wrong, bail out */
 		WARN_ONCE(1, "__NR_FGT_GROUP_IDS__");
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 46d52e8a3df3..570c061e8ccd 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -84,10 +84,21 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		case HFGITR_EL2:					\
 			id = HFGITR_GROUP;				\
 			break;						\
+		case HFGITR2_EL2:					\
+			id = HFGITR2_GROUP;				\
+			break;						\
 		case HDFGRTR_EL2:					\
 		case HDFGWTR_EL2:					\
 			id = HDFGRTR_GROUP;				\
 			break;						\
+		case HDFGRTR2_EL2:					\
+		case HDFGWTR2_EL2:					\
+			id = HDFGRTR2_GROUP;				\
+			break;						\
+		case HFGRTR2_EL2:					\
+		case HFGWTR2_EL2:					\
+			id = HFGRTR2_GROUP;				\
+			break;						\
 		case HAFGRTR_EL2:					\
 			id = HAFGRTR_GROUP;				\
 			break;						\
@@ -159,6 +170,11 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	CHECK_FGT_MASKS(HDFGWTR_EL2);
 	CHECK_FGT_MASKS(HAFGRTR_EL2);
 	CHECK_FGT_MASKS(HCRX_EL2);
+	CHECK_FGT_MASKS(HDFGRTR2_EL2);
+	CHECK_FGT_MASKS(HDFGWTR2_EL2);
+	CHECK_FGT_MASKS(HFGITR2_EL2);
+	CHECK_FGT_MASKS(HFGRTR2_EL2);
+	CHECK_FGT_MASKS(HFGWTR2_EL2);
 
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		return;
@@ -170,6 +186,11 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	update_fgt_traps(hctxt, vcpu, kvm, HFGITR_EL2);
 	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR_EL2);
 	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR2_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR2_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HFGITR2_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HFGRTR2_EL2);
+	update_fgt_traps(hctxt, vcpu, kvm, HFGWTR2_EL2);
 
 	if (cpu_has_amu())
 		update_fgt_traps(hctxt, vcpu, kvm, HAFGRTR_EL2);
@@ -199,6 +220,11 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	__deactivate_fgt(hctxt, vcpu, kvm, HFGITR_EL2);
 	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR_EL2);
 	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR2_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR2_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HFGITR2_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HFGRTR2_EL2);
+	__deactivate_fgt(hctxt, vcpu, kvm, HFGWTR2_EL2);
 
 	if (cpu_has_amu())
 		__deactivate_fgt(hctxt, vcpu, kvm, HAFGRTR_EL2);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f9e30dd34c7a..845fa765fcef 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1125,6 +1125,52 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
 	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | HDFGRTR_EL2_RES0, res1);
 
+	/* HDFG[RW]TR2_EL2 */
+	res0 = res1 = 0;
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR2_EL1, STEP, IMP))
+		res0 |= HDFGRTR2_EL2_nMDSTEPOP_EL1;
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
+		res0 |= HDFGRTR2_EL2_nTRBMPAM_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, ITE, IMP))
+		res0 |= HDFGRTR2_EL2_nTRCITECR_EL1;
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4))
+		res0 |= HDFGRTR2_EL2_nPMSDSFR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
+		res0 |= (HDFGRTR2_EL2_nSPMDEVAFF_EL1 | HDFGRTR2_EL2_nSPMID |
+			 HDFGRTR2_EL2_nSPMSCR_EL1 | HDFGRTR2_EL2_nSPMACCESSR_EL1 |
+			 HDFGRTR2_EL2_nSPMCR_EL0 | HDFGRTR2_EL2_nSPMOVS |
+			 HDFGRTR2_EL2_nSPMINTEN | HDFGRTR2_EL2_nSPMCNTEN |
+			 HDFGRTR2_EL2_nSPMSELR_EL0 | HDFGRTR2_EL2_nSPMEVTYPERn_EL0 |
+			 HDFGRTR2_EL2_nSPMEVCNTRn_EL0);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
+		res0 |=	(HDFGRTR2_EL2_nPMSSCR_EL1 | HDFGRTR2_EL2_nPMSSDATA);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
+		res0 |= HDFGRTR2_EL2_nMDSELR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9))
+		res0 |= HDFGRTR2_EL2_nPMUACR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP))
+		res0 |= (HDFGRTR2_EL2_nPMICFILTR_EL0 | HDFGRTR2_EL2_nPMICNTR_EL0);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, SEBEP, IMP))
+		res0 |= HDFGRTR2_EL2_nPMIAR_EL1;
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP) &&
+	    !kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
+		res0 |= HDFGRTR2_EL2_nPMECR_EL1;
+	set_sysreg_masks(kvm, HDFGRTR2_EL2, res0 | HDFGRTR2_EL2_RES0, res1 | HDFGRTR2_EL2_RES1);
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9))
+		res0 |= HDFGWTR2_EL2_nPMZR_EL0;
+	set_sysreg_masks(kvm, HDFGWTR2_EL2, res0 | HDFGWTR2_EL2_RES0, res1 | HDFGWTR2_EL2_RES1);
+
+	/* HFG[R|W]TR2_EL2 */
+	res0 = res1 = 0;
+	if (!kvm_has_feat_enum(kvm, ID_AA64PFR1_EL1, THE, IMP))
+		res0 |= HFGRTR2_EL2_nRCWSMASK_EL1;
+	if (!kvm_has_feat_enum(kvm, ID_AA64PFR0_EL1, RAS, V2))
+		res0 |= HFGRTR2_EL2_nERXGSR_EL1;
+	if (!kvm_has_feat_enum(kvm, ID_AA64PFR1_EL1, PFAR, IMP))
+		res0 |= HFGRTR2_EL2_nPFAR_EL1;
+	set_sysreg_masks(kvm, HFGRTR2_EL2, res0 | HFGRTR2_EL2_RES0, res1 | HFGRTR2_EL2_RES1);
+	set_sysreg_masks(kvm, HFGWTR2_EL2, res0 | HFGWTR2_EL2_RES0, res1 | HFGWTR2_EL2_RES1);
+
 	/* Reuse the bits from the read-side and add the write-specific stuff */
 	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
 		res0 |= (HDFGWTR_EL2_PMCR_EL0 | HDFGWTR_EL2_PMSWINC_EL0);
@@ -1168,6 +1214,12 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= HFGITR_EL2_ATS1E1A;
 	set_sysreg_masks(kvm, HFGITR_EL2, res0, res1);
 
+	/* HFGITR2_EL2 */
+	res0 = HFGITR2_EL2_RES0;
+	res1 = HFGITR2_EL2_RES1;
+	set_sysreg_masks(kvm, HFGITR2_EL2, res0 | HFGITR2_EL2_RES0, res1 | HFGITR2_EL2_RES1);
+	set_sysreg_masks(kvm, HFGITR2_EL2, res0 | HFGITR2_EL2_RES0, res1 | HFGITR2_EL2_RES1);
+
 	/* HAFGRTR_EL2 - not a lot to see here */
 	res0 = HAFGRTR_EL2_RES0;
 	res1 = HAFGRTR_EL2_RES1;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 778731491f79..4fbe6c6731c6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4723,6 +4723,65 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
 						  HAFGRTR_EL2_RES1);
 
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR2_EL1, STEP, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nMDSTEPOP_EL1;
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nTRBMPAM_EL1;
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, ITE, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nTRCITECR_EL1;
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMSDSFR_EL1;
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, SPMU, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nSPMDEVAFF_EL1	|
+						 HDFGRTR2_EL2_nSPMID		|
+						 HDFGRTR2_EL2_nSPMSCR_EL1	|
+						 HDFGRTR2_EL2_nSPMACCESSR_EL1	|
+						 HDFGRTR2_EL2_nSPMCR_EL0	|
+						 HDFGRTR2_EL2_nSPMOVS		|
+						 HDFGRTR2_EL2_nSPMINTEN		|
+						 HDFGRTR2_EL2_nSPMCNTEN		|
+						 HDFGRTR2_EL2_nSPMSELR_EL0	|
+						 HDFGRTR2_EL2_nSPMEVTYPERn_EL0	|
+						 HDFGRTR2_EL2_nSPMEVCNTRn_EL0;
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP)) {
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMSSCR_EL1;
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMSSDATA;
+	}
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, V8P9))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nMDSELR_EL1;
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, V3P9)) {
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMUACR_EL1;
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGWTR2_EL2_nPMZR_EL0;
+	}
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, PMICNTR, IMP)) {
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMICFILTR_EL0;
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMICNTR_EL0;
+	}
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, SEBEP, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMIAR_EL1;
+
+	if (!kvm_has_feat(kvm, ID_AA64DFR1_EL1, EBEP, IMP) &&
+	    !kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSS, IMP))
+		kvm->arch.fgu[HDFGRTR2_GROUP] |= HDFGRTR2_EL2_nPMECR_EL1;
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64PFR1_EL1, THE, IMP))
+		kvm->arch.fgu[HFGRTR2_GROUP] |= HFGRTR2_EL2_nRCWSMASK_EL1;
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64PFR0_EL1, RAS, V2))
+		kvm->arch.fgu[HFGRTR2_GROUP] |= HFGRTR2_EL2_nERXGSR_EL1;
+
+	if (!kvm_has_feat_enum(kvm, ID_AA64PFR1_EL1, PFAR, IMP))
+		kvm->arch.fgu[HFGRTR2_GROUP] |= HFGRTR2_EL2_nPFAR_EL1;
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.25.1

