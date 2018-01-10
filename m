From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC 2/4] KVM: arm64: Support dirty page tracking for PUD hugepages
Date: Wed, 10 Jan 2018 19:07:27 +0000
Message-ID: <20180110190729.18383-3-punit.agrawal@arm.com>
References: <20180110190729.18383-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E5C849DA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jan 2018 14:03:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ohYwz77+9vSI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jan 2018 14:03:37 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E123149D36
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jan 2018 14:03:36 -0500 (EST)
In-Reply-To: <20180110190729.18383-1-punit.agrawal@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In preparation for creating PUD hugepages at stage 2, add support for
write protecting PUD hugepages when they are encountered. Write
protecting guest tables is used to track dirty pages when migrating VMs.

Also, provide trivial implementations of required kvm_s2pud_* helpers to
allow code to compile on arm32.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  9 +++++++++
 arch/arm64/include/asm/kvm_mmu.h | 10 ++++++++++
 virt/kvm/arm/mmu.c               |  9 ++++++---
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index fa6f2174276b..3fbe919b9181 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -103,6 +103,15 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 	return (pmd_val(*pmd) & L_PMD_S2_RDWR) == L_PMD_S2_RDONLY;
 }
 
+static inline void kvm_set_s2pud_readonly(pud_t *pud)
+{
+}
+
+static inline bool kvm_s2pud_readonly(pud_t *pud)
+{
+	return true;
+}
+
 static inline bool kvm_page_empty(void *ptr)
 {
 	struct page *ptr_page = virt_to_page(ptr);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 672c8684d5c2..dbfd18e08cfb 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -201,6 +201,16 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
 	return kvm_s2pte_readonly((pte_t *)pmd);
 }
 
+static inline void kvm_set_s2pud_readonly(pud_t *pud)
+{
+	kvm_set_s2pte_readonly((pte_t *)pud);
+}
+
+static inline bool kvm_s2pud_readonly(pud_t *pud)
+{
+	return kvm_s2pte_readonly((pte_t *)pud);
+}
+
 static inline bool kvm_page_empty(void *ptr)
 {
 	struct page *ptr_page = virt_to_page(ptr);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 9dea96380339..02eefda5d71e 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1155,9 +1155,12 @@ static void  stage2_wp_puds(pgd_t *pgd, phys_addr_t addr, phys_addr_t end)
 	do {
 		next = stage2_pud_addr_end(addr, end);
 		if (!stage2_pud_none(*pud)) {
-			/* TODO:PUD not supported, revisit later if supported */
-			BUG_ON(stage2_pud_huge(*pud));
-			stage2_wp_pmds(pud, addr, next);
+			if (stage2_pud_huge(*pud)) {
+				if (!kvm_s2pud_readonly(pud))
+					kvm_set_s2pud_readonly(pud);
+			} else {
+				stage2_wp_pmds(pud, addr, next);
+			}
 		}
 	} while (pud++, addr = next, addr != end);
 }
-- 
2.15.1
