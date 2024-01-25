Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111811CAA3
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 09:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706175708; cv=none; b=CXThcNjR8XRVQKsDwnhf/7fk/ovcTj2QhsBUnctz/q1l6JhGWqQ1/BMx2CRufI9coiJAtVHRUKPIHZuoShmvwStOMp4pp4+w3aTot0EI9FxWf01MyGn36ZnoztS8WtOchk06Dbnf1QcWLjc5IjfTtRWNnxKGvnaH1EQ/5jL6kvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706175708; c=relaxed/simple;
	bh=QQgmZAAScA+7Wj2GCosakYmLL9i8rFDmVgjo+VnJ/AA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S7IG+ku4u3XzqZ9ZiDfWPQlvE2GvogNS+Tv8WklAULjzXclMKNHy7RlGaG5l0VQpVgGIilH0DmIgPeZVovMqdYddnj8pHyGZ35PDeAlBVJH/DKBdXik8oYhsmaKWE/p3LBFXWJZzXnCPp4SeKQ0bNKmSEQgs3RCI3ku+EttXt4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 138C61480;
	Thu, 25 Jan 2024 01:42:31 -0800 (PST)
Received: from a077893.arm.com (unknown [10.163.40.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 08AC23F73F;
	Thu, 25 Jan 2024 01:41:40 -0800 (PST)
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
Subject: [PATCH V16 2/8] KVM: arm64: Prevent guest accesses into BRBE system registers/instructions
Date: Thu, 25 Jan 2024 15:11:13 +0530
Message-Id: <20240125094119.2542332-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240125094119.2542332-1-anshuman.khandual@arm.com>
References: <20240125094119.2542332-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently BRBE feature is not supported in a guest environment. This hides
BRBE feature availability via masking ID_AA64DFR0_EL1.BRBE field. This also
blocks guest accesses into BRBE system registers and instructions as if the
underlying hardware never implemented FEAT_BRBE feature.

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
---
Changes in V16:

- Added BRB_INF_SRC_TGT_EL1 macro for corresponding BRB_[INF|SRC|TGT] expansion

 arch/arm64/kvm/sys_regs.c | 56 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 30253bd19917..6a06dc2f0c06 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1304,6 +1304,11 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	return 0;
 }
 
+#define BRB_INF_SRC_TGT_EL1(n)					\
+	{ SYS_DESC(SYS_BRBINF##n##_EL1), undef_access },	\
+	{ SYS_DESC(SYS_BRBSRC##n##_EL1), undef_access },	\
+	{ SYS_DESC(SYS_BRBTGT##n##_EL1), undef_access }		\
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -1707,6 +1712,9 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	/* Hide SPE from guests */
 	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
 
+	/* Hide BRBE from guests */
+	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
+
 	return val;
 }
 
@@ -2195,6 +2203,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
 	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
 	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
+	{ SYS_DESC(OP_BRB_IALL), undef_access },
+	{ SYS_DESC(OP_BRB_INJ), undef_access },
 
 	DBG_BCR_BVR_WCR_WVR_EL1(0),
 	DBG_BCR_BVR_WCR_WVR_EL1(1),
@@ -2225,6 +2235,52 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
-- 
2.25.1

