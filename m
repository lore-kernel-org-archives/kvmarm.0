From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 65/85] KVM: arm/arm64: Move HYP IO VAs to the "idmap" range
Date: Wed, 28 Mar 2018 13:52:34 +0100
Message-ID: <20180328125254.31380-66-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8B9A49FC0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:59:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VvIh5OLblOKg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:58:40 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BA2149F9E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:49:25 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We so far mapped our HYP IO (which is essentially the GICv2 control
registers) using the same method as for memory. It recently appeared
that is a bit unsafe:

We compute the HYP VA using the kern_hyp_va helper, but that helper
is only designed to deal with kernel VAs coming from the linear map,
and not from the vmalloc region... This could in turn cause some bad
aliasing between the two, amplified by the upcoming VA randomisation.

A solution is to come up with our very own basic VA allocator for
MMIO. Since half of the HYP address space only contains a single
page (the idmap), we have plenty to borrow from. Let's use the idmap
as a base, and allocate downwards from it. GICv2 now lives on the
other side of the great VA barrier.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h |  3 ++
 virt/kvm/arm/mmu.c             | 73 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 62 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 4c5c8a386baf..b0b0cde77ca6 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -49,6 +49,9 @@
 #include <asm/pgalloc.h>
 #include <asm/stage2_pgtable.h>
 
+/* Ensure compatibility with arm64 */
+#define VA_BITS			32
+
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index f7fe724c14f4..d8ea68b78e9c 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -43,6 +43,8 @@ static unsigned long hyp_idmap_start;
 static unsigned long hyp_idmap_end;
 static phys_addr_t hyp_idmap_vector;
 
+static unsigned long io_map_base;
+
 #define S2_PGD_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
 #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
 
@@ -518,27 +520,35 @@ static void unmap_hyp_idmap_range(pgd_t *pgdp, phys_addr_t start, u64 size)
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
+	if (id_pgd) {
+		/* In case we never called hyp_mmu_init() */
+		if (!io_map_base)
+			io_map_base = hyp_idmap_start;
+		unmap_hyp_idmap_range(id_pgd, io_map_base,
+				      hyp_idmap_start + PAGE_SIZE - io_map_base);
+	}
+
 	if (boot_hyp_pgd) {
-		unmap_hyp_idmap_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
 		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
 		boot_hyp_pgd = NULL;
 	}
 
 	if (hyp_pgd) {
-		unmap_hyp_idmap_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
 		unmap_hyp_range(hyp_pgd, kern_hyp_va(PAGE_OFFSET),
 				(uintptr_t)high_memory - PAGE_OFFSET);
-		unmap_hyp_range(hyp_pgd, kern_hyp_va(VMALLOC_START),
-				VMALLOC_END - VMALLOC_START);
 
 		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
 		hyp_pgd = NULL;
@@ -735,8 +745,9 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
 			   void __iomem **haddr)
 {
-	unsigned long start, end;
-	int ret;
+	pgd_t *pgd = hyp_pgd;
+	unsigned long base;
+	int ret = 0;
 
 	*kaddr = ioremap(phys_addr, size);
 	if (!*kaddr)
@@ -747,19 +758,52 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 		return 0;
 	}
 
+	mutex_lock(&kvm_hyp_pgd_mutex);
 
-	start = kern_hyp_va((unsigned long)*kaddr);
-	end = kern_hyp_va((unsigned long)*kaddr + size);
-	ret = __create_hyp_mappings(hyp_pgd, PTRS_PER_PGD, start, end,
-				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
+	/*
+	 * This assumes that we we have enough space below the idmap
+	 * page to allocate our VAs. If not, the check below will
+	 * kick. A potential alternative would be to detect that
+	 * overflow and switch to an allocation above the idmap.
+	 *
+	 * The allocated size is always a multiple of PAGE_SIZE.
+	 */
+	size = PAGE_ALIGN(size + offset_in_page(phys_addr));
+	base = io_map_base - size;
 
+	/*
+	 * Verify that BIT(VA_BITS - 1) hasn't been flipped by
+	 * allocating the new area, as it would indicate we've
+	 * overflowed the idmap/IO address range.
+	 */
+	if ((base ^ io_map_base) & BIT(VA_BITS - 1))
+		ret = -ENOMEM;
+	else
+		io_map_base = base;
+
+	mutex_unlock(&kvm_hyp_pgd_mutex);
+
+	if (ret)
+		goto out;
+
+	if (__kvm_cpu_uses_extended_idmap())
+		pgd = boot_hyp_pgd;
+
+	ret = __create_hyp_mappings(pgd, __kvm_idmap_ptrs_per_pgd(),
+				    base, base + size,
+				    __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
+	if (ret)
+		goto out;
+
+	*haddr = (void __iomem *)base + offset_in_page(phys_addr);
+
+out:
 	if (ret) {
 		iounmap(*kaddr);
 		*kaddr = NULL;
 		return ret;
 	}
 
-	*haddr = (void __iomem *)start;
 	return 0;
 }
 
@@ -1892,6 +1936,7 @@ int kvm_mmu_init(void)
 			goto out;
 	}
 
+	io_map_base = hyp_idmap_start;
 	return 0;
 out:
 	free_hyp_pgds();
-- 
2.14.2
