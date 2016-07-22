From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 09/55] arm/arm64: KVM: Remove hyp_kern_va helper
Date: Fri, 22 Jul 2016 18:28:26 +0100
Message-ID: <1469208552-4155-10-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6563049B61
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:23:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 53wGyzexe09m for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:23:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A411D49B72
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:23:46 -0400 (EDT)
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

hyp_kern_va is now completely unused, so let's remove it entirely.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
2.8.1
