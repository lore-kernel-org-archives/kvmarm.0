From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 13/19] KVM: arm/arm64: Keep GICv2 HYP VAs in
 kvm_vgic_global_state
Date: Mon, 18 Dec 2017 17:39:20 +0000
Message-ID: <20171218173926.16911-14-marc.zyngier@arm.com>
References: <20171218173926.16911-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C02C049D40
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 12:36:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u8EE2cxRqe0n for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Dec 2017 12:36:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FE1749D5E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 12:36:14 -0500 (EST)
In-Reply-To: <20171218173926.16911-1-marc.zyngier@arm.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

As we're about to change the way we map devices at HYP, we need
to move away from kern_hyp_va on an IO address.

One way of achieving this is to store the VAs in kvm_vgic_global_state,
and use that directly from the HYP code. This requires a small change
to create_hyp_io_mappings so that it can also return a HYP VA.

We take this opportunity to nuke the vctrl_base field in the emulated
distributor, as it is not used anymore.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  3 ++-
 arch/arm64/include/asm/kvm_mmu.h |  3 ++-
 include/kvm/arm_vgic.h           | 12 ++++++------
 virt/kvm/arm/hyp/vgic-v2-sr.c    | 10 +++-------
 virt/kvm/arm/mmu.c               | 20 ++++++++++++++++----
 virt/kvm/arm/vgic/vgic-init.c    |  6 ------
 virt/kvm/arm/vgic/vgic-v2.c      | 13 +++++++------
 7 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index cb3bef71ec9b..feff24b34506 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -42,7 +42,8 @@
 
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
-			   void __iomem **kaddr);
+			   void __iomem **kaddr,
+			   void __iomem **haddr);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 779a5d6eef19..85aaaca5bf4f 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -119,7 +119,8 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
-			   void __iomem **kaddr);
+			   void __iomem **kaddr,
+			   void __iomem **haddr);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8c896540a72c..8b3fbc03293b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -57,11 +57,15 @@ struct vgic_global {
 	/* Physical address of vgic virtual cpu interface */
 	phys_addr_t		vcpu_base;
 
-	/* GICV mapping */
+	/* GICV mapping, kernel VA */
 	void __iomem		*vcpu_base_va;
+	/* GICV mapping, HYP VA */
+	void __iomem		*vcpu_hyp_va;
 
-	/* virtual control interface mapping */
+	/* virtual control interface mapping, kernel VA */
 	void __iomem		*vctrl_base;
+	/* virtual control interface mapping, HYP VA */
+	void __iomem		*vctrl_hyp;
 
 	/* Number of implemented list registers */
 	int			nr_lr;
@@ -198,10 +202,6 @@ struct vgic_dist {
 
 	int			nr_spis;
 
-	/* TODO: Consider moving to global state */
-	/* Virtual control interface mapping */
-	void __iomem		*vctrl_base;
-
 	/* base addresses in guest physical address space: */
 	gpa_t			vgic_dist_base;		/* distributor */
 	union {
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index 19f63fbf3682..a3b224e09f74 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -60,10 +60,8 @@ static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 /* vcpu is already in the HYP VA space */
 void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	struct vgic_dist *vgic = &kvm->arch.vgic;
-	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
+	void __iomem *base = hyp_symbol_addr(kvm_vgic_global_state)->vctrl_hyp;
 	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 
 	if (!base)
@@ -85,10 +83,8 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 /* vcpu is already in the HYP VA space */
 void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	struct vgic_dist *vgic = &kvm->arch.vgic;
-	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
+	void __iomem *base = hyp_symbol_addr(kvm_vgic_global_state)->vctrl_hyp;
 	int i;
 	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 
@@ -143,7 +139,7 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return -1;
 
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
-	addr  = kern_hyp_va(hyp_symbol_addr(kvm_vgic_global_state)->vcpu_base_va);
+	addr  = hyp_symbol_addr(kvm_vgic_global_state)->vcpu_hyp_va;
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 38adbe0a016c..6192d45d1e1a 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -713,28 +713,40 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot)
  * @phys_addr:	The physical start address which gets mapped
  * @size:	Size of the region being mapped
  * @kaddr:	Kernel VA for this mapping
+ * @haddr:	HYP VA for this mapping
  *
- * The resulting HYP VA is the same as the kernel VA, modulo
- * HYP_PAGE_OFFSET.
+ * The resulting HYP VA is completely unrelated to the kernel VA.
  */
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
-			   void __iomem **kaddr)
+			   void __iomem **kaddr,
+			   void __iomem **haddr)
 {
 	unsigned long start, end;
+	int ret;
 
 	*kaddr = ioremap(phys_addr, size);
 	if (!*kaddr)
 		return -ENOMEM;
 
 	if (is_kernel_in_hyp_mode()) {
+		*haddr = *kaddr;
 		return 0;
 	}
 
 
 	start = kern_hyp_va((unsigned long)*kaddr);
 	end = kern_hyp_va((unsigned long)*kaddr + size);
-	return __create_hyp_mappings(hyp_pgd, start, end,
+	ret = __create_hyp_mappings(hyp_pgd, start, end,
 				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
+
+	if (ret) {
+		iounmap(*kaddr);
+		*kaddr = NULL;
+	} else {
+		*haddr = (void __iomem *)start;
+	}
+
+	return ret;
 }
 
 /**
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 62310122ee78..3f01b5975055 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -166,12 +166,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
 
-	/*
-	 * kvm_vgic_global_state.vctrl_base is set on vgic probe (kvm_arch_init)
-	 * it is stored in distributor struct for asm save/restore purpose
-	 */
-	kvm->arch.vgic.vctrl_base = kvm_vgic_global_state.vctrl_base;
-
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
 	kvm->arch.vgic.vgic_redist_base = VGIC_ADDR_UNDEF;
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index bc49d702f9f0..f0f566e4494e 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -335,7 +335,8 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 
 		ret = create_hyp_io_mappings(info->vcpu.start,
 					     resource_size(&info->vcpu),
-					     &kvm_vgic_global_state.vcpu_base_va);
+					     &kvm_vgic_global_state.vcpu_base_va,
+					     &kvm_vgic_global_state.vcpu_hyp_va);
 		if (ret) {
 			kvm_err("Cannot map GICV into hyp\n");
 			goto out;
@@ -346,7 +347,8 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 
 	ret = create_hyp_io_mappings(info->vctrl.start,
 				     resource_size(&info->vctrl),
-				     &kvm_vgic_global_state.vctrl_base);
+				     &kvm_vgic_global_state.vctrl_base,
+				     &kvm_vgic_global_state.vctrl_hyp);
 	if (ret) {
 		kvm_err("Cannot map VCTRL into hyp\n");
 		goto out;
@@ -381,15 +383,14 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 void vgic_v2_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
 
-	writel_relaxed(cpu_if->vgic_vmcr, vgic->vctrl_base + GICH_VMCR);
+	writel_relaxed(cpu_if->vgic_vmcr,
+		       kvm_vgic_global_state.vctrl_base + GICH_VMCR);
 }
 
 void vgic_v2_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
 
-	cpu_if->vgic_vmcr = readl_relaxed(vgic->vctrl_base + GICH_VMCR);
+	cpu_if->vgic_vmcr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VMCR);
 }
-- 
2.14.2
