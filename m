From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 4/6] KVM: arm/arm64: Consolidate page-table accessors
Date: Mon,  2 Jul 2018 16:02:48 +0100
Message-ID: <20180702150250.16550-5-marc.zyngier@arm.com>
References: <20180702150250.16550-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180702150250.16550-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
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
2.17.1
