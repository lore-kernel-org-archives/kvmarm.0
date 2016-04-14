From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 10/17] kvm-arm: arm64: Introduce hyp page table empty checks
Date: Thu, 14 Apr 2016 14:20:58 +0100
Message-ID: <1460640065-27658-11-git-send-email-suzuki.poulose@arm.com>
References: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B8D449B8C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 09:20:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hIdbezGhemuj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2016 09:20:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6CD749BBB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 09:20:07 -0400 (EDT)
In-Reply-To: <1460640065-27658-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Introduce hyp_pxx_table_empty helpers for checking whether
a given table entry is empty. This will be used explicitly
once we switch to explicit routines for hyp page table walk.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e3f53e3..edf3c62 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -249,6 +249,20 @@ static inline bool kvm_page_empty(void *ptr)
 #endif
 
 
+#define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
+
+#ifdef __PAGETABLE_PMD_FOLDED
+#define hyp_pmd_table_empty(pmdp) (0)
+#else
+#define hyp_pmd_table_empty(pmdp) kvm_page_empty(pmdp)
+#endif
+
+#ifdef __PAGETABLE_PUD_FOLDED
+#define hyp_pud_table_empty(pudp) (0)
+#else
+#define hyp_pud_table_empty(pudp) kvm_page_empty(pudp)
+#endif
+
 struct kvm;
 
 #define kvm_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))
-- 
1.7.9.5
