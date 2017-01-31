From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 08/13] arm64: kvm: Use common debug sysreg definitions
Date: Tue, 31 Jan 2017 18:05:46 +0000
Message-ID: <1485885951-2747-9-git-send-email-mark.rutland@arm.com>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C624640A7B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:07:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3MlDeTWdsVeJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 13:07:00 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B43C40BC5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:07:00 -0500 (EST)
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

Now that we have common definitions for the debug register encodings,
make the KVM code use these, simplifying the sys_reg_descs table.

The table previously erroneously referred to MDCCSR_EL0 as MDCCSR_EL1.
This is corrected (as is necessary in order to use the common sysreg
definition).

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/sys_regs.c | 73 ++++++++++++++---------------------------------
 1 file changed, 21 insertions(+), 52 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 87e7e66..1eca0fc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -793,17 +793,13 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
-	/* DBGBVRn_EL1 */						\
-	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b100),	\
+	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
 	  trap_bvr, reset_bvr, n, 0, get_bvr, set_bvr },		\
-	/* DBGBCRn_EL1 */						\
-	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b101),	\
+	{ SYS_DESC(SYS_DBGBCRn_EL1(n)),					\
 	  trap_bcr, reset_bcr, n, 0, get_bcr, set_bcr },		\
-	/* DBGWVRn_EL1 */						\
-	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b110),	\
+	{ SYS_DESC(SYS_DBGWVRn_EL1(n)),					\
 	  trap_wvr, reset_wvr, n, 0,  get_wvr, set_wvr },		\
-	/* DBGWCRn_EL1 */						\
-	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b111),	\
+	{ SYS_DESC(SYS_DBGWCRn_EL1(n)),					\
 	  trap_wcr, reset_wcr, n, 0,  get_wcr, set_wcr }
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
@@ -844,12 +840,8 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	DBG_BCR_BVR_WCR_WVR_EL1(0),
 	DBG_BCR_BVR_WCR_WVR_EL1(1),
-	/* MDCCINT_EL1 */
-	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b000),
-	  trap_debug_regs, reset_val, MDCCINT_EL1, 0 },
-	/* MDSCR_EL1 */
-	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b010),
-	  trap_debug_regs, reset_val, MDSCR_EL1, 0 },
+	{ SYS_DESC(SYS_MDCCINT_EL1), trap_debug_regs, reset_val, MDCCINT_EL1, 0 },
+	{ SYS_DESC(SYS_MDSCR_EL1), trap_debug_regs, reset_val, MDSCR_EL1, 0 },
 	DBG_BCR_BVR_WCR_WVR_EL1(2),
 	DBG_BCR_BVR_WCR_WVR_EL1(3),
 	DBG_BCR_BVR_WCR_WVR_EL1(4),
@@ -865,44 +857,21 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	DBG_BCR_BVR_WCR_WVR_EL1(14),
 	DBG_BCR_BVR_WCR_WVR_EL1(15),
 
-	/* MDRAR_EL1 */
-	{ Op0(0b10), Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b000),
-	  trap_raz_wi },
-	/* OSLAR_EL1 */
-	{ Op0(0b10), Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b100),
-	  trap_raz_wi },
-	/* OSLSR_EL1 */
-	{ Op0(0b10), Op1(0b000), CRn(0b0001), CRm(0b0001), Op2(0b100),
-	  trap_oslsr_el1 },
-	/* OSDLR_EL1 */
-	{ Op0(0b10), Op1(0b000), CRn(0b0001), CRm(0b0011), Op2(0b100),
-	  trap_raz_wi },
-	/* DBGPRCR_EL1 */
-	{ Op0(0b10), Op1(0b000), CRn(0b0001), CRm(0b0100), Op2(0b100),
-	  trap_raz_wi },
-	/* DBGCLAIMSET_EL1 */
-	{ Op0(0b10), Op1(0b000), CRn(0b0111), CRm(0b1000), Op2(0b110),
-	  trap_raz_wi },
-	/* DBGCLAIMCLR_EL1 */
-	{ Op0(0b10), Op1(0b000), CRn(0b0111), CRm(0b1001), Op2(0b110),
-	  trap_raz_wi },
-	/* DBGAUTHSTATUS_EL1 */
-	{ Op0(0b10), Op1(0b000), CRn(0b0111), CRm(0b1110), Op2(0b110),
-	  trap_dbgauthstatus_el1 },
-
-	/* MDCCSR_EL1 */
-	{ Op0(0b10), Op1(0b011), CRn(0b0000), CRm(0b0001), Op2(0b000),
-	  trap_raz_wi },
-	/* DBGDTR_EL0 */
-	{ Op0(0b10), Op1(0b011), CRn(0b0000), CRm(0b0100), Op2(0b000),
-	  trap_raz_wi },
-	/* DBGDTR[TR]X_EL0 */
-	{ Op0(0b10), Op1(0b011), CRn(0b0000), CRm(0b0101), Op2(0b000),
-	  trap_raz_wi },
-
-	/* DBGVCR32_EL2 */
-	{ Op0(0b10), Op1(0b100), CRn(0b0000), CRm(0b0111), Op2(0b000),
-	  NULL, reset_val, DBGVCR32_EL2, 0 },
+	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1 },
+	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_DBGCLAIMSET_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_DBGCLAIMCLR_EL1), trap_raz_wi },
+	{ SYS_DESC(SYS_DBGAUTHSTATUS_EL1), trap_dbgauthstatus_el1 },
+
+	{ SYS_DESC(SYS_MDCCSR_EL0), trap_raz_wi },
+	{ SYS_DESC(SYS_DBGDTR_EL0), trap_raz_wi },
+	// DBGDTR[TR]X_EL0 share the same encoding
+	{ SYS_DESC(SYS_DBGDTRTX_EL0), trap_raz_wi },
+
+	{ SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
 
 	/* MPIDR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b101),
-- 
1.9.1
