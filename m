From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 09/28] KVM: arm64: Support dirty page tracking for PUD
 hugepages
Date: Wed, 19 Dec 2018 18:03:30 +0000
Message-ID: <20181219180349.242681-10-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A5954A378
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LHvxTqC5fj-l for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:04:36 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E7844A385
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:04:35 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
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
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

From: Punit Agrawal <punit.agrawal@arm.com>

In preparation for creating PUD hugepages at stage 2, add support for
write protecting PUD hugepages when they are encountered. Write
protecting guest tables is used to track dirty pages when migrating
VMs.

Also, provide trivial implementations of required kvm_s2pud_* helpers
to allow sharing of code with arm32.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
[ Replaced BUG() => WARN_ON() in arm32 pud helpers ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 15 +++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 10 ++++++++++
 virt/kvm/arm/mmu.c               | 11 +++++++----
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index e6eff8bf5d7f..9fe6c30eb2fc 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -87,6 +87,21 @@ void kvm_clear_hyp_idmap(void);
 
 #define kvm_pmd_mkhuge(pmd)	pmd_mkhuge(pmd)
 
+/*
+ * The following kvm_*pud*() functions are provided strictly to allow
+ * sharing code with arm64. They should never be called in practice.
+ */
+static inline void kvm_set_s2pud_readonly(pud_t *pud)
+{
+	WARN_ON(1);
+}
+
+static inline bool kvm_s2pud_readonly(pud_t *pud)
+{
+	WARN_ON(1);
+	return false;
+}
+
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= L_PTE_S2_RDWR;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 13d482710292..8da6d1b2a196 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -251,6 +251,16 @@ static inline bool kvm_s2pmd_exec(pmd_t *pmdp)
 	return !(READ_ONCE(pmd_val(*pmdp)) & PMD_S2_XN);
 }
 
+static inline void kvm_set_s2pud_readonly(pud_t *pudp)
+{
+	kvm_set_s2pte_readonly((pte_t *)pudp);
+}
+
+static inline bool kvm_s2pud_readonly(pud_t *pudp)
+{
+	return kvm_s2pte_readonly((pte_t *)pudp);
+}
+
 #define hyp_pte_table_empty(ptep) kvm_page_empty(ptep)
 
 #ifdef __PAGETABLE_PMD_FOLDED
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index fb5325f7a1ac..1c669c3c1208 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1347,9 +1347,12 @@ static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
 	do {
 		next = stage2_pud_addr_end(kvm, addr, end);
 		if (!stage2_pud_none(kvm, *pud)) {
-			/* TODO:PUD not supported, revisit later if supported */
-			BUG_ON(stage2_pud_huge(kvm, *pud));
-			stage2_wp_pmds(kvm, pud, addr, next);
+			if (stage2_pud_huge(kvm, *pud)) {
+				if (!kvm_s2pud_readonly(pud))
+					kvm_set_s2pud_readonly(pud);
+			} else {
+				stage2_wp_pmds(kvm, pud, addr, next);
+			}
 		}
 	} while (pud++, addr = next, addr != end);
 }
@@ -1392,7 +1395,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
  *
  * Called to start logging dirty pages after memory region
  * KVM_MEM_LOG_DIRTY_PAGES operation is called. After this function returns
- * all present PMD and PTEs are write protected in the memory region.
+ * all present PUD, PMD and PTEs are write protected in the memory region.
  * Afterwards read of dirty page log can be called.
  *
  * Acquires kvm_mmu_lock. Called with kvm->slots_lock mutex acquired,
-- 
2.19.2
