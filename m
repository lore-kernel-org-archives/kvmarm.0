From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 05/31] KVM: arm/arm64: Support mmu for the virtual EL2 execution
Date: Mon,  2 Oct 2017 22:10:47 -0500
Message-ID: <1507000273-3735-3-git-send-email-jintack.lim@linaro.org>
References: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1507000273-3735-1-git-send-email-jintack.lim@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: jintack@cs.columbia.edu, pbonzini@redhat.com, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Jintack Lim <jintack.lim@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

When running a guest hypervisor in virtual EL2, the translation context
has to be separate from the rest of the system, including the guest
EL1/0 translation regime, so we allocate a separate VMID for this mode.

Considering that we have two different vttbr values due to separate
VMIDs, it's racy to keep a vttbr value in a struct (kvm_s2_mmu) and
share it between multiple vcpus. So, remove the shared vttbr field, and
set up per-vcpu hw_vttbr field.

Hypercalls to flush tlb now have vttbr as a parameter instead of mmu,
since mmu structure does not have vttbr any more.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---

Notes:
    v1-->v2:
    Fixed a bug that hw_vttbr was not initialized correctly in kvm_arch_vcpu_init()
    where vmid is not allocated yet. This prevented the guest from booting on 32bit
    arm; hw_vttbr is set on each entry on aarch64, so it was fine.

 arch/arm/include/asm/kvm_asm.h       |  6 ++--
 arch/arm/include/asm/kvm_emulate.h   |  4 +++
 arch/arm/include/asm/kvm_host.h      | 14 +++++---
 arch/arm/include/asm/kvm_mmu.h       | 11 ++++++
 arch/arm/kvm/hyp/switch.c            |  4 +--
 arch/arm/kvm/hyp/tlb.c               | 15 ++++-----
 arch/arm64/include/asm/kvm_asm.h     |  6 ++--
 arch/arm64/include/asm/kvm_emulate.h |  8 +++++
 arch/arm64/include/asm/kvm_host.h    | 14 +++++---
 arch/arm64/include/asm/kvm_mmu.h     | 11 ++++++
 arch/arm64/kvm/hyp/switch.c          |  4 +--
 arch/arm64/kvm/hyp/tlb.c             | 34 +++++++++----------
 virt/kvm/arm/arm.c                   | 65 +++++++++++++++++++++---------------
 virt/kvm/arm/mmu.c                   |  9 +++--
 14 files changed, 128 insertions(+), 77 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 71b7255..23a79bd 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -65,9 +65,9 @@
 extern char __kvm_hyp_vector[];
 
 extern void __kvm_flush_vm_context(void);
-extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa);
-extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu);
+extern void __kvm_tlb_flush_vmid_ipa(u64 vttbr, phys_addr_t ipa);
+extern void __kvm_tlb_flush_vmid(u64 vttbr);
+extern void __kvm_tlb_flush_local_vmid(u64 vttbr);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 29a4dec..24a3fbf 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -293,4 +293,8 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	}
 }
 
+static inline struct kvm_s2_vmid *vcpu_get_active_vmid(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->kvm->arch.mmu.vmid;
+}
 #endif /* __ARM_KVM_EMULATE_H__ */
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 78d826e..33ccdbe 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -53,16 +53,18 @@
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 void kvm_reset_coprocs(struct kvm_vcpu *vcpu);
 
