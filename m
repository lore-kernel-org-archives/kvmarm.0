From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v6 08/26] KVM: arm/arm64: Move ioremap calls to
 create_hyp_io_mappings
Date: Wed, 14 Mar 2018 16:50:31 +0000
Message-ID: <20180314165049.30105-9-marc.zyngier@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFFB349FB3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Mar 2018 12:44:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EsbLtI1M81Zn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Mar 2018 12:43:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 250E949FAC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Mar 2018 12:43:48 -0400 (EDT)
In-Reply-To: <20180314165049.30105-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Both HYP io mappings call ioremap, followed by create_hyp_io_mappings.
Let's move the ioremap call into create_hyp_io_mappings itself, which
simplifies the code a bit and allows for further refactoring.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  3 ++-
 arch/arm64/include/asm/kvm_mmu.h |  3 ++-
 virt/kvm/arm/mmu.c               | 24 ++++++++++++++----------
 virt/kvm/arm/vgic/vgic-v2.c      | 31 ++++++++-----------------------
 4 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index a6808d2869f5..477c5ed426ef 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -50,7 +50,8 @@
 #include <asm/stage2_pgtable.h>
 
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
-int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
+int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
+			   void __iomem **kaddr);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7120bf3f22c7..5885564f9863 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -140,7 +140,8 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 #include <asm/stage2_pgtable.h>
 
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
-int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
+int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
+			   void __iomem **kaddr);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 711473cd1097..d58388d8550e 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -709,26 +709,30 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot)
 }
 
 /**
- * create_hyp_io_mappings - duplicate a kernel IO mapping into Hyp mode
- * @from:	The kernel start VA of the range
- * @to:		The kernel end VA of the range (exclusive)
+ * create_hyp_io_mappings - Map IO into both kernel and HYP
  * @phys_addr:	The physical start address which gets mapped
+ * @size:	Size of the region being mapped
+ * @kaddr:	Kernel VA for this mapping
  *
  * The resulting HYP VA is the same as the kernel VA, modulo
  * HYP_PAGE_OFFSET.
  */
-int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
+int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
+			   void __iomem **kaddr)
 {
-	unsigned long start = kern_hyp_va((unsigned long)from);
-	unsigned long end = kern_hyp_va((unsigned long)to);
+	unsigned long start, end;
 
-	if (is_kernel_in_hyp_mode())
+	*kaddr = ioremap(phys_addr, size);
+	if (!*kaddr)
+		return -ENOMEM;
+
+	if (is_kernel_in_hyp_mode()) {
 		return 0;
+	}
 
-	/* Check for a valid kernel IO mapping */
-	if (!is_vmalloc_addr(from) || !is_vmalloc_addr(to - 1))
-		return -EINVAL;
 
+	start = kern_hyp_va((unsigned long)*kaddr);
+	end = kern_hyp_va((unsigned long)*kaddr + size);
 	return __create_hyp_mappings(hyp_pgd, PTRS_PER_PGD, start, end,
 				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
 }
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index c32d7b93ffd1..21f963f9780e 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -361,16 +361,10 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 	if (!PAGE_ALIGNED(info->vcpu.start) ||
 	    !PAGE_ALIGNED(resource_size(&info->vcpu))) {
 		kvm_info("GICV region size/alignment is unsafe, using trapping (reduced performance)\n");
-		kvm_vgic_global_state.vcpu_base_va = ioremap(info->vcpu.start,
-							     resource_size(&info->vcpu));
-		if (!kvm_vgic_global_state.vcpu_base_va) {
-			kvm_err("Cannot ioremap GICV\n");
-			return -ENOMEM;
-		}
 
-		ret = create_hyp_io_mappings(kvm_vgic_global_state.vcpu_base_va,
-					     kvm_vgic_global_state.vcpu_base_va + resource_size(&info->vcpu),
-					     info->vcpu.start);
+		ret = create_hyp_io_mappings(info->vcpu.start,
+					     resource_size(&info->vcpu),
+					     &kvm_vgic_global_state.vcpu_base_va);
 		if (ret) {
 			kvm_err("Cannot map GICV into hyp\n");
 			goto out;
@@ -379,26 +373,17 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 		static_branch_enable(&vgic_v2_cpuif_trap);
 	}
 
-	kvm_vgic_global_state.vctrl_base = ioremap(info->vctrl.start,
-						   resource_size(&info->vctrl));
-	if (!kvm_vgic_global_state.vctrl_base) {
-		kvm_err("Cannot ioremap GICH\n");
-		ret = -ENOMEM;
+	ret = create_hyp_io_mappings(info->vctrl.start,
+				     resource_size(&info->vctrl),
+				     &kvm_vgic_global_state.vctrl_base);
+	if (ret) {
+		kvm_err("Cannot map VCTRL into hyp\n");
 		goto out;
 	}
 
 	vtr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VTR);
 	kvm_vgic_global_state.nr_lr = (vtr & 0x3f) + 1;
 
-	ret = create_hyp_io_mappings(kvm_vgic_global_state.vctrl_base,
-				     kvm_vgic_global_state.vctrl_base +
-					 resource_size(&info->vctrl),
-				     info->vctrl.start);
-	if (ret) {
-		kvm_err("Cannot map VCTRL into hyp\n");
-		goto out;
-	}
-
 	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
 	if (ret) {
 		kvm_err("Cannot register GICv2 KVM device\n");
-- 
2.14.2
