Return-Path: <SRS0=u4Cy=NQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB86C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B0556113A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Aug 2021 16:19:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2B0556113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2C6E4B23F;
	Wed, 25 Aug 2021 12:19:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GGM3cKxFKKqp; Wed, 25 Aug 2021 12:19:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 028EA4B287;
	Wed, 25 Aug 2021 12:18:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CFD54B231
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:18:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hSZD2uFasU45 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Aug 2021 12:18:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46D184B24C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Aug 2021 12:17:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C9FC101E;
 Wed, 25 Aug 2021 09:17:56 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B26DB3F66F;
 Wed, 25 Aug 2021 09:17:54 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 will@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 27/39] KVM: arm64: Add SPE system registers to VCPU
 context
Date: Wed, 25 Aug 2021 17:18:03 +0100
Message-Id: <20210825161815.266051-28-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161815.266051-1-alexandru.elisei@arm.com>
References: <20210825161815.266051-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add the SPE system registers to the VCPU context. Omitted are
PMBIDR_EL1, which cannot be trapped, and PMSIR_EL1, which is a read-only
register. The registers that KVM traps are stored in the sys_regs array
on a write, and returned on a read; complete emulation and save/restore
for all registers on world switch will be added a future patches.

KVM exposes FEAT_SPEv1p1 to guests in the ID_AA64DFR0_EL1 register and
doesn't trap accesses to the profiling control registers. If the hardware
supports FEAT_SPEv1p2, the guest will be able to access the PMSNEVFR_EL1
register, which is UNDEFINED for FEAT_SPEv1p1. However, that
inconsistency is somewhat consistent with the architecture because
PMBIDR_EL1 behaves similarly: the register is UNDEFINED if SPE is missing,
but a VCPU without the SPE feature can still read the register because
there is no (easy) way for KVM to trap accesses to the register.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 +++++++
 arch/arm64/include/asm/kvm_spe.h  |  7 ++++
 arch/arm64/kvm/spe.c              | 10 ++++++
 arch/arm64/kvm/sys_regs.c         | 54 ++++++++++++++++++++++++-------
 4 files changed, 71 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7b957e439b3d..4c0d3d5ba285 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -237,6 +237,18 @@ enum vcpu_sysreg {
 	TFSR_EL1,	/* Tag Fault Status Register (EL1) */
 	TFSRE0_EL1,	/* Tag Fault Status Register (EL0) */
 
+       /* Statistical Profiling Extension Registers. */
+	PMSCR_EL1,      /* Statistical Profiling Control Register */
+	PMSICR_EL1,     /* Sampling Interval Counter Register */
+	PMSIRR_EL1,     /* Sampling Interval Reload Register */
+	PMSFCR_EL1,     /* Sampling Filter Control Register */
+	PMSEVFR_EL1,    /* Sampling Event Filter Register */
+	PMSLATFR_EL1,   /* Sampling Latency Filter Register */
+	PMBLIMITR_EL1,  /* Profiling Buffer Limit Address Register */
+	PMBPTR_EL1,     /* Profiling Buffer Write Pointer Register */
+	PMBSR_EL1,      /* Profiling Buffer Status/syndrome Register */
+	PMSCR_EL2,	/* Statistical Profiling Control Register, EL2 */
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
index 2217b821ab37..934eedb0de46 100644
--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -25,9 +25,13 @@ void kvm_spe_init_supported_cpus(void);
 void kvm_spe_vm_init(struct kvm *kvm);
 int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
 
+void kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
+u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
+
 int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
+
 #else
 #define kvm_supports_spe()	(false)
 
@@ -38,6 +42,9 @@ static inline void kvm_spe_init_supported_cpus(void) {}
 static inline void kvm_spe_vm_init(struct kvm *kvm) {}
 static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu) { return -ENOEXEC; }
 
+static inline void kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val) {}
+static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg) { return 0; }
+
 static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu,
 				   struct kvm_device_attr *attr)
 {
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 801ceb66a3d0..f760ccd8306a 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -57,6 +57,16 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
+{
+	__vcpu_sys_reg(vcpu, reg) = val;
+}
+
+u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
+{
+	return __vcpu_sys_reg(vcpu, reg);
+}
+
 static bool kvm_vcpu_supports_spe(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_supports_spe())
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ab7370b7a44b..843822be5695 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -594,6 +594,33 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
 }
 
+static unsigned int spe_visibility(const struct kvm_vcpu *vcpu,
+				  const struct sys_reg_desc *r)
+{
+	if (kvm_vcpu_has_spe(vcpu))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
+static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{	int reg = r->reg;
+	u64 val = p->regval;
+
+	if (reg < PMBLIMITR_EL1) {
+		print_sys_reg_msg(p, "Unsupported guest SPE register access at: %lx [%08lx]\n",
+				  *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
+	}
+
+	if (p->is_write)
+		kvm_spe_write_sysreg(vcpu, reg, val);
+	else
+		p->regval = kvm_spe_read_sysreg(vcpu, reg);
+
+	return true;
+}
+
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *r)
 {
@@ -956,6 +983,10 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ PMU_SYS_REG(SYS_PMEVTYPERn_EL0(n)),				\
 	  .access = access_pmu_evtyper, .reg = (PMEVTYPER0_EL0 + n), }
 
+#define SPE_SYS_REG(r)							\
+	SYS_DESC(r), .access = access_spe_reg, .reset = reset_val,	\
+	.val = 0, .visibility = spe_visibility
+
 static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
@@ -1530,18 +1561,17 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
-	{ SYS_DESC(SYS_PMSCR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSNEVFR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSICR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSIRR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSFCR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSEVFR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSLATFR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMSIDR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMBLIMITR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMBPTR_EL1), undef_access },
-	{ SYS_DESC(SYS_PMBSR_EL1), undef_access },
-	/* PMBIDR_EL1 is not trapped */
+	{ SPE_SYS_REG(SYS_PMSCR_EL1), .reg = PMSCR_EL1 },
+	{ SPE_SYS_REG(SYS_PMSICR_EL1), .reg = PMSICR_EL1 },
+	{ SPE_SYS_REG(SYS_PMSIRR_EL1), .reg = PMSIRR_EL1 },
+	{ SPE_SYS_REG(SYS_PMSFCR_EL1), .reg = PMSFCR_EL1 },
+	{ SPE_SYS_REG(SYS_PMSEVFR_EL1), .reg = PMSEVFR_EL1 },
+	{ SPE_SYS_REG(SYS_PMSLATFR_EL1), .reg = PMSLATFR_EL1 },
+	{ SPE_SYS_REG(SYS_PMSIDR_EL1), .reset = NULL },
+	{ SPE_SYS_REG(SYS_PMBLIMITR_EL1), .reg = PMBLIMITR_EL1 },
+	{ SPE_SYS_REG(SYS_PMBPTR_EL1), .reg = PMBPTR_EL1 },
+	{ SPE_SYS_REG(SYS_PMBSR_EL1), .reg = PMBSR_EL1 },
+	/* PMBIDR_EL1 and PMSCR_EL2 are not trapped */
 
 	{ PMU_SYS_REG(SYS_PMINTENSET_EL1),
 	  .access = access_pminten, .reg = PMINTENSET_EL1 },
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
