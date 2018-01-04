From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 12/19] KVM: arm/arm64: Move ioremap calls to create_hyp_io_mappings
Date: Thu,  4 Jan 2018 18:43:27 +0000
Message-ID: <20180104184334.16571-13-marc.zyngier@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180104184334.16571-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Both HYP io mappings call ioremap, followed by create_hyp_io_mappings.
Let's move the ioremap call into create_hyp_io_mappings itself, which
simplifies the code a bit and allows for further refactoring.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  3 ++-
 arch/arm64/include/asm/kvm_mmu.h |  3 ++-
 virt/kvm/arm/mmu.c               | 24 ++++++++++++++----------
 virt/kvm/arm/vgic/vgic-v2.c      | 31 ++++++++-----------------------
 4 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index fa6f2174276b..cb3bef71ec9b 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -41,7 +41,8 @@
 #include <asm/stage2_pgtable.h>
 
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
-int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
+int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
+			   void __iomem **kaddr);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index b0c3cbe9b513..09a208014457 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -119,7 +119,8 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 #include <asm/stage2_pgtable.h>
 
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
-int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
+int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
+			   void __iomem **kaddr);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 84d09f1a44d4..38adbe0a016c 100644
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
 	return __create_hyp_mappings(hyp_pgd, start, end,
 				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
 }
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 80897102da26..bc49d702f9f0 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -332,16 +332,10 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
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
@@ -350,26 +344,17 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
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
