Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3B7137753
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 06:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718259481; cv=none; b=eIxnPELdMI73PRJh1LQLWEJ1bAUt9kg8Cezi522HcF/w9xFuj5hjDcISX7oTsr89aSuWg/Ac4cGx6u5lDWfXF3duTzIVe13IyC4O0KvZ3IUF7DrdVbf5kKRFueaN8RoUql2YETprLLsWhnRnh9uBZIyN/OjxuGafVitq5TwtrF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718259481; c=relaxed/simple;
	bh=lZJzcv4ZBalvDayNT6Y3Vryzw0/8wuMb5O5sr82qFOo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IO+P7hzQTMjSilGkp8uGrRwz4jOFtwF25l3RDWe5DXS3ngzsNdTlDslemkyQIdbjyTR2qfKMOCweh3HVnQ1JxMX/tLKiZuL2uo+KejFSvmcv3TF196NPDPZicL31YRGNokCvnUOzCcsetPeI1wFR1owvdfQ/rSskcMw0ZdhtHGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 657BA1063;
	Wed, 12 Jun 2024 23:18:23 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.44.128])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 71F4A3F5A1;
	Wed, 12 Jun 2024 23:17:52 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	mark.rutland@arm.com
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Brown <broonie@kernel.org>,
	James Clark <james.clark@arm.com>,
	Rob Herring <robh@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Suzuki Poulose <suzuki.poulose@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	linux-perf-users@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH V18 2/9] KVM: arm64: Explicitly handle BRBE traps as UNDEFINED
Date: Thu, 13 Jun 2024 11:47:24 +0530
Message-Id: <20240613061731.3109448-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240613061731.3109448-1-anshuman.khandual@arm.com>
References: <20240613061731.3109448-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Branch Record Buffer Extension (BRBE) adds a number of system registers
and instructions, which we don't currently intend to expose to guests. Our
existing logic handles this safely, but this could be improved with some
explicit handling of BRBE.

The presence of BRBE is currently hidden from guests as the cpufeature
code's ftr_id_aa64dfr0[] table doesn't have an entry for the BRBE field,
and so this will be zero in the sanitised value of ID_AA64DFR0 exposed to
guests via read_sanitised_id_aa64dfr0_el1(). As the ftr_id_aa64dfr0[] table
may gain an entry for the BRBE field in future, for robustness we should
explicitly mask out the BRBE field in read_sanitised_id_aa64dfr0_el1().

The BRBE system registers and instructions are currently trapped by the
existing configuration of the fine-grained traps. As neither the registers
nor the instructions are described in the sys_reg_descs[] table,
emulate_sys_reg() will warn that these are unknown before injecting an
UNDEFINED exception into the guest.

Well-behaved guests shouldn't try to use the registers or instructions, but
badly-behaved guests could use these, resulting in unnecessary warnings. To
avoid those warnings, we should explicitly handle the BRBE registers and
instructions as UNDEFINED.

Address the above by having read_sanitised_id_aa64dfr0_el1() mask out the
ID_AA64DFR0.BRBE field, and explicitly handling all of the BRBE system
registers and instructions as UNDEFINED.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
----
Changes in V18:

- Updated the commit message

 arch/arm64/kvm/sys_regs.c | 56 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 56 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b45a15d068..3d4686abe5ee 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1304,6 +1304,11 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	return 0;
 }
 
+#define BRB_INF_SRC_TGT_EL1(n)				\
+	{ SYS_DESC(SYS_BRBINF_EL1(n)), undef_access },	\
+	{ SYS_DESC(SYS_BRBSRC_EL1(n)), undef_access },	\
+	{ SYS_DESC(SYS_BRBTGT_EL1(n)), undef_access }	\
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -1722,6 +1727,9 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	/* Hide SPE from guests */
 	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
 
+	/* Hide BRBE from guests */
+	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
+
 	return val;
 }
 
@@ -2240,6 +2248,52 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_DBGCLAIMCLR_EL1), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGAUTHSTATUS_EL1), trap_dbgauthstatus_el1 },
 
+	/*
+	 * BRBE branch record sysreg address space is interleaved between
+	 * corresponding BRBINF<N>_EL1, BRBSRC<N>_EL1, and BRBTGT<N>_EL1.
+	 */
+	BRB_INF_SRC_TGT_EL1(0),
+	BRB_INF_SRC_TGT_EL1(16),
+	BRB_INF_SRC_TGT_EL1(1),
+	BRB_INF_SRC_TGT_EL1(17),
+	BRB_INF_SRC_TGT_EL1(2),
+	BRB_INF_SRC_TGT_EL1(18),
+	BRB_INF_SRC_TGT_EL1(3),
+	BRB_INF_SRC_TGT_EL1(19),
+	BRB_INF_SRC_TGT_EL1(4),
+	BRB_INF_SRC_TGT_EL1(20),
+	BRB_INF_SRC_TGT_EL1(5),
+	BRB_INF_SRC_TGT_EL1(21),
+	BRB_INF_SRC_TGT_EL1(6),
+	BRB_INF_SRC_TGT_EL1(22),
+	BRB_INF_SRC_TGT_EL1(7),
+	BRB_INF_SRC_TGT_EL1(23),
+	BRB_INF_SRC_TGT_EL1(8),
+	BRB_INF_SRC_TGT_EL1(24),
+	BRB_INF_SRC_TGT_EL1(9),
+	BRB_INF_SRC_TGT_EL1(25),
+	BRB_INF_SRC_TGT_EL1(10),
+	BRB_INF_SRC_TGT_EL1(26),
+	BRB_INF_SRC_TGT_EL1(11),
+	BRB_INF_SRC_TGT_EL1(27),
+	BRB_INF_SRC_TGT_EL1(12),
+	BRB_INF_SRC_TGT_EL1(28),
+	BRB_INF_SRC_TGT_EL1(13),
+	BRB_INF_SRC_TGT_EL1(29),
+	BRB_INF_SRC_TGT_EL1(14),
+	BRB_INF_SRC_TGT_EL1(30),
+	BRB_INF_SRC_TGT_EL1(15),
+	BRB_INF_SRC_TGT_EL1(31),
+
+	/* Remaining BRBE sysreg addresses space */
+	{ SYS_DESC(SYS_BRBCR_EL1), undef_access },
+	{ SYS_DESC(SYS_BRBFCR_EL1), undef_access },
+	{ SYS_DESC(SYS_BRBTS_EL1), undef_access },
+	{ SYS_DESC(SYS_BRBINFINJ_EL1), undef_access },
+	{ SYS_DESC(SYS_BRBSRCINJ_EL1), undef_access },
+	{ SYS_DESC(SYS_BRBTGTINJ_EL1), undef_access },
+	{ SYS_DESC(SYS_BRBIDR0_EL1), undef_access },
+
 	{ SYS_DESC(SYS_MDCCSR_EL0), trap_raz_wi },
 	{ SYS_DESC(SYS_DBGDTR_EL0), trap_raz_wi },
 	// DBGDTR[TR]X_EL0 share the same encoding
@@ -2751,6 +2805,8 @@ static struct sys_reg_desc sys_insn_descs[] = {
 	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
 	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
+	{ SYS_DESC(OP_BRB_IALL), undef_access },
+	{ SYS_DESC(OP_BRB_INJ), undef_access },
 };
 
 static const struct sys_reg_desc *first_idreg;
-- 
2.25.1

