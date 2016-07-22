From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 22/55] arm/arm64: KVM: Prune unused #defines
Date: Fri, 22 Jul 2016 18:28:39 +0100
Message-ID: <1469208552-4155-23-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 755D049BAC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aNI9h9LZp5Mg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:24:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A85D149BB1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:12 -0400 (EDT)
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

We can now remove a number of dead #defines, thanks to the trampoline
code being gone.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_mmu.h   |  9 ---------
 arch/arm64/include/asm/kvm_mmu.h | 10 ----------
 2 files changed, 19 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index d5fd9fb..73c2818 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -26,18 +26,9 @@
  * We directly use the kernel VA for the HYP, as we can directly share
  * the mapping (HTTBR "covers" TTBR1).
  */
-#define HYP_PAGE_OFFSET_MASK	UL(~0)
-#define HYP_PAGE_OFFSET		PAGE_OFFSET
 #define KERN_TO_HYP(kva)	(kva)
 
 /*
- * Our virtual mapping for the boot-time MMU-enable code. Must be
- * shared across all the page-tables. Conveniently, we use the vectors
- * page, where no kernel data will ever be shared with HYP.
- */
-#define TRAMPOLINE_VA		UL(CONFIG_VECTORS_BASE)
-
-/*
  * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation levels.
  */
 #define KVM_MMU_CACHE_MIN_PAGES	2
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index b89122e..9226f8b 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -72,16 +72,6 @@
 #define HYP_PAGE_OFFSET_HIGH_MASK	((UL(1) << VA_BITS) - 1)
 #define HYP_PAGE_OFFSET_LOW_MASK	((UL(1) << (VA_BITS - 1)) - 1)
 
-/* Temporary compat define */
-#define HYP_PAGE_OFFSET_MASK		HYP_PAGE_OFFSET_HIGH_MASK
-
-/*
- * Our virtual mapping for the idmap-ed MMU-enable code. Must be
- * shared across all the page-tables. Conveniently, we use the last
- * possible page, where no kernel mapping will ever exist.
- */
-#define TRAMPOLINE_VA		(HYP_PAGE_OFFSET_MASK & PAGE_MASK)
-
 #ifdef __ASSEMBLY__
 
 #include <asm/alternative.h>
-- 
2.8.1
