From: <tchalamarla@caviumnetworks.com>
Subject: [PATCH V2] arm64: KVM: Configure TCR_EL2.ps at runtime
Date: Tue, 9 Feb 2016 14:15:13 -0800
Message-ID: <1455056113-25948-1-git-send-email-tchalamarla@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69718410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 17:09:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FSUEfHL78qXx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2016 17:09:39 -0500 (EST)
Received: from na01-by2-obe.outbound.protection.outlook.com
 (mail-by2on0067.outbound.protection.outlook.com [207.46.100.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69C4B410D7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 17:09:37 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>

Setting TCR_EL2.ps to 40 bits is wrong on systems with ps size is
less than 40 bits. and with systems where RAM is at higher address,
this will break KVM.

This patch sets TCR_EL2.ps at runtime similar to VTCR_EL.ps

Signed-off-by: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
---
 arch/arm64/include/asm/kvm_arm.h |  5 ++++-
 arch/arm64/kvm/hyp-init.S        | 10 ++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 738a95f..92f2ffd 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -107,7 +107,10 @@
 #define TCR_EL2_MASK	(TCR_EL2_TG0 | TCR_EL2_SH0 | \
 			 TCR_EL2_ORGN0 | TCR_EL2_IRGN0 | TCR_EL2_T0SZ)
 
-#define TCR_EL2_FLAGS	(TCR_EL2_RES1 | TCR_EL2_PS_40B)
+/*
+ * TCR_EL2.ps is configured at runtime similar to VTCR_EL2
+ */
+#define TCR_EL2_FLAGS	(TCR_EL2_RES1)
 
 /* VTCR_EL2 Registers bits */
 #define VTCR_EL2_RES1		(1 << 31)
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 3e568dc..b246de1e 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -85,15 +85,17 @@ __do_hyp_init:
 	ldr_l	x5, idmap_t0sz
 	bfi	x4, x5, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
 #endif
-	msr	tcr_el2, x4
-
-	ldr	x4, =VTCR_EL2_FLAGS
 	/*
 	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
-	 * VTCR_EL2.
+	 * TCR_EL2 and VTCR_EL2.
 	 */
 	mrs	x5, ID_AA64MMFR0_EL1
 	bfi	x4, x5, #16, #3
+
+	msr	tcr_el2, x4
+
+	ldr	x4, =VTCR_EL2_FLAGS
+	bfi	x4, x5, #16, #3
 	/*
 	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS bit in
 	 * VTCR_EL2.
-- 
2.1.0
