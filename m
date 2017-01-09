From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 35/55] KVM: arm/arm64: Support mmu for the virtual EL2 execution
Date: Mon,  9 Jan 2017 01:24:31 -0500
Message-ID: <1483943091-1364-36-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A66E640625
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3bJkUH7NiwEy for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:37 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F62C4019A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:36 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q5Ji017983
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:18 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 1136E7E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:18 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id EC7CB80
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:17 -0500 (EST)
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com
 [209.85.216.197])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QH2K057514
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:17 -0500
Received: by mail-qt0-f197.google.com with SMTP id t56so77866992qte.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:17 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

When running a guest hypervisor in virtual EL2, the translation context
has to be separate from the rest of the system, including the guest
EL1/0 translation regime, so we allocate a separate VMID for this mode.

Considering that we have two different vttbr values due to separate
VMIDs, it's racy to keep a vttbr value in a struct (kvm_s2_mmu) and
share it between multiple vcpus. So, keep the vttbr value per vcpu.

Hypercalls to flush tlb now have vttbr as a parameter instead of mmu,
since mmu structure does not have vttbr any more.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_asm.h       |  6 ++--
 arch/arm/include/asm/kvm_emulate.h   |  4 +++
 arch/arm/include/asm/kvm_host.h      | 14 ++++++---
 arch/arm/include/asm/kvm_mmu.h       | 11 +++++++
 arch/arm/kvm/arm.c                   | 60 +++++++++++++++++++-----------------
 arch/arm/kvm/hyp/switch.c            |  4 +--
 arch/arm/kvm/hyp/tlb.c               | 15 ++++-----
 arch/arm/kvm/mmu.c                   |  9 ++++--
 arch/arm64/include/asm/kvm_asm.h     |  6 ++--
 arch/arm64/include/asm/kvm_emulate.h |  8 +++++
 arch/arm64/include/asm/kvm_host.h    | 14 ++++++---
 arch/arm64/include/asm/kvm_mmu.h     | 11 +++++++
 arch/arm64/kvm/hyp/switch.c          |  4 +--
 arch/arm64/kvm/hyp/tlb.c             | 16 ++++------
 14 files changed, 112 insertions(+), 70 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 36e3856..aa214f7 100644
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
index 05d5906..6285f4f 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -305,4 +305,8 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	}
 }
 
+static inline struct kvm_s2_vmid *vcpu_get_active_vmid(struct kvm_vcpu *vcpu)
+{
+	return &vcpu->kvm->arch.mmu.vmid;
+}
 #endif /* __ARM_KVM_EMULATE_H__ */
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index f84a59c..da45394 100644
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
@@ -196,6 +198,9 @@ struct kvm_vcpu_arch {
 
 	/* Stage 2 paging state used by the hardware on next switch */
 	struct kvm_s2_mmu *hw_mmu;
+
+	/* VTTBR value used by the hardware on next switch */
+	u64 hw_vttbr;
 };
 
 struct kvm_vm_stat {
@@ -242,6 +247,7 @@ static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 {
 }
 
+unsigned int get_kvm_vmid_bits(void);
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
 struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 74a44727..1b3309c 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -230,6 +230,17 @@ static inline unsigned int kvm_get_vmid_bits(void)
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
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index eb3e709..aa8771d 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
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
@@ -139,7 +144,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_timer_init(kvm);
 
 	/* Mark the initial VMID generation invalid */
-	kvm->arch.mmu.vmid_gen = 0;
+	kvm->arch.mmu.vmid.vmid_gen = 0;
+	kvm->arch.mmu.el2_vmid.vmid_gen = 0;
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
 	kvm->arch.max_vcpus = vgic_present ?
@@ -312,6 +318,8 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
+	struct kvm_s2_mmu *mmu = &vcpu->kvm->arch.mmu;
+
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
@@ -321,7 +329,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	kvm_arm_reset_debug_ptr(vcpu);
 
-	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
+	vcpu->arch.hw_mmu = mmu;
+	vcpu->arch.hw_vttbr = kvm_get_vttbr(&mmu->vmid, mmu);
 
 	return 0;
 }
@@ -337,7 +346,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
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
 
@@ -415,36 +427,33 @@ void force_vm_exit(const cpumask_t *mask)
 
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
  * @kvm:	The guest that we are about to run
- * @mmu:	The stage-2 translation context to update
+ * @vmid:	The stage-2 VMID information struct
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
-
-	if (!need_new_vmid_gen(mmu))
+	if (!need_new_vmid_gen(vmid))
 		return;
 
 	spin_lock(&kvm_vmid_lock);
