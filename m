From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v8 2/5] arm64: KVM: encapsulate kvm_cpu_context in
 kvm_host_data
Date: Wed, 12 Dec 2018 10:29:30 +0000
Message-ID: <1544610573-28446-3-git-send-email-andrew.murray@arm.com>
References: <1544610573-28446-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F05F64A2D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 05:29:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NJMCpa1YuO47 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 05:29:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A38874A1DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 05:29:45 -0500 (EST)
In-Reply-To: <1544610573-28446-1-git-send-email-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The virt/arm core allocates a kvm_cpu_context_t percpu, at present this is
a typedef to kvm_cpu_context and is used to store host cpu context. The
kvm_cpu_context structure is also used elsewhere to hold vcpu context.
In order to use the percpu to hold additional future host information we
encapsulate kvm_cpu_context in a new structure and rename the typedef and
percpu to match.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  8 ++++++--
 arch/arm64/include/asm/kvm_asm.h  |  4 ++--
 arch/arm64/include/asm/kvm_host.h | 15 ++++++++++-----
 arch/arm64/kernel/asm-offsets.c   |  2 +-
 virt/kvm/arm/arm.c                | 10 ++++++----
 5 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 79906ce..71645ba 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -145,7 +145,11 @@ struct kvm_cpu_context {
 	u32 cp15[NR_CP15_REGS];
 };
 
-typedef struct kvm_cpu_context kvm_cpu_context_t;
+struct kvm_host_data {
+	struct kvm_cpu_context host_ctxt;
+};
+
+typedef struct kvm_host_data kvm_host_data_t;
 
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
@@ -163,7 +167,7 @@ struct kvm_vcpu_arch {
 	struct kvm_vcpu_fault_info fault;
 
 	/* Host FP context */
-	kvm_cpu_context_t *host_cpu_context;
+	struct kvm_cpu_context *host_cpu_context;
 
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 102b5a5..6a9bfd4 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -102,12 +102,12 @@ extern u32 __init_stage2_translation(void);
 .endm
 
 .macro get_host_ctxt reg, tmp
-	hyp_adr_this_cpu \reg, kvm_host_cpu_state, \tmp
+	hyp_adr_this_cpu \reg, kvm_host_data, \tmp
 .endm
 
 .macro get_vcpu_ptr vcpu, ctxt
 	get_host_ctxt \ctxt, \vcpu
-	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+	ldr	\vcpu, [\ctxt, #HOST_DATA_VCPU]
 	kern_hyp_va	\vcpu
 .endm
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1550192..1d3ca91 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -205,7 +205,12 @@ struct kvm_cpu_context {
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
-typedef struct kvm_cpu_context kvm_cpu_context_t;
+struct kvm_host_data {
+	struct kvm_cpu_context host_ctxt;
+	struct kvm_pmu_events pmu_events;
+};
+
+typedef struct kvm_host_data kvm_host_data_t;
 
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
@@ -241,7 +246,7 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch external_debug_state;
 
 	/* Pointer to host CPU context */
-	kvm_cpu_context_t *host_cpu_context;
+	struct kvm_cpu_context *host_cpu_context;
 
 	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
@@ -387,7 +392,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
-DECLARE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
+DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
 
 void __kvm_enable_ssbs(void);
 
@@ -400,8 +405,8 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
 	 * so that we can use adr_l to access per-cpu variables in EL2.
 	 */
-	u64 tpidr_el2 = ((u64)this_cpu_ptr(&kvm_host_cpu_state) -
-			 (u64)kvm_ksym_ref(kvm_host_cpu_state));
+	u64 tpidr_el2 = ((u64)this_cpu_ptr(&kvm_host_data) -
+			 (u64)kvm_ksym_ref(kvm_host_data));
 
 	/*
 	 * Call initialization code, and switch to the full blown HYP code.
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 323aeb5..cb968ff 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -142,7 +142,7 @@ int main(void)
   DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
   DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
   DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
-  DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
+  DEFINE(HOST_DATA_VCPU,	offsetof(struct kvm_host_data, host_ctxt.__hyp_running_vcpu));
 #endif
 #ifdef CONFIG_CPU_PM
   DEFINE(CPU_SUSPEND_SZ,	sizeof(struct cpu_suspend_ctx));
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 150c8a6..c031ddf 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -56,7 +56,7 @@
 __asm__(".arch_extension	virt");
 #endif
 
-DEFINE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
+DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
 /* Per-CPU variable containing the currently running vcpu. */
@@ -361,8 +361,10 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
+	kvm_host_data_t *cpu_ctxt;
 
 	last_ran = this_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran);
+	cpu_ctxt = this_cpu_ptr(&kvm_host_data);
 
 	/*
 	 * We might get preempted before the vCPU actually runs, but
@@ -374,7 +376,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	vcpu->cpu = cpu;
-	vcpu->arch.host_cpu_context = this_cpu_ptr(&kvm_host_cpu_state);
+	vcpu->arch.host_cpu_context = &cpu_ctxt->host_ctxt;
 
 	kvm_arm_set_running_vcpu(vcpu);
 	kvm_vgic_load(vcpu);
@@ -1547,9 +1549,9 @@ static int init_hyp_mode(void)
 	}
 
 	for_each_possible_cpu(cpu) {
-		kvm_cpu_context_t *cpu_ctxt;
+		kvm_host_data_t *cpu_ctxt;
 
-		cpu_ctxt = per_cpu_ptr(&kvm_host_cpu_state, cpu);
+		cpu_ctxt = per_cpu_ptr(&kvm_host_data, cpu);
 		err = create_hyp_mappings(cpu_ctxt, cpu_ctxt + 1, PAGE_HYP);
 
 		if (err) {
-- 
2.7.4
