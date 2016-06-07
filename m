From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/15] arm64: KVM: Kill HYP_PAGE_OFFSET
Date: Tue,  7 Jun 2016 11:58:22 +0100
Message-ID: <1465297115-13091-3-git-send-email-marc.zyngier@arm.com>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

HYP_PAGE_OFFSET is not massively useful. And the way we use it
in KERN_HYP_VA is inconsistent with the equivalent operation in
EL2, where we use a mask instead.

Let's replace the uses of HYP_PAGE_OFFSET with HYP_PAGE_OFFSET_MASK,
and get rid of the pointless macro.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 5 ++---
 arch/arm64/include/asm/kvm_mmu.h | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 44eaff7..61d01a9 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -38,11 +38,10 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 
 static inline unsigned long __hyp_kern_va(unsigned long v)
 {
-	u64 offset = PAGE_OFFSET - HYP_PAGE_OFFSET;
-	asm volatile(ALTERNATIVE("add %0, %0, %1",
+	asm volatile(ALTERNATIVE("orr %0, %0, %1",
 				 "nop",
 				 ARM64_HAS_VIRT_HOST_EXTN)
-		     : "+r" (v) : "r" (offset));
+		     : "+r" (v) : "i" (~HYP_PAGE_OFFSET_MASK));
 	return v;
 }
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 00bc277..d162372 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -75,7 +75,6 @@
  */
 #define HYP_PAGE_OFFSET_SHIFT	VA_BITS
 #define HYP_PAGE_OFFSET_MASK	((UL(1) << HYP_PAGE_OFFSET_SHIFT) - 1)
-#define HYP_PAGE_OFFSET		(PAGE_OFFSET & HYP_PAGE_OFFSET_MASK)
 
 /*
  * Our virtual mapping for the idmap-ed MMU-enable code. Must be
@@ -109,7 +108,7 @@ alternative_endif
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
 
-#define KERN_TO_HYP(kva)	((unsigned long)kva - PAGE_OFFSET + HYP_PAGE_OFFSET)
+#define KERN_TO_HYP(kva)	((unsigned long)kva & HYP_PAGE_OFFSET_MASK)
 
 /*
  * We currently only support a 40bit IPA.
-- 
2.1.4

