From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 62/85] KVM: arm/arm64: Keep GICv2 HYP VAs in
 kvm_vgic_global_state
Date: Wed, 28 Mar 2018 13:52:31 +0100
Message-ID: <20180328125254.31380-63-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91C214A051
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:58:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fe8P+cVmPF6h for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:57:40 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17EF14A0D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:49:13 -0400 (EDT)
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

As we're about to change the way we map devices at HYP, we need
to move away from kern_hyp_va on an IO address.

One way of achieving this is to store the VAs in kvm_vgic_global_state,
and use that directly from the HYP code. This requires a small change
to create_hyp_io_mappings so that it can also return a HYP VA.

We take this opportunity to nuke the vctrl_base field in the emulated
distributor, as it is not used anymore.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h           |  3 ++-
 arch/arm64/include/asm/kvm_mmu.h         |  3 ++-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 include/kvm/arm_vgic.h                   | 12 ++++++------
 virt/kvm/arm/mmu.c                       | 20 +++++++++++++++-----
 virt/kvm/arm/vgic/vgic-init.c            |  6 ------
 virt/kvm/arm/vgic/vgic-v2.c              | 26 ++++++++++++--------------
 7 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index bf17ad83d2f0..4c5c8a386baf 100644
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
index 8d5f9934d819..3836641dd6f0 100644
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
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 10eb2e96b3e6..86801b6055d6 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -60,7 +60,7 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return -1;
 
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
-	addr  = kern_hyp_va(hyp_symbol_addr(kvm_vgic_global_state)->vcpu_base_va);
+	addr  = hyp_symbol_addr(kvm_vgic_global_state)->vcpu_hyp_va;
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ac98ae46bfb7..87d2ad0a4292 100644
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
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 2bc32bdf932a..52b0ee31ebee 100644
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
index 3e8209a07585..68378fe17a0e 100644
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
index 66532f2f0e40..96e144f9d93d 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -363,7 +363,8 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 
 		ret = create_hyp_io_mappings(info->vcpu.start,
 					     resource_size(&info->vcpu),
-					     &kvm_vgic_global_state.vcpu_base_va);
+					     &kvm_vgic_global_state.vcpu_base_va,
+					     &kvm_vgic_global_state.vcpu_hyp_va);
 		if (ret) {
 			kvm_err("Cannot map GICV into hyp\n");
 			goto out;
@@ -374,7 +375,8 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 
 	ret = create_hyp_io_mappings(info->vctrl.start,
 				     resource_size(&info->vctrl),
-				     &kvm_vgic_global_state.vctrl_base);
+				     &kvm_vgic_global_state.vctrl_base,
+				     &kvm_vgic_global_state.vctrl_hyp);
 	if (ret) {
 		kvm_err("Cannot map VCTRL into hyp\n");
 		goto out;
@@ -429,9 +431,7 @@ static void save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 
 void vgic_v2_save_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = vcpu->kvm;
-	struct vgic_dist *vgic = &kvm->arch.vgic;
-	void __iomem *base = vgic->vctrl_base;
+	void __iomem *base = kvm_vgic_global_state.vctrl_base;
 	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 
 	if (!base)
@@ -445,10 +445,8 @@ void vgic_v2_save_state(struct kvm_vcpu *vcpu)
 
 void vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = vcpu->kvm;
-	struct vgic_dist *vgic = &kvm->arch.vgic;
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	void __iomem *base = vgic->vctrl_base;
+	void __iomem *base = kvm_vgic_global_state.vctrl_base;
 	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 	int i;
 
@@ -467,17 +465,17 @@ void vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 void vgic_v2_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
 
-	writel_relaxed(cpu_if->vgic_vmcr, vgic->vctrl_base + GICH_VMCR);
-	writel_relaxed(cpu_if->vgic_apr, vgic->vctrl_base + GICH_APR);
+	writel_relaxed(cpu_if->vgic_vmcr,
+		       kvm_vgic_global_state.vctrl_base + GICH_VMCR);
+	writel_relaxed(cpu_if->vgic_apr,
+		       kvm_vgic_global_state.vctrl_base + GICH_APR);
 }
 
 void vgic_v2_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
 
-	cpu_if->vgic_vmcr = readl_relaxed(vgic->vctrl_base + GICH_VMCR);
-	cpu_if->vgic_apr = readl_relaxed(vgic->vctrl_base + GICH_APR);
+	cpu_if->vgic_vmcr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VMCR);
+	cpu_if->vgic_apr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_APR);
 }
-- 
2.14.2
