From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 13/55] arm64: KVM: Refactor kern_hyp_va to deal with multiple
 offsets
Date: Fri, 22 Jul 2016 18:28:30 +0100
Message-ID: <1469208552-4155-14-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF49C49B62
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:23:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3bKyhcDfGbLM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:23:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8F5249B7C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:23:54 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

As we move towards a selectable HYP VA range, it is obvious that
we don't want to test a variable to find out if we need to use
the bottom VA range, the top VA range, or use the address as is
(for VHE).

Instead, we can expand our current helper to generate the right
mask or nop with code patching. We default to using the top VA
space, with alternatives to switch to the bottom one or to nop
out the instructions.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 11 -----------
 arch/arm64/include/asm/kvm_mmu.h | 42 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 1d81f9a..cff5105 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -25,17 +25,6 @@
 
 #define __hyp_text __section(.hyp.text) notrace
 
-static inline unsigned long __kern_hyp_va(unsigned long v)
-{
-	asm volatile(ALTERNATIVE("and %0, %0, %1",
-				 "nop",
-				 ARM64_HAS_VIRT_HOST_EXTN)
-		     : "+r" (v) : "i" (HYP_PAGE_OFFSET_MASK));
-	return v;
-}
-
-#define kern_hyp_va(v) (typeof(v))(__kern_hyp_va((unsigned long)(v)))
-
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 5e54323..2970537 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -90,13 +90,33 @@
 /*
  * Convert a kernel VA into a HYP VA.
  * reg: VA to be converted.
+ *
+ * This generates the following sequences:
+ * - High mask:
+ *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
+ *		nop
+ * - Low mask:
+ *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
+ *		and x0, x0, #HYP_PAGE_OFFSET_LOW_MASK
+ * - VHE:
+ *		nop
+ *		nop
+ *
+ * The "low mask" version works because the mask is a strict subset of
+ * the "high mask", hence performing the first mask for nothing.
+ * Should be completely invisible on any viable CPU.
  */
 .macro kern_hyp_va	reg
-alternative_if_not ARM64_HAS_VIRT_HOST_EXTN	
-	and	\reg, \reg, #HYP_PAGE_OFFSET_MASK
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
+	and     \reg, \reg, #HYP_PAGE_OFFSET_HIGH_MASK
 alternative_else
 	nop
 alternative_endif
+alternative_if_not ARM64_HYP_OFFSET_LOW
+	nop
+alternative_else
+	and     \reg, \reg, #HYP_PAGE_OFFSET_LOW_MASK
+alternative_endif
 .endm
 
 #else
@@ -107,7 +127,23 @@ alternative_endif
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
 
-#define KERN_TO_HYP(kva)	((unsigned long)kva & HYP_PAGE_OFFSET_MASK)
+static inline unsigned long __kern_hyp_va(unsigned long v)
+{
+	asm volatile(ALTERNATIVE("and %0, %0, %1",
+				 "nop",
+				 ARM64_HAS_VIRT_HOST_EXTN)
+		     : "+r" (v)
+		     : "i" (HYP_PAGE_OFFSET_HIGH_MASK));
+	asm volatile(ALTERNATIVE("nop",
+				 "and %0, %0, %1",
+				 ARM64_HYP_OFFSET_LOW)
+		     : "+r" (v)
+		     : "i" (HYP_PAGE_OFFSET_LOW_MASK));
+	return v;
+}
+
+#define kern_hyp_va(v) 	(typeof(v))(__kern_hyp_va((unsigned long)(v)))
+#define KERN_TO_HYP(v)	kern_hyp_va(v)
 
 /*
  * We currently only support a 40bit IPA.
-- 
2.8.1
