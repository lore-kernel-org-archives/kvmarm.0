Return-Path: <SRS0=yjsw=MF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58DFC07E95
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 13:59:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5AB9761288
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 13:59:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AB9761288
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EFCB4A523;
	Tue, 13 Jul 2021 09:59:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dwsI2eywEfkY; Tue, 13 Jul 2021 09:59:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB2904AED4;
	Tue, 13 Jul 2021 09:59:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A5624A500
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 09:59:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A-ARvn6zkCiR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Jul 2021 09:59:08 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F13E74A4E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 09:59:07 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D297061279;
 Tue, 13 Jul 2021 13:59:06 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m3IwD-00D5p8-3e; Tue, 13 Jul 2021 14:59:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/3] KVM: arm64: Narrow PMU sysreg reset values to
 architectural requirements
Date: Tue, 13 Jul 2021 14:58:58 +0100
Message-Id: <20210713135900.1473057-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210713135900.1473057-1-maz@kernel.org>
References: <20210713135900.1473057-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, alexandre.chartre@oracle.com, robin.murphy@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Robin Murphy <robin.murphy@arm.com>
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

A number of the PMU sysregs expose reset values that are not in
compliant with the architecture (set bits in the RES0 ranges,
for example).

This in turn has the effect that we need to pointlessly mask
some register when using them.

Let's start by making sure we don't have illegal values in the
shadow registers at reset time. This affects all the registers
that dedicate one bit per counter, the counters themselves,
PMEVTYPERn_EL0 and PMSELR_EL0.

Reported-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 46 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f6f126eb6ac1..95ccb8f45409 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -603,6 +603,44 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	u64 n, mask;
+
+	/* No PMU available, any PMU reg may UNDEF... */
+	if (!kvm_arm_support_pmu_v3())
+		return;
+
+	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
+	n &= ARMV8_PMU_PMCR_N_MASK;
+
+	reset_unknown(vcpu, r);
+
+	mask = BIT(ARMV8_PMU_CYCLE_IDX);
+	if (n)
+		mask |= GENMASK(n - 1, 0);
+
+	__vcpu_sys_reg(vcpu, r->reg) &= mask;
+}
+
+static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	reset_unknown(vcpu, r);
+	__vcpu_sys_reg(vcpu, r->reg) &= GENMASK(31, 0);
+}
+
+static void reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	reset_unknown(vcpu, r);
+	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_EVTYPE_MASK;
+}
+
+static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	reset_unknown(vcpu, r);
+	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
+}
+
 static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 pmcr, val;
@@ -944,16 +982,18 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
 
 #define PMU_SYS_REG(r)						\
-	SYS_DESC(r), .reset = reset_unknown, .visibility = pmu_visibility
+	SYS_DESC(r), .reset = reset_pmu_reg, .visibility = pmu_visibility
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
 	{ PMU_SYS_REG(SYS_PMEVCNTRn_EL0(n)),				\
+	  .reset = reset_pmevcntr,					\
 	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
 #define PMU_PMEVTYPER_EL0(n)						\
 	{ PMU_SYS_REG(SYS_PMEVTYPERn_EL0(n)),				\
+	  .reset = reset_pmevtyper,					\
 	  .access = access_pmu_evtyper, .reg = (PMEVTYPER0_EL0 + n), }
 
 static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
@@ -1595,13 +1635,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
 	  .access = access_pmswinc, .reg = PMSWINC_EL0 },
 	{ PMU_SYS_REG(SYS_PMSELR_EL0),
-	  .access = access_pmselr, .reg = PMSELR_EL0 },
+	  .access = access_pmselr, .reset = reset_pmselr, .reg = PMSELR_EL0 },
 	{ PMU_SYS_REG(SYS_PMCEID0_EL0),
 	  .access = access_pmceid, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMCEID1_EL0),
 	  .access = access_pmceid, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMCCNTR_EL0),
-	  .access = access_pmu_evcntr, .reg = PMCCNTR_EL0 },
+	  .access = access_pmu_evcntr, .reset = reset_unknown, .reg = PMCCNTR_EL0 },
 	{ PMU_SYS_REG(SYS_PMXEVTYPER_EL0),
 	  .access = access_pmu_evtyper, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMXEVCNTR_EL0),
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
