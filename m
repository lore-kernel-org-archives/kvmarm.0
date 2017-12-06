From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v5 02/16] KVM: arm/arm64: Convert kvm_host_cpu_state to a static per-cpu allocation
Date: Wed,  6 Dec 2017 19:01:28 +0000
Message-ID: <20171206190142.9246-3-james.morse@arm.com>
References: <20171206190142.9246-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171206190142.9246-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Heyi Guo <guoheyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

kvm_host_cpu_state is a per-cpu allocation made from kvm_arch_init()
used to store the host EL1 registers when KVM switches to a guest.

Make it easier for ASM to generate pointers into this per-cpu memory
by making it a static allocation.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Acked-by: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 virt/kvm/arm/arm.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a67c106d73f5..732d0b68d80f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -53,8 +53,8 @@
 __asm__(".arch_extension	virt");
 #endif
 
+DEFINE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
-static kvm_cpu_context_t __percpu *kvm_host_cpu_state;
 
 /* Per-CPU variable containing the currently running vcpu. */
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
@@ -354,7 +354,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	vcpu->cpu = cpu;
-	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
+	vcpu->arch.host_cpu_context = this_cpu_ptr(&kvm_host_cpu_state);
 
 	kvm_arm_set_running_vcpu(vcpu);
 	kvm_vgic_load(vcpu);
@@ -1269,19 +1269,8 @@ static inline void hyp_cpu_pm_exit(void)
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
@@ -1417,7 +1406,7 @@ static int init_hyp_mode(void)
 	for_each_possible_cpu(cpu) {
 		kvm_cpu_context_t *cpu_ctxt;
 
-		cpu_ctxt = per_cpu_ptr(kvm_host_cpu_state, cpu);
+		cpu_ctxt = per_cpu_ptr(&kvm_host_cpu_state, cpu);
 		err = create_hyp_mappings(cpu_ctxt, cpu_ctxt + 1, PAGE_HYP);
 
 		if (err) {
@@ -1541,7 +1530,6 @@ int kvm_arch_init(void *opaque)
 	if (!in_hyp_mode)
 		teardown_hyp_mode();
 out_err:
-	teardown_common_resources();
 	return err;
 }
 
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
