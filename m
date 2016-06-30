From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 03/18] arm/arm64: KVM: Remove hyp_kern_va helper
Date: Thu, 30 Jun 2016 18:40:36 +0100
Message-ID: <1467308451-13365-4-git-send-email-marc.zyngier@arm.com>
References: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08F0849B54
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nnf4uY4-EDvP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 13:35:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34BF449B71
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:45 -0400 (EDT)
In-Reply-To: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

hyp_kern_va is now completely unused, so let's remove it entirely.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_hyp.h   |  1 -
 arch/arm64/include/asm/kvm_hyp.h | 12 ------------
 2 files changed, 13 deletions(-)

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index f0e8607..e38fce2 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -26,7 +26,6 @@
 #define __hyp_text __section(.hyp.text) notrace
 
 #define kern_hyp_va(v) (v)
-#define hyp_kern_va(v) (v)
 
 #define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
 	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 44eaff7..1d81f9a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -36,18 +36,6 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 
 #define kern_hyp_va(v) (typeof(v))(__kern_hyp_va((unsigned long)(v)))
 
-static inline unsigned long __hyp_kern_va(unsigned long v)
-{
-	u64 offset = PAGE_OFFSET - HYP_PAGE_OFFSET;
-	asm volatile(ALTERNATIVE("add %0, %0, %1",
-				 "nop",
-				 ARM64_HAS_VIRT_HOST_EXTN)
-		     : "+r" (v) : "r" (offset));
-	return v;
-}
-
-#define hyp_kern_va(v) (typeof(v))(__hyp_kern_va((unsigned long)(v)))
-
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
-- 
2.1.4
