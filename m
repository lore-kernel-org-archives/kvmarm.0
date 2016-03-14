From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC PATCH 05/12] kvm-arm: Move kvm_pud_huge to arch specific headers
Date: Mon, 14 Mar 2016 16:53:04 +0000
Message-ID: <1457974391-28456-6-git-send-email-suzuki.poulose@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2650749B3D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YSFNpks-bfQQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2016 12:53:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DAB049B53
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2016 12:53:11 -0400 (EDT)
In-Reply-To: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Move the kvm_pud_huge to asm/kvm_mmu.h, as on arm64, it would really
depend on the number of page table levels on the table it deals with
(hyp vs. stage2).

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |    1 +
 arch/arm/kvm/mmu.c               |    1 -
 arch/arm64/include/asm/kvm_mmu.h |    1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index e2b2a5a..4448e77 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -135,6 +135,7 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 	return (pmd_val(*pmd) & L_PMD_S2_RDWR) == L_PMD_S2_RDONLY;
 }
 
+#define kvm_pud_huge(_x)	pud_huge(_x)
 
 /* Open coded p*d_addr_end that can deal with 64bit addresses */
 #define kvm_pgd_addr_end(addr, end)					\
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 3b038bb..d1e9a71 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -45,7 +45,6 @@ static phys_addr_t hyp_idmap_vector;
 #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
 
 #define huge_pmd(_x)		(pmd_huge(_x) || pmd_trans_huge(_x))
-#define kvm_pud_huge(_x)	pud_huge(_x)
 
 #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
 #define KVM_S2_FLAG_LOGGING_ACTIVE	(1UL << 1)
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 07a09b2..a01d87d 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -141,6 +141,7 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 	return (pmd_val(*pmd) & PMD_S2_RDWR) == PMD_S2_RDONLY;
 }
 
+#define kvm_pud_huge(_x)	pud_huge(_x)
 
 #define kvm_pgd_addr_end(addr, end)	pgd_addr_end(addr, end)
 #define kvm_pud_addr_end(addr, end)	pud_addr_end(addr, end)
-- 
1.7.9.5
