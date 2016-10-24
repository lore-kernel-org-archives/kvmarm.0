From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm/arm64: KVM: Perform local TLB invalidation when multiplexing vcpus on a single CPU
Date: Mon, 24 Oct 2016 16:31:28 +0100
Message-ID: <1477323088-18768-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Architecturally, TLBs are private to the (physical) CPU they're
associated with. But when multiple vcpus from the same VM are
being multiplexed on the same CPU, the TLBs are not private
to the vcpus (and are actually shared across the VMID).

Let's consider the following scenario:

- vcpu-0 maps PA to VA
- vcpu-1 maps PA' to VA

If run on the same physical CPU, vcpu-1 can hit TLB entries generated
by vcpu-0 accesses, and access the wrong physical page.

The solution to this is to keep a per-VM map of which vcpu ran last
on each given physical CPU, and invalidate local TLBs when switching
to a different vcpu from the same VM.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  5 +++++
 arch/arm/include/asm/kvm_hyp.h    |  1 +
 arch/arm/kvm/arm.c                | 35 ++++++++++++++++++++++++++++++++++-
 arch/arm/kvm/hyp/switch.c         |  9 +++++++++
 arch/arm64/include/asm/kvm_host.h |  6 +++++-
 arch/arm64/kvm/hyp/switch.c       |  8 ++++++++
 6 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 2d19e02..035e744 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -57,6 +57,8 @@ struct kvm_arch {
 	/* VTTBR value associated with below pgd and vmid */
 	u64    vttbr;
 
+	int __percpu *last_vcpu_ran;
+
 	/* Timer */
 	struct arch_timer_kvm	timer;
 
@@ -174,6 +176,9 @@ struct kvm_vcpu_arch {
 	/* vcpu power-off state */
 	bool power_off;
 
+	/* TLBI required */
+	bool requires_tlbi;
+
 	 /* Don't run the guest (internal implementation need) */
 	bool pause;
 
diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index 343135e..5850890 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -71,6 +71,7 @@
 #define ICIALLUIS	__ACCESS_CP15(c7, 0, c1, 0)
 #define ATS1CPR		__ACCESS_CP15(c7, 0, c8, 0)
 #define TLBIALLIS	__ACCESS_CP15(c8, 0, c3, 0)
+#define TLBIALL		__ACCESS_CP15(c8, 0, c7, 0)
 #define TLBIALLNSNHIS	__ACCESS_CP15(c8, 4, c3, 4)
 #define PRRR		__ACCESS_CP15(c10, 0, c2, 0)
 #define NMRR		__ACCESS_CP15(c10, 0, c2, 1)
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 03e9273..09942f0 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -114,11 +114,18 @@ void kvm_arch_check_processor_compat(void *rtn)
  */
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
-	int ret = 0;
+	int ret, cpu;
 
 	if (type)
 		return -EINVAL;
 
+	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
+	if (!kvm->arch.last_vcpu_ran)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu)
+		*per_cpu_ptr(kvm->arch.last_vcpu_ran, cpu) = -1;
+
 	ret = kvm_alloc_stage2_pgd(kvm);
 	if (ret)
 		goto out_fail_alloc;
@@ -141,6 +148,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(kvm);
 out_fail_alloc:
+	free_percpu(kvm->arch.last_vcpu_ran);
+	kvm->arch.last_vcpu_ran = NULL;
 	return ret;
 }
 
@@ -168,6 +177,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	int i;
 
+	free_percpu(kvm->arch.last_vcpu_ran);
+	kvm->arch.last_vcpu_ran = NULL;
+
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (kvm->vcpus[i]) {
 			kvm_arch_vcpu_free(kvm->vcpus[i]);
@@ -310,6 +322,27 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+	int *last_ran;
+
+	last_ran = per_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran, cpu);
+
+	/*
+	 * If we're very unlucky and get preempted before having ran
+	 * this vcpu for real, we'll end-up in a situation where any
+	 * vcpu that gets scheduled will perform an invalidation (this
+	 * vcpu explicitely requires it, and all the others will have
+	 * a different vcpu_id).
+	 */
+	if (*last_ran != vcpu->vcpu_id) {
+		if (*last_ran != -1)
+			vcpu->arch.requires_tlbi = true;
+
+		*last_ran = vcpu->vcpu_id;
+	}
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	vcpu->cpu = cpu;
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 92678b7..ab8ee3b 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -75,6 +75,15 @@ static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	write_sysreg(kvm->arch.vttbr, VTTBR);
+	if (vcpu->arch.requires_tlbi) {
+		/* Force vttbr to be written */
+		isb();
+		/* Local invalidate only for this VMID */
+		write_sysreg(0, TLBIALL);
+		dsb(nsh);
+		vcpu->arch.requires_tlbi = false;
+	}
+
 	write_sysreg(vcpu->arch.midr, VPIDR);
 }
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bd94e67..5b42010 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -62,6 +62,8 @@ struct kvm_arch {
 	/* VTTBR value associated with above pgd and vmid */
 	u64    vttbr;
 
+	int __percpu *last_vcpu_ran;
+
 	/* The maximum number of vCPUs depends on the used GIC model */
 	int max_vcpus;
 
@@ -252,6 +254,9 @@ struct kvm_vcpu_arch {
 	/* vcpu power-off state */
 	bool power_off;
 
+	/* TLBI required */
+	bool requires_tlbi;
+
 	/* Don't run the guest (internal implementation need) */
 	bool pause;
 
@@ -368,7 +373,6 @@ static inline void __cpu_reset_hyp_mode(unsigned long vector_ptr,
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
-static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 83037cd..8d9c3eb 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -131,6 +131,14 @@ static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	write_sysreg(kvm->arch.vttbr, vttbr_el2);
+	if (vcpu->arch.requires_tlbi) {
+		/* Force vttbr_el2 to be written */
+		isb();
+		/* Local invalidate only for this VMID */
+		asm volatile("tlbi vmalle1" : : );
+		dsb(nsh);
+		vcpu->arch.requires_tlbi = false;
+	}
 }
 
 static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
-- 
2.1.4

