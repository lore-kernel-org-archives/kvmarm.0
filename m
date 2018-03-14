From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v6 23/26] arm/arm64: KVM: Introduce EL2-specific executable
 mappings
Date: Wed, 14 Mar 2018 16:50:46 +0000
Message-ID: <20180314165049.30105-24-marc.zyngier@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180314165049.30105-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@kernel.org>, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Until now, all EL2 executable mappings were derived from their
EL1 VA. Since we want to decouple the vectors mapping from
the rest of the hypervisor, we need to be able to map some
text somewhere else.

The "idmap" region (for lack of a better name) is ideally suited
for this, as we have a huge range that hardly has anything in it.

Let's extend the IO allocator to also deal with executable mappings,
thus providing the required feature.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  2 +
 arch/arm64/include/asm/kvm_mmu.h |  2 +
 virt/kvm/arm/mmu.c               | 80 +++++++++++++++++++++++++++++-----------
 3 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 26eb6b1cec9b..1b7f592eae57 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -56,6 +56,8 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
 			   void __iomem **haddr);
+int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
+			     void **haddr);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index c2beb2d25170..97af11065bbd 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -151,6 +151,8 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
 			   void __iomem **haddr);
+int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
+			     void **haddr);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b4d1948c8dd6..554ad5493e7d 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -737,30 +737,13 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot)
 	return 0;
 }
 
-/**
- * create_hyp_io_mappings - Map IO into both kernel and HYP
- * @phys_addr:	The physical start address which gets mapped
- * @size:	Size of the region being mapped
- * @kaddr:	Kernel VA for this mapping
- * @haddr:	HYP VA for this mapping
- */
-int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
-			   void __iomem **kaddr,
-			   void __iomem **haddr)
+static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
+					unsigned long *haddr, pgprot_t prot)
 {
 	pgd_t *pgd = hyp_pgd;
 	unsigned long base;
 	int ret;
 
-	*kaddr = ioremap(phys_addr, size);
-	if (!*kaddr)
-		return -ENOMEM;
-
-	if (is_kernel_in_hyp_mode()) {
-		*haddr = *kaddr;
-		return 0;
-	}
-
 	mutex_lock(&io_map_lock);
 
 	/*
@@ -789,22 +772,77 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 
 	ret = __create_hyp_mappings(pgd, __kvm_idmap_ptrs_per_pgd(),
 				    base, base + size,
-				    __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
+				    __phys_to_pfn(phys_addr), prot);
 	if (ret)
 		goto out;
 
-	*haddr = (void __iomem *)base + offset_in_page(phys_addr);
+	*haddr = base + offset_in_page(phys_addr);
 	io_map_base = base;
 
 out:
 	mutex_unlock(&io_map_lock);
 
+	return ret;
+}
+
+/**
+ * create_hyp_io_mappings - Map IO into both kernel and HYP
+ * @phys_addr:	The physical start address which gets mapped
+ * @size:	Size of the region being mapped
+ * @kaddr:	Kernel VA for this mapping
+ * @haddr:	HYP VA for this mapping
+ */
+int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
+			   void __iomem **kaddr,
+			   void __iomem **haddr)
+{
+	unsigned long addr;
+	int ret;
+
+	*kaddr = ioremap(phys_addr, size);
+	if (!*kaddr)
+		return -ENOMEM;
+
+	if (is_kernel_in_hyp_mode()) {
+		*haddr = *kaddr;
+		return 0;
+	}
+
+	ret = __create_hyp_private_mapping(phys_addr, size,
+					   &addr, PAGE_HYP_DEVICE);
 	if (ret) {
 		iounmap(*kaddr);
 		*kaddr = NULL;
+		*haddr = NULL;
+		return ret;
+	}
+
+	*haddr = (void __iomem *)addr;
+	return 0;
+}
+
+/**
+ * create_hyp_exec_mappings - Map an executable range into into HYP
+ * @phys_addr:	The physical start address which gets mapped
+ * @size:	Size of the region being mapped
+ * @haddr:	HYP VA for this mapping
+ */
+int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
+			     void **haddr)
+{
+	unsigned long addr;
+	int ret;
+
+	BUG_ON(is_kernel_in_hyp_mode());
+
+	ret = __create_hyp_private_mapping(phys_addr, size,
+					   &addr, PAGE_HYP_EXEC);
+	if (ret) {
+		*haddr = NULL;
 		return ret;
 	}
 
+	*haddr = (void *)addr;
 	return 0;
 }
 
-- 
2.14.2
