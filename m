From: Peng Hao <peng.hao2@zte.com.cn>
Subject: [PATCH] KVM: arm/arm64: replacing per-VM's per-CPU variable
Date: Wed, 14 Mar 2018 05:03:13 +0800
Message-ID: <1520974993-40423-1-git-send-email-peng.hao2@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, cdall@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Peng Hao <peng.hao2@zte.com.cn>
List-Id: kvmarm@lists.cs.columbia.edu

Using a global per-CPU variable instead of per-VM's per-CPU variable.

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
---
 arch/arm/include/asm/kvm_host.h   |  3 ---
 arch/arm64/include/asm/kvm_host.h |  3 ---
 virt/kvm/arm/arm.c                | 26 ++++++--------------------
 3 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 248b930..4224f3b 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -59,9 +59,6 @@ struct kvm_arch {
 	/* VTTBR value associated with below pgd and vmid */
 	u64    vttbr;
 
-	/* The last vcpu id that ran on each physical CPU */
-	int __percpu *last_vcpu_ran;
-
 	/*
 	 * Anything that is not used directly from assembly code goes
 	 * here.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 596f8e4..5035a08 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -67,9 +67,6 @@ struct kvm_arch {
 	/* VTTBR value associated with above pgd and vmid */
 	u64    vttbr;
 
-	/* The last vcpu id that ran on each physical CPU */
-	int __percpu *last_vcpu_ran;
-
 	/* The maximum number of vCPUs depends on the used GIC model */
 	int max_vcpus;
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86941f6..a67ffb0 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -59,6 +59,8 @@
 /* Per-CPU variable containing the currently running vcpu. */
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
 
+static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_last_ran_vcpu);
+
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
 static u32 kvm_next_vmid;
@@ -115,18 +117,11 @@ void kvm_arch_check_processor_compat(void *rtn)
  */
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
-	int ret, cpu;
+	int ret;
 
 	if (type)
 		return -EINVAL;
 
-	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
-	if (!kvm->arch.last_vcpu_ran)
-		return -ENOMEM;
-
-	for_each_possible_cpu(cpu)
-		*per_cpu_ptr(kvm->arch.last_vcpu_ran, cpu) = -1;
-
 	ret = kvm_alloc_stage2_pgd(kvm);
 	if (ret)
 		goto out_fail_alloc;
@@ -147,9 +142,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 out_free_stage2_pgd:
 	kvm_free_stage2_pgd(kvm);
-out_fail_alloc:
-	free_percpu(kvm->arch.last_vcpu_ran);
-	kvm->arch.last_vcpu_ran = NULL;
+out_fail_alloc:
 	return ret;
 }
 
@@ -179,9 +172,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	kvm_vgic_destroy(kvm);
 
-	free_percpu(kvm->arch.last_vcpu_ran);
-	kvm->arch.last_vcpu_ran = NULL;
-
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (kvm->vcpus[i]) {
 			kvm_arch_vcpu_free(kvm->vcpus[i]);
@@ -343,17 +333,13 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	int *last_ran;
-
-	last_ran = this_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran);
-
 	/*
 	 * We might get preempted before the vCPU actually runs, but
 	 * over-invalidation doesn't affect correctness.
 	 */
-	if (*last_ran != vcpu->vcpu_id) {
+	if (per_cpu(kvm_last_ran_vcpu, cpu) != vcpu) {
 		kvm_call_hyp(__kvm_tlb_flush_local_vmid, vcpu);
-		*last_ran = vcpu->vcpu_id;
+		per_cpu(kvm_last_ran_vcpu, cpu) = vcpu;
 	}
 
 	vcpu->cpu = cpu;
-- 
1.8.3.1
