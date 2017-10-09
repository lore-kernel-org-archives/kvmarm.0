From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/10] arm: KVM: Use common implementation for all flushes to PoC
Date: Mon,  9 Oct 2017 16:20:32 +0100
Message-ID: <20171009152032.27804-11-marc.zyngier@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171009152032.27804-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We currently have no less than three implementations for the
"flush to PoC" code. Let standardize on a single one. This
requires a bit of unpleasant moving around, and relies on
__kvm_flush_dcache_pte and co being #defines so that they can
call into coherent_dcache_guest_page...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h | 28 ++++------------------------
 virt/kvm/arm/mmu.c             | 20 ++++++++++----------
 2 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 5f1ac88a5951..011b0db85c02 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -235,31 +235,11 @@ static inline void __coherent_icache_guest_page(kvm_pfn_t pfn,
 	}
 }
 
-static inline void __kvm_flush_dcache_pte(pte_t pte)
-{
-	void *va = kmap_atomic(pte_page(pte));
-
-	kvm_flush_dcache_to_poc(va, PAGE_SIZE);
-
-	kunmap_atomic(va);
-}
-
-static inline void __kvm_flush_dcache_pmd(pmd_t pmd)
-{
-	unsigned long size = PMD_SIZE;
-	kvm_pfn_t pfn = pmd_pfn(pmd);
-
-	while (size) {
-		void *va = kmap_atomic_pfn(pfn);
+#define __kvm_flush_dcache_pte(p)				\
+	coherent_dcache_guest_page(pte_pfn((p)), PAGE_SIZE)
 
-		kvm_flush_dcache_to_poc(va, PAGE_SIZE);
-
-		pfn++;
-		size -= PAGE_SIZE;
-
-		kunmap_atomic(va);
-	}
-}
+#define __kvm_flush_dcache_pmd(p)				\
+	coherent_dcache_guest_page(pmd_pfn((p)), PMD_SIZE)
 
 static inline void __kvm_flush_dcache_pud(pud_t pud)
 {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 5b495450e92f..ab027fdf76e7 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -70,6 +70,16 @@ static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, kvm, ipa);
 }
 
+static void coherent_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
+{
+	__coherent_dcache_guest_page(pfn, size);
+}
+
+static void coherent_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
+{
+	__coherent_icache_guest_page(pfn, size);
+}
+
 /*
  * D-Cache management functions. They take the page table entries by
  * value, as they are flushing the cache using the kernel mapping (or
@@ -1268,16 +1278,6 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
-static void coherent_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
-{
-	__coherent_dcache_guest_page(pfn, size);
-}
-
-static void coherent_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
-{
-	__coherent_icache_guest_page(pfn, size);
-}
-
 static void kvm_send_hwpoison_signal(unsigned long address,
 				     struct vm_area_struct *vma)
 {
-- 
2.14.1