-struct kvm_s2_mmu {
+struct kvm_s2_vmid {
 	/* The VMID generation used for the virt. memory system */
 	u64    vmid_gen;
 	u32    vmid;
+};
+
+struct kvm_s2_mmu {
+	struct kvm_s2_vmid vmid;
+	struct kvm_s2_vmid el2_vmid;
 
 	/* Stage-2 page table */
 	pgd_t *pgd;
-
-	/* VTTBR value associated with above pgd and vmid */
-	u64    vttbr;
 };
 
 struct kvm_arch {
@@ -193,6 +195,9 @@ struct kvm_vcpu_arch {
 
 	/* Stage 2 paging state used by the hardware on next switch */
 	struct kvm_s2_mmu *hw_mmu;
+
+	/* VTTBR value used by the hardware on next switch */
+	u64 hw_vttbr;
 };
 
 struct kvm_vm_stat {
@@ -239,6 +244,7 @@ static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 {
 }
 
+unsigned int get_kvm_vmid_bits(void);
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
 struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index fa6f217..86fdc70 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -221,6 +221,17 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return 8;
 }
 
+static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
+				struct kvm_s2_mmu *mmu)
+{
+	u64 vmid_field, baddr;
+
+	baddr = virt_to_phys(mmu->pgd);
+	vmid_field = ((u64)vmid->vmid << VTTBR_VMID_SHIFT) &
+		VTTBR_VMID_MASK(get_kvm_vmid_bits());
+	return baddr | vmid_field;
+}
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* __ARM_KVM_MMU_H__ */
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 4814671..4798e39 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -75,9 +75,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
 {
-	struct kvm_s2_mmu *mmu = kern_hyp_va(vcpu->arch.hw_mmu);
-
-	write_sysreg(mmu->vttbr, VTTBR);
+	write_sysreg(vcpu->arch.hw_vttbr, VTTBR);
 	write_sysreg(vcpu->arch.midr, VPIDR);
 }
 
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
index 56f0a49..562ad0b 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -34,13 +34,12 @@
  * As v7 does not support flushing per IPA, just nuke the whole TLB
  * instead, ignoring the ipa value.
  */
-void __hyp_text __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
+void __hyp_text __kvm_tlb_flush_vmid(u64 vttbr)
 {
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
-	write_sysreg(mmu->vttbr, VTTBR);
+	write_sysreg(vttbr, VTTBR);
 	isb();
 
 	write_sysreg(0, TLBIALLIS);
@@ -50,17 +49,15 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	write_sysreg(0, VTTBR);
 }
 
-void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
-					 phys_addr_t ipa)
+void __hyp_text __kvm_tlb_flush_vmid_ipa(u64 vttbr, phys_addr_t ipa)
 {
-	__kvm_tlb_flush_vmid(mmu);
+	__kvm_tlb_flush_vmid(vttbr);
 }
 
-void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
+void __hyp_text __kvm_tlb_flush_local_vmid(u64 vttbr)
 {
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
-	write_sysreg(mmu->vttbr, VTTBR);
+	write_sysreg(vttbr, VTTBR);
 	isb();
 
 	write_sysreg(0, TLBIALL);
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ff6244f..e492749 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -52,9 +52,9 @@
 extern char __kvm_hyp_vector[];
 
 extern void __kvm_flush_vm_context(void);
-extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa);
-extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu);
+extern void __kvm_tlb_flush_vmid_ipa(u64 vttbr, phys_addr_t ipa);
+extern void __kvm_tlb_flush_vmid(u64 vttbr);
+extern void __kvm_tlb_flush_local_vmid(u64 vttbr);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 4776bfc..71a3a04 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -385,4 +385,12 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	return data;		/* Leave LE untouched */
 }
 
+static inline struct kvm_s2_vmid *vcpu_get_active_vmid(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(is_hyp_ctxt(vcpu)))
+		return &vcpu->kvm->arch.mmu.el2_vmid;
+
+	return &vcpu->kvm->arch.mmu.vmid;
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e7e9f70..a7edf0e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -50,17 +50,19 @@
 int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
 void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
 
-struct kvm_s2_mmu {
+struct kvm_s2_vmid {
 	/* The VMID generation used for the virt. memory system */
 	u64    vmid_gen;
 	u32    vmid;
+};
+
+struct kvm_s2_mmu {
+	struct kvm_s2_vmid vmid;
+	struct kvm_s2_vmid el2_vmid;
 
 	/* 1-level 2nd stage table and lock */
 	spinlock_t pgd_lock;
 	pgd_t *pgd;
-
-	/* VTTBR value associated with above pgd and vmid */
-	u64    vttbr;
 };
 
 struct kvm_arch {
@@ -337,6 +339,9 @@ struct kvm_vcpu_arch {
 
 	/* Stage 2 paging state used by the hardware on next switch */
 	struct kvm_s2_mmu *hw_mmu;
+
+	/* VTTBR value used by the hardware on next switch */
+	u64 hw_vttbr;
 };
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
@@ -394,6 +399,7 @@ static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 {
 }
 
+unsigned int get_kvm_vmid_bits(void);
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index a89cc22..21c0299 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -312,5 +312,16 @@ static inline unsigned int kvm_get_vmid_bits(void)
 	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
 }
 
+static inline u64 kvm_get_vttbr(struct kvm_s2_vmid *vmid,
+				struct kvm_s2_mmu *mmu)
+{
+	u64 vmid_field, baddr;
+
+	baddr = virt_to_phys(mmu->pgd);
+	vmid_field = ((u64)vmid->vmid << VTTBR_VMID_SHIFT) &
+		VTTBR_VMID_MASK(get_kvm_vmid_bits());
+	return baddr | vmid_field;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8b1b3e9..3626e76 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -181,9 +181,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
 {
-	struct kvm_s2_mmu *mmu = kern_hyp_va(vcpu->arch.hw_mmu);
-
-	write_sysreg(mmu->vttbr, vttbr_el2);
+	write_sysreg(vcpu->arch.hw_vttbr, vttbr_el2);
 }
 
 static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 0897678..680b960 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -18,7 +18,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/tlbflush.h>
 
-static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm_s2_mmu *mmu)
+static void __hyp_text __tlb_switch_to_guest_vhe(u64 vttbr)
 {
 	u64 val;
 
@@ -29,16 +29,16 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm_s2_mmu *mmu)
 	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
 	 * let's flip TGE before executing the TLB operation.
 	 */
-	write_sysreg(mmu->vttbr, vttbr_el2);
+	write_sysreg(vttbr, vttbr_el2);
 	val = read_sysreg(hcr_el2);
 	val &= ~HCR_TGE;
 	write_sysreg(val, hcr_el2);
 	isb();
 }
 
