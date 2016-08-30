From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 2/2] arm64/kvm: remove unused stub functions
Date: Tue, 30 Aug 2016 17:05:56 +0100
Message-ID: <1472573156-30414-3-git-send-email-mark.rutland@arm.com>
References: <1472573156-30414-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE779411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 11:58:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3+EslPTelJG9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2016 11:58:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0558241267
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 11:58:10 -0400 (EDT)
In-Reply-To: <1472573156-30414-1-git-send-email-mark.rutland@arm.com>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that 32-bit KVM no longer performs cache maintenance for page table
updates, we no longer need empty stubs for arm64. Remove them.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_mmu.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index b6bb834..8f99ab6 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -166,12 +166,6 @@ void kvm_clear_hyp_idmap(void);
 #define	kvm_set_pte(ptep, pte)		set_pte(ptep, pte)
 #define	kvm_set_pmd(pmdp, pmd)		set_pmd(pmdp, pmd)
 
-static inline void kvm_clean_pgd(pgd_t *pgd) {}
-static inline void kvm_clean_pmd(pmd_t *pmd) {}
-static inline void kvm_clean_pmd_entry(pmd_t *pmd) {}
-static inline void kvm_clean_pte(pte_t *pte) {}
-static inline void kvm_clean_pte_entry(pte_t *pte) {}
-
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= PTE_S2_RDWR;
-- 
1.9.1
