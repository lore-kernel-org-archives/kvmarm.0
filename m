From: <tchalamarla@caviumnetworks.com>
Subject: [PATCH] arm64: KVM: Add 48bit PA support for EL2  translations
Date: Fri, 5 Feb 2016 11:28:16 -0800
Message-ID: <1454700496-21221-1-git-send-email-tchalamarla@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63E95497F8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 14:22:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Ni-TDXHMCHe for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2016 14:22:56 -0500 (EST)
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0098.outbound.protection.outlook.com [65.55.169.98])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EABD9497F4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 14:22:55 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>

Systems where RAM is at higher address and MultiNode systems
whith higher address RAM, 39 bit max PA for EL2 translations
is not sufficient.

This patch sets max possible PA(48bit) for EL2 translations.

Signed-off-by: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
---
 arch/arm64/include/asm/kvm_arm.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 738a95f..3fc38a4 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -98,7 +98,12 @@
 #define TCR_EL2_RES1	((1 << 31) | (1 << 23))
 #define TCR_EL2_TBI	(1 << 20)
 #define TCR_EL2_PS	(7 << 16)
+#define TCR_EL2_PS_32B	(0 << 16)
+#define TCR_EL2_PS_36B	(1 << 16)
 #define TCR_EL2_PS_40B	(2 << 16)
+#define TCR_EL2_PS_42B	(3 << 16)
+#define TCR_EL2_PS_44B	(4 << 16)
+#define TCR_EL2_PS_48B	(5 << 16)
 #define TCR_EL2_TG0	(1 << 14)
 #define TCR_EL2_SH0	(3 << 12)
 #define TCR_EL2_ORGN0	(3 << 10)
@@ -107,7 +112,10 @@
 #define TCR_EL2_MASK	(TCR_EL2_TG0 | TCR_EL2_SH0 | \
 			 TCR_EL2_ORGN0 | TCR_EL2_IRGN0 | TCR_EL2_T0SZ)
 
-#define TCR_EL2_FLAGS	(TCR_EL2_RES1 | TCR_EL2_PS_40B)
+/*
+ * Assign the highest possible PS.
+ */
+#define TCR_EL2_FLAGS	(TCR_EL2_RES1 | TCR_EL2_PS_48B)
 
 /* VTCR_EL2 Registers bits */
 #define VTCR_EL2_RES1		(1 << 31)
-- 
2.1.0
