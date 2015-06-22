From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v3 07/11] KVM: arm: add trap handlers for 64-bit debug
 registers
Date: Mon, 22 Jun 2015 18:41:30 +0800
Message-ID: <1434969694-7432-8-git-send-email-zhichao.huang@linaro.org>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66900562C5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 06:31:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IMsC01uhvbWU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Jun 2015 06:31:27 -0400 (EDT)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
 [209.85.220.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 642F8562D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 06:31:27 -0400 (EDT)
Received: by paceq1 with SMTP id eq1so107076772pac.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Jun 2015 03:42:18 -0700 (PDT)
In-Reply-To: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
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
index 59b65b7..eeee648 100644
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
 				reset_val, cp14_DBGDSCRext, 0 },
-- 
1.7.12.4
