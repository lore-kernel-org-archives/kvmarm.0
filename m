From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH 2/3] kvm: arm: make kvm_arm.h friendly to assembly code
Date: Mon, 16 Nov 2015 11:28:17 +0000
Message-ID: <1447673298-25503-3-git-send-email-vladimir.murzin@arm.com>
References: <1447673298-25503-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49A8249786
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 06:28:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cOjHFqXSfczL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2015 06:28:17 -0500 (EST)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [207.82.80.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FB9149776
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 06:28:17 -0500 (EST)
In-Reply-To: <1447673298-25503-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

kvm_arm.h is included from both C code and assembly code; however some
definitions in this header supplied with U/UL/ULL suffixes which might
confuse assembly once they got evaluated.
We have _AC macro for such cases, so just wrap problem places with it.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/include/asm/kvm_arm.h |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index b05bb5a..01d4d7a 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -19,6 +19,7 @@
 #ifndef __ARM_KVM_ARM_H__
 #define __ARM_KVM_ARM_H__
 
+#include <linux/const.h>
 #include <linux/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
@@ -132,9 +133,9 @@
  * space.
  */
 #define KVM_PHYS_SHIFT	(40)
-#define KVM_PHYS_SIZE	(1ULL << KVM_PHYS_SHIFT)
-#define KVM_PHYS_MASK	(KVM_PHYS_SIZE - 1ULL)
-#define PTRS_PER_S2_PGD	(1ULL << (KVM_PHYS_SHIFT - 30))
+#define KVM_PHYS_SIZE	(_AC(1, ULL) << KVM_PHYS_SHIFT)
+#define KVM_PHYS_MASK	(KVM_PHYS_SIZE - _AC(1, ULL))
+#define PTRS_PER_S2_PGD	(_AC(1, ULL) << (KVM_PHYS_SHIFT - 30))
 
 /* Virtualization Translation Control Register (VTCR) bits */
 #define VTCR_SH0	(3 << 12)
@@ -161,17 +162,17 @@
 #define VTTBR_X		(5 - KVM_T0SZ)
 #endif
 #define VTTBR_BADDR_SHIFT (VTTBR_X - 1)
-#define VTTBR_BADDR_MASK  (((1LLU << (40 - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
-#define VTTBR_VMID_SHIFT  (48LLU)
-#define VTTBR_VMID_MASK	  (0xffLLU << VTTBR_VMID_SHIFT)
+#define VTTBR_BADDR_MASK  (((_AC(1, ULL) << (40 - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
+#define VTTBR_VMID_SHIFT  _AC(48, ULL)
+#define VTTBR_VMID_MASK	  (_AC(0xff, ULL) << VTTBR_VMID_SHIFT)
 
 /* Hyp Syndrome Register (HSR) bits */
 #define HSR_EC_SHIFT	(26)
-#define HSR_EC		(0x3fU << HSR_EC_SHIFT)
-#define HSR_IL		(1U << 25)
+#define HSR_EC		(_AC(0x3f, UL) << HSR_EC_SHIFT)
+#define HSR_IL		(_AC(1, UL) << 25)
 #define HSR_ISS		(HSR_IL - 1)
 #define HSR_ISV_SHIFT	(24)
-#define HSR_ISV		(1U << HSR_ISV_SHIFT)
+#define HSR_ISV		(_AC(1, UL) << HSR_ISV_SHIFT)
 #define HSR_SRT_SHIFT	(16)
 #define HSR_SRT_MASK	(0xf << HSR_SRT_SHIFT)
 #define HSR_FSC		(0x3f)
@@ -179,9 +180,9 @@
 #define HSR_SSE		(1 << 21)
 #define HSR_WNR		(1 << 6)
 #define HSR_CV_SHIFT	(24)
-#define HSR_CV		(1U << HSR_CV_SHIFT)
+#define HSR_CV		(_AC(1, UL) << HSR_CV_SHIFT)
 #define HSR_COND_SHIFT	(20)
-#define HSR_COND	(0xfU << HSR_COND_SHIFT)
+#define HSR_COND	(_AC(0xf, UL) << HSR_COND_SHIFT)
 
 #define FSC_FAULT	(0x04)
 #define FSC_ACCESS	(0x08)
@@ -209,13 +210,13 @@
 #define HSR_EC_DABT	(0x24)
 #define HSR_EC_DABT_HYP	(0x25)
 
-#define HSR_WFI_IS_WFE		(1U << 0)
+#define HSR_WFI_IS_WFE		(_AC(1, UL) << 0)
 
-#define HSR_HVC_IMM_MASK	((1UL << 16) - 1)
+#define HSR_HVC_IMM_MASK	((_AC(1, UL) << 16) - 1)
 
-#define HSR_DABT_S1PTW		(1U << 7)
-#define HSR_DABT_CM		(1U << 8)
-#define HSR_DABT_EA		(1U << 9)
+#define HSR_DABT_S1PTW		(_AC(1, UL) << 7)
+#define HSR_DABT_CM		(_AC(1, UL) << 8)
+#define HSR_DABT_EA		(_AC(1, UL) << 9)
 
 #define kvm_arm_exception_type	\
 	{0, "RESET" }, 		\
-- 
1.7.9.5
