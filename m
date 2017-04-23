From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 10/79] KVM: arm64: Use common performance monitor sysreg
 definitions
Date: Sun, 23 Apr 2017 19:08:20 +0200
Message-ID: <20170423170929.27334-11-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A81B49C52
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:06:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Inm6+s4yxtqd for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:06:56 -0400 (EDT)
Received: from mail-wr0-f181.google.com (mail-wr0-f181.google.com
 [209.85.128.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA78249C5C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:06:55 -0400 (EDT)
Received: by mail-wr0-f181.google.com with SMTP id z109so79239327wrb.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:09:42 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

Now that we have common definitions for the performance monitor register
encodings, make the KVM code use these, simplifying the sys_reg_descs
table.

The comments for PMUSERENR_EL0 and PMCCFILTR_EL0 are kept, as these
describe non-obvious details regarding the registers. However, a slight
fixup is applied to bring these into line with the usual comment style.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/sys_regs.c | 78 +++++++++++++----------------------------------
 1 file changed, 22 insertions(+), 56 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5fa23fd..63b0785 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -804,16 +804,12 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
-	/* PMEVCNTRn_EL0 */						\
-	{ Op0(0b11), Op1(0b011), CRn(0b1110),				\
-	  CRm((0b1000 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
+	{ SYS_DESC(SYS_PMEVCNTRn_EL0(n)),					\
 	  access_pmu_evcntr, reset_unknown, (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
 #define PMU_PMEVTYPER_EL0(n)						\
-	/* PMEVTYPERn_EL0 */						\
-	{ Op0(0b11), Op1(0b011), CRn(0b1110),				\
-	  CRm((0b1100 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
+	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
 	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
 
 static bool access_cntp_tval(struct kvm_vcpu *vcpu,
@@ -963,12 +959,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ Op0(0b11), Op1(0b000), CRn(0b0111), CRm(0b0100), Op2(0b000),
 	  NULL, reset_unknown, PAR_EL1 },
 
-	/* PMINTENSET_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b1001), CRm(0b1110), Op2(0b001),
-	  access_pminten, reset_unknown, PMINTENSET_EL1 },
-	/* PMINTENCLR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b1001), CRm(0b1110), Op2(0b010),
-	  access_pminten, NULL, PMINTENSET_EL1 },
+	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
+	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, NULL, PMINTENSET_EL1 },
 
 	/* MAIR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1010), CRm(0b0010), Op2(0b000),
@@ -1003,48 +995,23 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ Op0(0b11), Op1(0b010), CRn(0b0000), CRm(0b0000), Op2(0b000),
 	  NULL, reset_unknown, CSSELR_EL1 },
 
-	/* PMCR_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b000),
-	  access_pmcr, reset_pmcr, },
-	/* PMCNTENSET_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
-	  access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
-	/* PMCNTENCLR_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b010),
-	  access_pmcnten, NULL, PMCNTENSET_EL0 },
-	/* PMOVSCLR_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
-	  access_pmovs, NULL, PMOVSSET_EL0 },
-	/* PMSWINC_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
-	  access_pmswinc, reset_unknown, PMSWINC_EL0 },
-	/* PMSELR_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b101),
-	  access_pmselr, reset_unknown, PMSELR_EL0 },
-	/* PMCEID0_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
-	  access_pmceid },
-	/* PMCEID1_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b111),
-	  access_pmceid },
-	/* PMCCNTR_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
-	  access_pmu_evcntr, reset_unknown, PMCCNTR_EL0 },
-	/* PMXEVTYPER_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
-	  access_pmu_evtyper },
-	/* PMXEVCNTR_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
-	  access_pmu_evcntr },
-	/* PMUSERENR_EL0
-	 * This register resets as unknown in 64bit mode while it resets as zero
+	{ SYS_DESC(SYS_PMCR_EL0), access_pmcr, reset_pmcr, },
+	{ SYS_DESC(SYS_PMCNTENSET_EL0), access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
+	{ SYS_DESC(SYS_PMCNTENCLR_EL0), access_pmcnten, NULL, PMCNTENSET_EL0 },
+	{ SYS_DESC(SYS_PMOVSCLR_EL0), access_pmovs, NULL, PMOVSSET_EL0 },
+	{ SYS_DESC(SYS_PMSWINC_EL0), access_pmswinc, reset_unknown, PMSWINC_EL0 },
+	{ SYS_DESC(SYS_PMSELR_EL0), access_pmselr, reset_unknown, PMSELR_EL0 },
+	{ SYS_DESC(SYS_PMCEID0_EL0), access_pmceid },
+	{ SYS_DESC(SYS_PMCEID1_EL0), access_pmceid },
+	{ SYS_DESC(SYS_PMCCNTR_EL0), access_pmu_evcntr, reset_unknown, PMCCNTR_EL0 },
+	{ SYS_DESC(SYS_PMXEVTYPER_EL0), access_pmu_evtyper },
+	{ SYS_DESC(SYS_PMXEVCNTR_EL0), access_pmu_evcntr },
+	/*
+	 * PMUSERENR_EL0 resets as unknown in 64bit mode while it resets as zero
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
-	  access_pmuserenr, reset_val, PMUSERENR_EL0, 0 },
-	/* PMOVSSET_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
-	  access_pmovs, reset_unknown, PMOVSSET_EL0 },
+	{ SYS_DESC(SYS_PMUSERENR_EL0), access_pmuserenr, reset_val, PMUSERENR_EL0, 0 },
+	{ SYS_DESC(SYS_PMOVSSET_EL0), access_pmovs, reset_unknown, PMOVSSET_EL0 },
 
 	/* TPIDR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b010),
@@ -1127,12 +1094,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	PMU_PMEVTYPER_EL0(28),
 	PMU_PMEVTYPER_EL0(29),
 	PMU_PMEVTYPER_EL0(30),
-	/* PMCCFILTR_EL0
-	 * This register resets as unknown in 64bit mode while it resets as zero
+	/*
+	 * PMCCFILTR_EL0 resets as unknown in 64bit mode while it resets as zero
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1110), CRm(0b1111), Op2(0b111),
-	  access_pmu_evtyper, reset_val, PMCCFILTR_EL0, 0 },
+	{ SYS_DESC(SYS_PMCCFILTR_EL0), access_pmu_evtyper, reset_val, PMCCFILTR_EL0, 0 },
 
 	/* DACR32_EL2 */
 	{ Op0(0b11), Op1(0b100), CRn(0b0011), CRm(0b0000), Op2(0b000),
-- 
2.9.0
