Return-Path: <SRS0=pXP7=GJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF35C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 17:23:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC95E22C7B
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 17:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC95E22C7B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DE824B3B7;
	Wed,  6 Jan 2021 12:23:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IqN9BFppbESM; Wed,  6 Jan 2021 12:22:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 447A54B3C2;
	Wed,  6 Jan 2021 12:22:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FCF44B336
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 12:22:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wuyWsxqWaFdP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jan 2021 12:22:56 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28F5F4B304
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 12:22:56 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E538D23106;
 Wed,  6 Jan 2021 17:22:54 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kxCWK-005g7y-TX; Wed, 06 Jan 2021 17:22:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/2] KVM: arm64: Hide PMU registers from userspace when not
 available
Date: Wed,  6 Jan 2021 17:22:27 +0000
Message-Id: <20210106172228.2289695-2-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106172228.2289695-1-maz@kernel.org>
References: <20210106172228.2289695-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, drjones@redhat.com, eric.auger@redhat.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

It appears that while we are now able to properly hide PMU
registers from the guest when a PMU isn't available (either
because none has been configured, the host doesn't have
the PMU support compiled in, or that the HW doesn't have
one at all), we are still exposing more than we should to
userspace.

Introduce a visibility callback gating all the PMU registers,
which covers both usrespace and guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 68 +++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 42ccc27fb684..45f4ae71c8dc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -590,6 +590,15 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
 }
 
+static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *r)
+{
+	if (kvm_vcpu_has_pmu(vcpu))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 pmcr, val;
@@ -936,15 +945,18 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ SYS_DESC(SYS_DBGWCRn_EL1(n)),					\
 	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
 
+#define PMU_SYS_REG(r)						\
+	SYS_DESC(r), .reset = reset_unknown, .visibility = pmu_visibility
+
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
-	{ SYS_DESC(SYS_PMEVCNTRn_EL0(n)),					\
-	  access_pmu_evcntr, reset_unknown, (PMEVCNTR0_EL0 + n), }
+	{ PMU_SYS_REG(SYS_PMEVCNTRn_EL0(n)),				\
+	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
 #define PMU_PMEVTYPER_EL0(n)						\
-	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
-	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
+	{ PMU_SYS_REG(SYS_PMEVTYPERn_EL0(n)),				\
+	  .access = access_pmu_evtyper, .reg = (PMEVTYPER0_EL0 + n), }
 
 static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
@@ -1486,8 +1498,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
-	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
-	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
+	{ PMU_SYS_REG(SYS_PMINTENSET_EL1),
+	  .access = access_pminten, .reg = PMINTENSET_EL1 },
+	{ PMU_SYS_REG(SYS_PMINTENCLR_EL1),
+	  .access = access_pminten, .reg = PMINTENSET_EL1 },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
@@ -1526,23 +1540,36 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 
-	{ SYS_DESC(SYS_PMCR_EL0), access_pmcr, reset_pmcr, PMCR_EL0 },
-	{ SYS_DESC(SYS_PMCNTENSET_EL0), access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
-	{ SYS_DESC(SYS_PMCNTENCLR_EL0), access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
-	{ SYS_DESC(SYS_PMOVSCLR_EL0), access_pmovs, reset_unknown, PMOVSSET_EL0 },
-	{ SYS_DESC(SYS_PMSWINC_EL0), access_pmswinc, reset_unknown, PMSWINC_EL0 },
-	{ SYS_DESC(SYS_PMSELR_EL0), access_pmselr, reset_unknown, PMSELR_EL0 },
-	{ SYS_DESC(SYS_PMCEID0_EL0), access_pmceid },
-	{ SYS_DESC(SYS_PMCEID1_EL0), access_pmceid },
-	{ SYS_DESC(SYS_PMCCNTR_EL0), access_pmu_evcntr, reset_unknown, PMCCNTR_EL0 },
-	{ SYS_DESC(SYS_PMXEVTYPER_EL0), access_pmu_evtyper },
-	{ SYS_DESC(SYS_PMXEVCNTR_EL0), access_pmu_evcntr },
+	{ PMU_SYS_REG(SYS_PMCR_EL0), .access = access_pmcr,
+	  .reset = reset_pmcr, .reg = PMCR_EL0 },
+	{ PMU_SYS_REG(SYS_PMCNTENSET_EL0),
+	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
+	{ PMU_SYS_REG(SYS_PMCNTENCLR_EL0),
+	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
+	{ PMU_SYS_REG(SYS_PMOVSCLR_EL0),
+	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
+	{ PMU_SYS_REG(SYS_PMSWINC_EL0),
+	  .access = access_pmswinc, .reg = PMSWINC_EL0 },
+	{ PMU_SYS_REG(SYS_PMSELR_EL0),
+	  .access = access_pmselr, .reg = PMSELR_EL0 },
+	{ PMU_SYS_REG(SYS_PMCEID0_EL0),
+	  .access = access_pmceid, .reset = NULL },
+	{ PMU_SYS_REG(SYS_PMCEID1_EL0),
+	  .access = access_pmceid, .reset = NULL },
+	{ PMU_SYS_REG(SYS_PMCCNTR_EL0),
+	  .access = access_pmu_evcntr, .reg = PMCCNTR_EL0 },
+	{ PMU_SYS_REG(SYS_PMXEVTYPER_EL0),
+	  .access = access_pmu_evtyper, .reset = NULL },
+	{ PMU_SYS_REG(SYS_PMXEVCNTR_EL0),
+	  .access = access_pmu_evcntr, .reset = NULL },
 	/*
 	 * PMUSERENR_EL0 resets as unknown in 64bit mode while it resets as zero
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
-	{ SYS_DESC(SYS_PMUSERENR_EL0), access_pmuserenr, reset_val, PMUSERENR_EL0, 0 },
-	{ SYS_DESC(SYS_PMOVSSET_EL0), access_pmovs, reset_unknown, PMOVSSET_EL0 },
+	{ PMU_SYS_REG(SYS_PMUSERENR_EL0), .access = access_pmuserenr,
+	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
+	{ PMU_SYS_REG(SYS_PMOVSSET_EL0),
+	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
 	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
 	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
@@ -1694,7 +1721,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * PMCCFILTR_EL0 resets as unknown in 64bit mode while it resets as zero
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
-	{ SYS_DESC(SYS_PMCCFILTR_EL0), access_pmu_evtyper, reset_val, PMCCFILTR_EL0, 0 },
+	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
+	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
