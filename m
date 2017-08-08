From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 02/11] KVM: arm/arm64: Convert kvm_host_cpu_state to a
 static per-cpu allocation
Date: Tue,  8 Aug 2017 17:46:07 +0100
Message-ID: <20170808164616.25949-3-james.morse@arm.com>
References: <20170808164616.25949-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DD1149C35
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 12:46:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E4KzBvdWq3d9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Aug 2017 12:46:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41D7940FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Aug 2017 12:46:13 -0400 (EDT)
In-Reply-To: <20170808164616.25949-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

kvm_host_cpu_state is a per-cpu allocation made from kvm_arch_init()
used to store the host EL1 registers when KVM switches to a guest.

Make it easier for ASM to generate pointers into this per-cpu memory
by making it a static allocation.

Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/arm.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a39a1e161e63..e9765ee6d769 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -51,8 +51,8 @@
 __asm__(".arch_extension	virt");
 #endif
 
+DEFINE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
-static kvm_cpu_context_t __percpu *kvm_host_cpu_state;
 
 /* Per-CPU variable containing the currently running vcpu. */
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
@@ -351,7 +351,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	vcpu->cpu = cpu;
-	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
+	vcpu->arch.host_cpu_context = this_cpu_ptr(&kvm_host_cpu_state);
 
 	kvm_arm_set_running_vcpu(vcpu);
 
@@ -1250,19 +1250,8 @@ static inline void hyp_cpu_pm_exit(void)
 }
 #endif
 
-static void teardown_common_resources(void)
-{
-	free_percpu(kvm_host_cpu_state);
-}
-
 static int init_common_resources(void)
 {
-	kvm_host_cpu_state = alloc_percpu(kvm_cpu_context_t);
-	if (!kvm_host_cpu_state) {
-		kvm_err("Cannot allocate host CPU state\n");
-		return -ENOMEM;
-	}
-
 	/* set size of VMID supported by CPU */
 	kvm_vmid_bits = kvm_get_vmid_bits();
 	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
@@ -1407,7 +1396,7 @@ static int init_hyp_mode(void)
 	for_each_possible_cpu(cpu) {
 		kvm_cpu_context_t *cpu_ctxt;
 
-		cpu_ctxt = per_cpu_ptr(kvm_host_cpu_state, cpu);
+		cpu_ctxt = per_cpu_ptr(&kvm_host_cpu_state, cpu);
 		err = create_hyp_mappings(cpu_ctxt, cpu_ctxt + 1, PAGE_HYP);
 
 		if (err) {
@@ -1485,7 +1474,6 @@ int kvm_arch_init(void *opaque)
 out_hyp:
 	teardown_hyp_mode();
 out_err:
-	teardown_common_resources();
 	return err;
 }
 
-- 
2.13.3