-static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm_s2_mmu *mmu)
+static void __hyp_text __tlb_switch_to_guest_nvhe(u64 vttbr)
 {
-	write_sysreg(mmu->vttbr, vttbr_el2);
+	write_sysreg(vttbr, vttbr_el2);
 	isb();
 }
 
@@ -47,7 +47,7 @@ static hyp_alternate_select(__tlb_switch_to_guest,
 			    __tlb_switch_to_guest_vhe,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
-static void __hyp_text __tlb_switch_to_host_vhe(struct kvm_s2_mmu *mmu)
+static void __hyp_text __tlb_switch_to_host_vhe(void)
 {
 	/*
 	 * We're done with the TLB operation, let's restore the host's
@@ -57,7 +57,7 @@ static void __hyp_text __tlb_switch_to_host_vhe(struct kvm_s2_mmu *mmu)
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 }
 
-static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm_s2_mmu *mmu)
+static void __hyp_text __tlb_switch_to_host_nvhe(void)
 {
 	write_sysreg(0, vttbr_el2);
 }
@@ -67,14 +67,12 @@ static hyp_alternate_select(__tlb_switch_to_host,
 			    __tlb_switch_to_host_vhe,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
-void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
-					 phys_addr_t ipa)
+void __hyp_text __kvm_tlb_flush_vmid_ipa(u64 vttbr, phys_addr_t ipa)
 {
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
-	__tlb_switch_to_guest()(mmu);
+	__tlb_switch_to_guest()(vttbr);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -117,35 +115,33 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	if (!has_vhe() && icache_is_vpipt())
 		__flush_icache_all();
 
-	__tlb_switch_to_host()(mmu);
+	__tlb_switch_to_host()();
 }
 
-void __hyp_text __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
+void __hyp_text __kvm_tlb_flush_vmid(u64 vttbr)
 {
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
-	__tlb_switch_to_guest()(mmu);
+	__tlb_switch_to_guest()(vttbr);
 
 	__tlbi(vmalls12e1is);
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host()(mmu);
+	__tlb_switch_to_host()();
 }
 
-void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
+void __hyp_text __kvm_tlb_flush_local_vmid(u64 vttbr)
 {
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
-	__tlb_switch_to_guest()(mmu);
+	__tlb_switch_to_guest()(vttbr);
 
 	__tlbi(vmalle1);
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host()(mmu);
+	__tlb_switch_to_host()();
 }
 
 void __hyp_text __kvm_flush_vm_context(void)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index bee27bb..41e0654 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -75,6 +75,11 @@ static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
 	__this_cpu_write(kvm_arm_running_vcpu, vcpu);
 }
 
+unsigned int get_kvm_vmid_bits(void)
+{
+	return kvm_vmid_bits;
+}
+
 /**
  * kvm_arm_get_running_vcpu - get the vcpu running on the current CPU.
  * Must be called from non-preemptible context
@@ -138,7 +143,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_vgic_early_init(kvm);
 
 	/* Mark the initial VMID generation invalid */
-	kvm->arch.mmu.vmid_gen = 0;
+	kvm->arch.mmu.vmid.vmid_gen = 0;
+	kvm->arch.mmu.el2_vmid.vmid_gen = 0;
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = vgic_present ?
@@ -325,6 +331,8 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
+	struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
@@ -334,7 +342,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	kvm_arm_reset_debug_ptr(vcpu);
 
-	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+	vcpu->arch.hw_mmu = mmu;
 
 	return kvm_vgic_vcpu_init(vcpu);
 }
@@ -350,7 +358,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 * over-invalidation doesn't affect correctness.
 	 */
 	if (*last_ran != vcpu->vcpu_id) {
-		kvm_call_hyp(__kvm_tlb_flush_local_vmid, &vcpu->kvm->arch.mmu);
+		struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+		u64 vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
+
+		kvm_call_hyp(__kvm_tlb_flush_local_vmid, vttbr);
 		*last_ran = vcpu->vcpu_id;
 	}
 
@@ -434,36 +445,38 @@ void force_vm_exit(const cpumask_t *mask)
 
 /**
  * need_new_vmid_gen - check that the VMID is still valid
- * @kvm: The VM's VMID to check
+ * @vmid: The VMID to check
  *
  * return true if there is a new generation of VMIDs being used
  *
- * The hardware supports only 256 values with the value zero reserved for the
- * host, so we check if an assigned value belongs to a previous generation,
- * which which requires us to assign a new value. If we're the first to use a
- * VMID for the new generation, we must flush necessary caches and TLBs on all
- * CPUs.
+ * The hardware supports a limited set of values with the value zero reserved
+ * for the host, so we check if an assigned value belongs to a previous
+ * generation, which which requires us to assign a new value. If we're the
+ * first to use a VMID for the new generation, we must flush necessary caches
+ * and TLBs on all CPUs.
  */
-static bool need_new_vmid_gen(struct kvm_s2_mmu *mmu)
+static bool need_new_vmid_gen(struct kvm_s2_vmid *vmid)
 {
-	return unlikely(mmu->vmid_gen != atomic64_read(&kvm_vmid_gen));
+	return unlikely(vmid->vmid_gen != atomic64_read(&kvm_vmid_gen));
 }
 
 /**
  * update_vttbr - Update the VTTBR with a valid VMID before the guest runs
  * @kvm: The guest that we are about to run
- * @mmu: The stage-2 translation context to update
+ * @vmid: The stage-2 VMID information struct
  *
  * Called from kvm_arch_vcpu_ioctl_run before entering the guest to ensure the
  * VM has a valid VMID, otherwise assigns a new one and flushes corresponding
  * caches and TLBs.
  */
-static void update_vttbr(struct kvm *kvm, struct kvm_s2_mmu *mmu)
+static void update_vttbr(struct kvm *kvm, struct kvm_s2_vmid *vmid)
 {
-	phys_addr_t pgd_phys;
-	u64 vmid;
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+	struct kvm_vcpu *vcpu;
+	int i = 0;
+	u64 new_vttbr;
 
-	if (!need_new_vmid_gen(mmu))
+	if (!need_new_vmid_gen(vmid))
 		return;
 
 	spin_lock(&kvm_vmid_lock);
@@ -473,7 +486,7 @@ static void update_vttbr(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	 * already allocated a valid vmid for this vm, then this vcpu should
 	 * use the same vmid.
 	 */
-	if (!need_new_vmid_gen(mmu)) {
+	if (!need_new_vmid_gen(vmid)) {
 		spin_unlock(&kvm_vmid_lock);
 		return;
 	}
@@ -497,17 +510,15 @@ static void update_vttbr(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 		kvm_call_hyp(__kvm_flush_vm_context);
 	}
 
-	mmu->vmid_gen = atomic64_read(&kvm_vmid_gen);
-	mmu->vmid = kvm_next_vmid;
+	vmid->vmid_gen = atomic64_read(&kvm_vmid_gen);
+	vmid->vmid = kvm_next_vmid;
 	kvm_next_vmid++;
 	kvm_next_vmid &= (1 << kvm_vmid_bits) - 1;
 
-	/* update vttbr to be used with the new vmid */
-	pgd_phys = virt_to_phys(mmu->pgd);
-	BUG_ON(pgd_phys & ~VTTBR_BADDR_MASK);
-	vmid = ((u64)(mmu->vmid) << VTTBR_VMID_SHIFT) &
-	       VTTBR_VMID_MASK(kvm_vmid_bits);
-	mmu->vttbr = pgd_phys | vmid;
+	new_vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		vcpu->arch.hw_vttbr = new_vttbr;
+	}
 
 	spin_unlock(&kvm_vmid_lock);
 }
@@ -642,7 +653,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		cond_resched();
 
-		update_vttbr(vcpu->kvm, vcpu->arch.hw_mmu);
+		update_vttbr(vcpu->kvm, vcpu_get_active_vmid(vcpu));
 
 		check_vcpu_requests(vcpu);
 
@@ -681,7 +692,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
-		if (ret <= 0 || need_new_vmid_gen(vcpu->arch.hw_mmu) ||
+		if (ret <= 0 || need_new_vmid_gen(vcpu_get_active_vmid(vcpu)) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index d8ea1f9..0edcf23 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -61,12 +61,17 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
  */
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
-	kvm_call_hyp(__kvm_tlb_flush_vmid, kvm);
+	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+	u64 vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
+
+	kvm_call_hyp(__kvm_tlb_flush_vmid, vttbr);
 }
 
 static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
 {
-	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa);
+	u64 vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
+
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, vttbr, ipa);
 }
 
 /*
-- 
1.9.1
