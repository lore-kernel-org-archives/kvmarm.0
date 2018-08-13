From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/37] KVM: arm/arm64: Consolidate page-table accessors
Date: Mon, 13 Aug 2018 15:57:22 +0100
Message-ID: <20180813145755.16566-5-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD2A64A1DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LA-dHsqVYKh9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 10:59:02 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0F94A205
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:02 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
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
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The arm and arm64 KVM page tables accessors are pointlessly different
between the two architectures, and likely both wrong one way or another:
arm64 lacks a dsb(), and arm doesn't use WRITE_ONCE.

Let's unify them.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 12 ------------
 arch/arm64/include/asm/kvm_mmu.h |  3 ---
 virt/kvm/arm/mmu.c               | 12 ++++++++++++
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 8553d68b7c8a..b2feaea1434c 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -75,18 +75,6 @@ phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(void);
 void kvm_clear_hyp_idmap(void);
 
-static inline void kvm_set_pmd(pmd_t *pmd, pmd_t new_pmd)
-{
-	*pmd = new_pmd;
-	dsb(ishst);
-}
-
-static inline void kvm_set_pte(pte_t *pte, pte_t new_pte)
-{
-	*pte = new_pte;
-	dsb(ishst);
-}
-
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= L_PTE_S2_RDWR;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index bac9f016736b..ea000fb47ec0 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -169,9 +169,6 @@ phys_addr_t kvm_get_idmap_vector(void);
 int kvm_mmu_init(void);
 void kvm_clear_hyp_idmap(void);
 
-#define	kvm_set_pte(ptep, pte)		set_pte(ptep, pte)
-#define	kvm_set_pmd(pmdp, pmd)		set_pmd(pmdp, pmd)
-
 static inline pte_t kvm_s2pte_mkwrite(pte_t pte)
 {
 	pte_val(pte) |= PTE_S2_RDWR;
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ea7314296ad1..a6bdbed1903a 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -177,6 +177,18 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
 	put_page(virt_to_page(pmd));
 }
 
+static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
+{
+	WRITE_ONCE(*ptep, new_pte);
+	dsb(ishst);
+}
+
+static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
+{
+	WRITE_ONCE(*pmdp, new_pmd);
+	dsb(ishst);
+}
+
 /*
  * Unmapping vs dcache management:
  *
-- 
2.18.0
