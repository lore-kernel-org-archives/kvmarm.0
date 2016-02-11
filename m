From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 08/23] arm64: KVM: VHE: Patch out kern_hyp_va
Date: Thu, 11 Feb 2016 18:39:49 +0000
Message-ID: <1455216004-19499-9-git-send-email-marc.zyngier@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CBE149B79
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ApobTiFaFUh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 13:34:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE7AD49C15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:26 -0500 (EST)
In-Reply-To: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The kern_hyp_va macro is pretty meaninless with VHE, as there is
only one mapping - the kernel one.

In order to keep the code readable and efficient, use runtime
patching to replace the 'and' instruction used to compute the VA
with a 'nop'.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 12 +++++++++++-
 arch/arm64/kvm/hyp/hyp.h         | 25 ++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7364339..9a9318a 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -23,13 +23,16 @@
 #include <asm/cpufeature.h>
 
 /*
- * As we only have the TTBR0_EL2 register, we cannot express
+ * As ARMv8.0 only has the TTBR0_EL2 register, we cannot express
  * "negative" addresses. This makes it impossible to directly share
  * mappings with the kernel.
  *
  * Instead, give the HYP mode its own VA region at a fixed offset from
  * the kernel by just masking the top bits (which are all ones for a
  * kernel address).
+ *
+ * ARMv8.1 (using VHE) does have a TTBR1_EL2, and doesn't use these
+ * macros (the entire kernel runs at EL2).
  */
 #define HYP_PAGE_OFFSET_SHIFT	VA_BITS
 #define HYP_PAGE_OFFSET_MASK	((UL(1) << HYP_PAGE_OFFSET_SHIFT) - 1)
@@ -56,12 +59,19 @@
 
 #ifdef __ASSEMBLY__
 
+#include <asm/alternative.h>
+#include <asm/cpufeature.h>
+
 /*
  * Convert a kernel VA into a HYP VA.
  * reg: VA to be converted.
  */
 .macro kern_hyp_va	reg
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN	
 	and	\reg, \reg, #HYP_PAGE_OFFSET_MASK
+alternative_else
+	nop
+alternative_endif
 .endm
 
 #else
diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index fb27517..fc502f3 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -25,9 +25,28 @@
 
 #define __hyp_text __section(.hyp.text) notrace
 
-#define kern_hyp_va(v) (typeof(v))((unsigned long)(v) & HYP_PAGE_OFFSET_MASK)
-#define hyp_kern_va(v) (typeof(v))((unsigned long)(v) - HYP_PAGE_OFFSET \
-						      + PAGE_OFFSET)
+static inline unsigned long __kern_hyp_va(unsigned long v)
+{
+	asm volatile(ALTERNATIVE("and %0, %0, %1",
+				 "nop",
+				 ARM64_HAS_VIRT_HOST_EXTN)
+		     : "+r" (v) : "i" (HYP_PAGE_OFFSET_MASK));
+	return v;
+}
+
+#define kern_hyp_va(v) (typeof(v))(__kern_hyp_va((unsigned long)(v)))
+
+static inline unsigned long __hyp_kern_va(unsigned long v)
+{
+	u64 offset = PAGE_OFFSET - HYP_PAGE_OFFSET;
+	asm volatile(ALTERNATIVE("add %0, %0, %1",
+				 "nop",
+				 ARM64_HAS_VIRT_HOST_EXTN)
+		     : "+r" (v) : "r" (offset));
+	return v;
+}
+
+#define hyp_kern_va(v) (typeof(v))(__hyp_kern_va((unsigned long)(v)))
 
 /**
  * hyp_alternate_select - Generates patchable code sequences that are
-- 
2.1.4
