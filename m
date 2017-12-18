From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 14/19] KVM: arm/arm64: Move HYP IO VAs to the "idmap" range
Date: Mon, 18 Dec 2017 17:39:21 +0000
Message-ID: <20171218173926.16911-15-marc.zyngier@arm.com>
References: <20171218173926.16911-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171218173926.16911-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We so far mapped our HYP IO (which is essencially the GICv2 control
registers) using the same method as for memory. It recently appeared
that is a bit unsafe:

we compute the HYP VA using the kern_hyp_va helper, but that helper
is only designed to deal with kernel VAs coming from the linear map,
and not from the vmalloc region... This could in turn cause some bad
aliasing between the two, amplified by the new VA randomisation.

A solution is to come up with our very own basic VA allocator for
MMIO. Since half of the HYP address space only contains a single
page (the idmap), we have plenty to borrow from. Let's use the idmap
as a base, and allocate downwards from it. GICv2 now lives on the
other side of the great VA barrier.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 6192d45d1e1a..0597c9846f1a 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -43,6 +43,9 @@ static unsigned long hyp_idmap_start;
 static unsigned long hyp_idmap_end;
 static phys_addr_t hyp_idmap_vector;
 
+static DEFINE_MUTEX(io_map_lock);
+static unsigned long io_map_base;
+
 #define S2_PGD_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
 #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
 
@@ -502,27 +505,31 @@ static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
  *
  * Assumes hyp_pgd is a page table used strictly in Hyp-mode and
  * therefore contains either mappings in the kernel memory area (above
- * PAGE_OFFSET), or device mappings in the vmalloc range (from
- * VMALLOC_START to VMALLOC_END).
+ * PAGE_OFFSET), or device mappings in the idmap range.
  *
- * boot_hyp_pgd should only map two pages for the init code.
+ * boot_hyp_pgd should only map the idmap range, and is only used in
+ * the extended idmap case.
  */
 void free_hyp_pgds(void)
 {
+	pgd_t *id_pgd;
+
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
+	id_pgd = boot_hyp_pgd ? boot_hyp_pgd : hyp_pgd;
+
+	if (id_pgd)
+		unmap_hyp_range(id_pgd, io_map_base,
+				hyp_idmap_start + PAGE_SIZE - io_map_base);
+
 	if (boot_hyp_pgd) {
-		unmap_hyp_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
 		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
 		boot_hyp_pgd = NULL;
 	}
 
 	if (hyp_pgd) {
-		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
 		unmap_hyp_range(hyp_pgd, kern_hyp_va(PAGE_OFFSET),
 				(uintptr_t)high_memory - PAGE_OFFSET);
-		unmap_hyp_range(hyp_pgd, kern_hyp_va(VMALLOC_START),
-				VMALLOC_END - VMALLOC_START);
 
 		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
 		hyp_pgd = NULL;
@@ -721,7 +728,8 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
 			   void __iomem **haddr)
 {
-	unsigned long start, end;
+	pgd_t *pgd = hyp_pgd;
+	unsigned long base;
 	int ret;
 
 	*kaddr = ioremap(phys_addr, size);
@@ -733,19 +741,26 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 		return 0;
 	}
 
+	mutex_lock(&io_map_lock);
+
+	base = io_map_base - size;
+	base &= ~(size - 1);
+
+	if (__kvm_cpu_uses_extended_idmap())
+		pgd = boot_hyp_pgd;
 
-	start = kern_hyp_va((unsigned long)*kaddr);
-	end = kern_hyp_va((unsigned long)*kaddr + size);
-	ret = __create_hyp_mappings(hyp_pgd, start, end,
+	ret = __create_hyp_mappings(pgd, base, base + size,
 				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
 
 	if (ret) {
 		iounmap(*kaddr);
 		*kaddr = NULL;
 	} else {
-		*haddr = (void __iomem *)start;
+		*haddr = (void __iomem *)base;
+		io_map_base = base;
 	}
 
+	mutex_unlock(&io_map_lock);
 	return ret;
 }
 
@@ -1826,6 +1841,7 @@ int kvm_mmu_init(void)
 			goto out;
 	}
 
+	io_map_base = hyp_idmap_start;
 	return 0;
 out:
 	free_hyp_pgds();
-- 
2.14.2
