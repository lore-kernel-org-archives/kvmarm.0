From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 09/23] KVM: arm/arm64: Keep GICv2 HYP VAs in
 kvm_vgic_global_state
Date: Thu,  1 Mar 2018 15:55:24 +0000
Message-ID: <20180301155538.26860-10-marc.zyngier@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2FDD49F8E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:49:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uqHpSZTT0TtU for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Mar 2018 10:49:12 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B9D349E19
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:49:05 -0500 (EST)
In-Reply-To: <20180301155538.26860-1-marc.zyngier@arm.com>
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

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   |  3 ++-
 arch/arm64/include/asm/kvm_mmu.h |  3 ++-
 include/kvm/arm_vgic.h           | 12 ++++++------
 virt/kvm/arm/hyp/vgic-v2-sr.c    | 10 +++-------
 virt/kvm/arm/mmu.c               | 20 +++++++++++++++-----
 virt/kvm/arm/vgic/vgic-init.c    |  6 ------
 virt/kvm/arm/vgic/vgic-v2.c      | 13 +++++++------
 7 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 477c5ed426ef..5b12a3d2755e 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -51,7 +51,8 @@
 
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
-			   void __iomem **kaddr);
+			   void __iomem **kaddr,
+			   void __iomem **haddr);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 5885564f9863..c4934470403b 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -141,7 +141,8 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 
 int create_hyp_mappings(void *from, void *to, pgprot_t prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
-			   void __iomem **kaddr);
+			   void __iomem **kaddr,
+			   void __iomem **haddr);
 void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index cdbd142ca7f2..b3fcb6cd62f7 100644
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
@@ -209,10 +213,6 @@ struct vgic_dist {
 
 	int			nr_spis;
 
-	/* TODO: Consider moving to global state */
-	/* Virtual control interface mapping */
-	void __iomem		*vctrl_base;
-
 	/* base addresses in guest physical address space: */
 	gpa_t			vgic_dist_base;		/* distributor */
 	union {
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index a6ca049d9651..7a14b3bf6f5e 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -57,10 +57,8 @@ static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
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
@@ -82,10 +80,8 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
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
 
@@ -140,7 +136,7 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return -1;
 
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
-	addr  = kern_hyp_va(hyp_symbol_addr(kvm_vgic_global_state)->vcpu_base_va);
+	addr  = hyp_symbol_addr(kvm_vgic_global_state)->vcpu_hyp_va;
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index d58388d8550e..0e5cfffb4c21 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -713,28 +713,38 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot)
  * @phys_addr:	The physical start address which gets mapped
  * @size:	Size of the region being mapped
  * @kaddr:	Kernel VA for this mapping
- *
- * The resulting HYP VA is the same as the kernel VA, modulo
- * HYP_PAGE_OFFSET.
+ * @haddr:	HYP VA for this mapping
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
-	return __create_hyp_mappings(hyp_pgd, PTRS_PER_PGD, start, end,
+	ret = __create_hyp_mappings(hyp_pgd, PTRS_PER_PGD, start, end,
 				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
+
+	if (ret) {
+		iounmap(*kaddr);
+		*kaddr = NULL;
+		return ret;
+	}
+
+	*haddr = (void __iomem *)start;
+	return 0;
 }
 
 /**
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 743ca5cb05ef..b673a6c72ef8 100644
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
index 21f963f9780e..38406825e663 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -364,7 +364,8 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 
 		ret = create_hyp_io_mappings(info->vcpu.start,
 					     resource_size(&info->vcpu),
-					     &kvm_vgic_global_state.vcpu_base_va);
+					     &kvm_vgic_global_state.vcpu_base_va,
+					     &kvm_vgic_global_state.vcpu_hyp_va);
 		if (ret) {
 			kvm_err("Cannot map GICV into hyp\n");
 			goto out;
@@ -375,7 +376,8 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 
 	ret = create_hyp_io_mappings(info->vctrl.start,
 				     resource_size(&info->vctrl),
-				     &kvm_vgic_global_state.vctrl_base);
+				     &kvm_vgic_global_state.vctrl_base,
+				     &kvm_vgic_global_state.vctrl_hyp);
 	if (ret) {
 		kvm_err("Cannot map VCTRL into hyp\n");
 		goto out;
@@ -410,15 +412,14 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
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
