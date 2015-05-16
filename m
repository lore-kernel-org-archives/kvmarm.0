From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH 07/10] KVM: arm: add trap handlers for 64-bit debug registers
Date: Sat, 16 May 2015 12:45:48 +0800
Message-ID: <1431751551-4788-8-git-send-email-zhichao.huang@linaro.org>
References: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1431751551-4788-1-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Add handlers for all the 64-bit debug registers.

There is an overlap between 32 and 64bit registers. Make sure that
64-bit registers preceding 32-bit ones.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/kvm/coproc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index 3d7c09e..cba81ed 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -435,9 +435,17 @@ static const struct coproc_reg cp15_regs[] = {
 	{ CRn( 1), CRm((n)), Op1( 0), Op2( 1), is32, trap_raz_wi }
 
 /*
+ * Architected CP14 registers.
+ *
  * Trapped cp14 registers. We generally ignore most of the external
  * debug, on the principle that they don't really make sense to a
  * guest. Revisit this one day, whould this principle change.
+ *
+ * CRn denotes the primary register number, but is copied to the CRm in the
+ * user space API for 64-bit register access in line with the terminology used
+ * in the ARM ARM.
+ * Important: Must be sorted ascending by CRn, CRM, Op1, Op2 and with 64-bit
+ *            registers preceding 32-bit ones.
  */
 static const struct coproc_reg cp14_regs[] = {
 	/* DBGIDR */
@@ -445,10 +453,14 @@ static const struct coproc_reg cp14_regs[] = {
 	/* DBGDTRRXext */
 	{ CRn( 0), CRm( 0), Op1( 0), Op2( 2), is32, trap_raz_wi },
 	DBG_BCR_BVR_WCR_WVR(0),
+	/* DBGDRAR (64bit) */
+	{ CRn( 0), CRm( 1), Op1( 0), Op2( 0), is64, trap_raz_wi},
 	/* DBGDSCRint */
 	{ CRn( 0), CRm( 1), Op1( 0), Op2( 0), is32, trap_dbgdscr,
 				NULL, cp14_DBGDSCRext },
 	DBG_BCR_BVR_WCR_WVR(1),
+	/* DBGDSAR (64bit) */
+	{ CRn( 0), CRm( 2), Op1( 0), Op2( 0), is64, trap_raz_wi},
 	/* DBGDSCRext */
 	{ CRn( 0), CRm( 2), Op1( 0), Op2( 2), is32, trap_debug32,
 				NULL, cp14_DBGDSCRext },
-- 
1.7.12.4