@@ -454,7 +463,7 @@ static void update_vttbr(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	 * already allocated a valid vmid for this vm, then this vcpu should
 	 * use the same vmid.
 	 */
-	if (!need_new_vmid_gen(mmu)) {
+	if (!need_new_vmid_gen(vmid)) {
 		spin_unlock(&kvm_vmid_lock);
 		return;
 	}
@@ -478,18 +487,11 @@ static void update_vttbr(struct kvm *kvm, struct kvm_s2_mmu *mmu)
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
-
 	spin_unlock(&kvm_vmid_lock);
 }
 
@@ -615,7 +617,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		cond_resched();
 
-		update_vttbr(vcpu->kvm, vcpu->arch.hw_mmu);
+		update_vttbr(vcpu->kvm, vcpu_get_active_vmid(vcpu));
 
 		if (vcpu->arch.power_off || vcpu->arch.pause)
 			vcpu_sleep(vcpu);
@@ -640,7 +642,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			run->exit_reason = KVM_EXIT_INTR;
 		}
 
-		if (ret <= 0 || need_new_vmid_gen(vcpu->arch.hw_mmu) ||
+		if (ret <= 0 || need_new_vmid_gen(vcpu_get_active_vmid(vcpu)) ||
 			vcpu->arch.power_off || vcpu->arch.pause) {
 			local_irq_enable();
 			kvm_pmu_sync_hwstate(vcpu);
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 6f99de1..65d0b5b 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -73,9 +73,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 
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
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index a27a204..5ca3a04 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -60,12 +60,17 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
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
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ed8139f..27dce47 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -53,9 +53,9 @@
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
index a9c993f..94068e7 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -363,4 +363,12 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	return data;		/* Leave LE untouched */
 }
 
+static inline struct kvm_s2_vmid *vcpu_get_active_vmid(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(vcpu_mode_el2(vcpu)))
+		return &vcpu->kvm->arch.mmu.el2_vmid;
+
+	return &vcpu->kvm->arch.mmu.vmid;
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 954d6de..b33d35d 100644
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
@@ -334,6 +336,9 @@ struct kvm_vcpu_arch {
 
 	/* Stage 2 paging state used by the hardware on next switch */
 	struct kvm_s2_mmu *hw_mmu;
+
+	/* VTTBR value used by the hardware on next switch */
+	u64 hw_vttbr;
 };
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
@@ -391,6 +396,7 @@ static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 {
 }
 
+unsigned int get_kvm_vmid_bits(void);
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
 struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6f72fe8..e3455c4 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -314,5 +314,16 @@ static inline unsigned int kvm_get_vmid_bits(void)
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
index 3207009a..c80b2ae 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -135,9 +135,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
 {
-	struct kvm_s2_mmu *mmu = kern_hyp_va(vcpu->arch.hw_mmu);
-
-	write_sysreg(mmu->vttbr, vttbr_el2);
+	write_sysreg(vcpu->arch.hw_vttbr, vttbr_el2);
 }
 
 static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 71a62ea..82350e7 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -17,14 +17,12 @@
 
 #include <asm/kvm_hyp.h>
 
-void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
-					 phys_addr_t ipa)
+void __hyp_text __kvm_tlb_flush_vmid_ipa(u64 vttbr, phys_addr_t ipa)
 {
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
-	write_sysreg(mmu->vttbr, vttbr_el2);
+	write_sysreg(vttbr, vttbr_el2);
 	isb();
 
 	/*
@@ -49,13 +47,12 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	write_sysreg(0, vttbr_el2);
 }
 
-void __hyp_text __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
+void __hyp_text __kvm_tlb_flush_vmid(u64 vttbr)
 {
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
-	write_sysreg(mmu->vttbr, vttbr_el2);
+	write_sysreg(vttbr, vttbr_el2);
 	isb();
 
 	asm volatile("tlbi vmalls12e1is" : : );
@@ -65,11 +62,10 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	write_sysreg(0, vttbr_el2);
 }
 
-void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
+void __hyp_text __kvm_tlb_flush_local_vmid(u64 vttbr)
 {
 	/* Switch to requested VMID */
-	mmu = kern_hyp_va(mmu);
-	write_sysreg(mmu->vttbr, vttbr_el2);
+	write_sysreg(vttbr, vttbr_el2);
 	isb();
 
 	asm volatile("tlbi vmalle1" : : );
-- 
1.9.1
