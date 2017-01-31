From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 12/13] arm64: kvm: Use common sysreg definitions
Date: Tue, 31 Jan 2017 18:05:50 +0000
Message-ID: <1485885951-2747-13-git-send-email-mark.rutland@arm.com>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 685FC40A80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:07:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kJEkgGm071CJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 13:07:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D36BA40C26
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:07:07 -0500 (EST)
In-Reply-To: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that we have common definitions for the remaining register encodings
required by KVM, make the KVM code use these, simplifying the
sys_reg_descs table and the genericv8_sys_regs table.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/sys_regs.c            | 94 +++++++++---------------------------
 arch/arm64/kvm/sys_regs_generic_v8.c |  4 +-
 2 files changed, 25 insertions(+), 73 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ec01776..2b0b5fc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -869,72 +869,36 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	{ SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
 
-	/* MPIDR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b101),
-	  NULL, reset_mpidr, MPIDR_EL1 },
-	/* SCTLR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b000),
-	  access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
-	/* CPACR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b010),
-	  NULL, reset_val, CPACR_EL1, 0 },
-	/* TTBR0_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0010), CRm(0b0000), Op2(0b000),
-	  access_vm_reg, reset_unknown, TTBR0_EL1 },
-	/* TTBR1_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0010), CRm(0b0000), Op2(0b001),
-	  access_vm_reg, reset_unknown, TTBR1_EL1 },
-	/* TCR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0010), CRm(0b0000), Op2(0b010),
-	  access_vm_reg, reset_val, TCR_EL1, 0 },
-
-	/* AFSR0_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0101), CRm(0b0001), Op2(0b000),
-	  access_vm_reg, reset_unknown, AFSR0_EL1 },
-	/* AFSR1_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0101), CRm(0b0001), Op2(0b001),
-	  access_vm_reg, reset_unknown, AFSR1_EL1 },
-	/* ESR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0101), CRm(0b0010), Op2(0b000),
-	  access_vm_reg, reset_unknown, ESR_EL1 },
-	/* FAR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0110), CRm(0b0000), Op2(0b000),
-	  access_vm_reg, reset_unknown, FAR_EL1 },
-	/* PAR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0111), CRm(0b0100), Op2(0b000),
-	  NULL, reset_unknown, PAR_EL1 },
+	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
+	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
+	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
+	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
+	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
+	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
+
+	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
+	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
+	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
+	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
+	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
 	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
 	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, NULL, PMINTENSET_EL1 },
 
-	/* MAIR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b1010), CRm(0b0010), Op2(0b000),
-	  access_vm_reg, reset_unknown, MAIR_EL1 },
-	/* AMAIR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b1010), CRm(0b0011), Op2(0b000),
-	  access_vm_reg, reset_amair_el1, AMAIR_EL1 },
+	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
+	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
 
-	/* VBAR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b0000), Op2(0b000),
-	  NULL, reset_val, VBAR_EL1, 0 },
+	{ SYS_DESC(SYS_VBAR_EL1), NULL, reset_val, VBAR_EL1, 0 },
 
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
 	{ SYS_DESC(SYS_ICC_SRE_EL1), access_gic_sre },
 
-	/* CONTEXTIDR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b1101), CRm(0b0000), Op2(0b001),
-	  access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
-	/* TPIDR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b1101), CRm(0b0000), Op2(0b100),
-	  NULL, reset_unknown, TPIDR_EL1 },
+	{ SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
+	{ SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
 
-	/* CNTKCTL_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b1110), CRm(0b0001), Op2(0b000),
-	  NULL, reset_val, CNTKCTL_EL1, 0},
+	{ SYS_DESC(SYS_CNTKCTL_EL1), NULL, reset_val, CNTKCTL_EL1, 0},
 
-	/* CSSELR_EL1 */
-	{ Op0(0b11), Op1(0b010), CRn(0b0000), CRm(0b0000), Op2(0b000),
-	  NULL, reset_unknown, CSSELR_EL1 },
+	{ SYS_DESC(SYS_CSSELR_EL1), NULL, reset_unknown, CSSELR_EL1 },
 
 	{ SYS_DESC(SYS_PMCR_EL0), access_pmcr, reset_pmcr, },
 	{ SYS_DESC(SYS_PMCNTENSET_EL0), access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
@@ -954,12 +918,8 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ SYS_DESC(SYS_PMUSERENR_EL0), access_pmuserenr, reset_val, PMUSERENR_EL0, 0 },
 	{ SYS_DESC(SYS_PMOVSSET_EL0), access_pmovs, reset_unknown, PMOVSSET_EL0 },
 
-	/* TPIDR_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b010),
-	  NULL, reset_unknown, TPIDR_EL0 },
-	/* TPIDRRO_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b011),
-	  NULL, reset_unknown, TPIDRRO_EL0 },
+	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
+	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
 
 	/* PMEVCNTRn_EL0 */
 	PMU_PMEVCNTR_EL0(0),
@@ -1031,15 +991,9 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	 */
 	{ SYS_DESC(SYS_PMCCFILTR_EL0), access_pmu_evtyper, reset_val, PMCCFILTR_EL0, 0 },
 
-	/* DACR32_EL2 */
-	{ Op0(0b11), Op1(0b100), CRn(0b0011), CRm(0b0000), Op2(0b000),
-	  NULL, reset_unknown, DACR32_EL2 },
-	/* IFSR32_EL2 */
-	{ Op0(0b11), Op1(0b100), CRn(0b0101), CRm(0b0000), Op2(0b001),
-	  NULL, reset_unknown, IFSR32_EL2 },
-	/* FPEXC32_EL2 */
-	{ Op0(0b11), Op1(0b100), CRn(0b0101), CRm(0b0011), Op2(0b000),
-	  NULL, reset_val, FPEXC32_EL2, 0x70 },
+	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
+	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
+	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x70 },
 };
 
 static bool trap_dbgidr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
index 46af718..969ade1 100644
--- a/arch/arm64/kvm/sys_regs_generic_v8.c
+++ b/arch/arm64/kvm/sys_regs_generic_v8.c
@@ -52,9 +52,7 @@ static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
  */
 static const struct sys_reg_desc genericv8_sys_regs[] = {
-	/* ACTLR_EL1 */
-	{ Op0(0b11), Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b001),
-	  access_actlr, reset_actlr, ACTLR_EL1 },
+	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
 };
 
 static const struct sys_reg_desc genericv8_cp15_regs[] = {
-- 
1.9.1
