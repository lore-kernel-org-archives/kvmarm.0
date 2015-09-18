From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH 1/2] KVM/arm: add hooks for armv7 fp/simd lazy switch support
Date: Thu, 17 Sep 2015 18:05:16 -0700
Message-ID: <1442538317-13618-2-git-send-email-m.smarduch@samsung.com>
References: <1442538317-13618-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1442538317-13618-1-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

Basic hooks are added to support fp/simd lazy switch. A vcpu flag to track 
fp/simd state, offset into the vcpu structure and switch prototype function.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/include/asm/kvm_asm.h  | 1 +
 arch/arm/include/asm/kvm_host.h | 3 +++
 arch/arm/kernel/asm-offsets.c   | 1 +
 3 files changed, 5 insertions(+)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 194c91b..4b45d79 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -97,6 +97,7 @@ extern char __kvm_hyp_code_end[];
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
+extern void __kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 #endif
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index dcba0fa..4858f6c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -111,6 +111,9 @@ struct kvm_vcpu_arch {
 	/* Interrupt related fields */
 	u32 irq_lines;		/* IRQ and FIQ levels */
 
+	/* Track fp/simd lazy switch */
+	u32 vfp_lazy;
+
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 871b826..4a80802f 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -191,6 +191,7 @@ int main(void)
   DEFINE(VCPU_HPFAR,		offsetof(struct kvm_vcpu, arch.fault.hpfar));
   DEFINE(VCPU_HYP_PC,		offsetof(struct kvm_vcpu, arch.fault.hyp_pc));
   DEFINE(VCPU_VGIC_CPU,		offsetof(struct kvm_vcpu, arch.vgic_cpu));
+  DEFINE(VCPU_VFP_LAZY,		offsetof(struct kvm_vcpu, arch.vfp_lazy));
   DEFINE(VGIC_V2_CPU_HCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_hcr));
   DEFINE(VGIC_V2_CPU_VMCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_vmcr));
   DEFINE(VGIC_V2_CPU_MISR,	offsetof(struct vgic_cpu, vgic_v2.vgic_misr));
-- 
1.9.1

