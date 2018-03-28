From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 76/85] arm/arm64: KVM: Introduce EL2-specific executable
 mappings
Date: Wed, 28 Mar 2018 13:52:45 +0100
Message-ID: <20180328125254.31380-77-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 378AF40357
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 09:01:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wd8fHKyyfKes for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 09:00:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E59E54A0AD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:50:09 -0400 (EDT)
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

Until now, all EL2 executable mappings were derived from their
EL1 VA. Since we want to decouple the vectors mapping from
the rest of the hypervisor, we need to be able to map some
text somewhere else.

The "idmap" region (for lack of a better name) is ideally suited
for this, as we have a huge range that hardly has anything in it.

Let's extend the IO allocator to also deal with executable mappings,
thus providing the required feature.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  2 +
 arch/arm64/include/asm/kvm_mmu.h |  2 +
 virt/kvm/arm/mmu.c               | 80 +++++++++++++++++++++++++++++-----------
 3 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index b0b0cde77ca6..707a1f06dc5d 100644
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
index 65dc225d019c..eb04437d50fa 100644
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
index 394f41a65732..7f6a944db23d 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -734,30 +734,13 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot)
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
 	int ret = 0;
 
-	*kaddr = ioremap(phys_addr, size);
-	if (!*kaddr)
-		return -ENOMEM;
-
-	if (is_kernel_in_hyp_mode()) {
-		*haddr = *kaddr;
-		return 0;
-	}
-
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
 	/*
@@ -791,19 +774,74 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 
 	ret = __create_hyp_mappings(pgd, __kvm_idmap_ptrs_per_pgd(),
 				    base, base + size,
-				    __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
+				    __phys_to_pfn(phys_addr), prot);
 	if (ret)
 		goto out;
 
-	*haddr = (void __iomem *)base + offset_in_page(phys_addr);
+	*haddr = base + offset_in_page(phys_addr);
 
 out:
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
+ * create_hyp_exec_mappings - Map an executable range into HYP
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
