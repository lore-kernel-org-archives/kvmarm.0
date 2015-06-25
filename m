From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH 1/3] arm: KVM: define headers and offsets to mange VFP state
Date: Wed, 24 Jun 2015 20:30:26 -0700
Message-ID: <1435203028-23142-2-git-send-email-m.smarduch@samsung.com>
References: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99B5756F28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 23:19:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IzFuQ3PqCoWt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2015 23:19:47 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3731956F33
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2015 23:19:47 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQH001F7DR9ZU30@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 24 Jun 2015 23:30:45 -0400 (EDT)
In-reply-to: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Define the required kvm_vcpu_arch fields, and offsets to manage VFP state. And
declary Hyp interface function to switch VFP registers.


Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/include/asm/kvm_asm.h  |    1 +
 arch/arm/include/asm/kvm_host.h |    3 +++
 arch/arm/kernel/asm-offsets.c   |    1 +
 3 files changed, 5 insertions(+)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 25410b2..08dda8c 100644
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
index d71607c..22cea72 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -111,6 +111,9 @@ struct kvm_vcpu_arch {
 	/* Interrupt related fields */
 	u32 irq_lines;		/* IRQ and FIQ levels */
 
+	/* Track if VFP registers are occupied by Guest while in KVM host mode*/
+	u32 vfp_guest_saved;
+
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 871b826..35093d0 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -191,6 +191,7 @@ int main(void)
   DEFINE(VCPU_HPFAR,		offsetof(struct kvm_vcpu, arch.fault.hpfar));
   DEFINE(VCPU_HYP_PC,		offsetof(struct kvm_vcpu, arch.fault.hyp_pc));
   DEFINE(VCPU_VGIC_CPU,		offsetof(struct kvm_vcpu, arch.vgic_cpu));
+  DEFINE(VCPU_VFP_SAVED,	offsetof(struct kvm_vcpu, arch.vfp_guest_saved));
   DEFINE(VGIC_V2_CPU_HCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_hcr));
   DEFINE(VGIC_V2_CPU_VMCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_vmcr));
   DEFINE(VGIC_V2_CPU_MISR,	offsetof(struct vgic_cpu, vgic_v2.vgic_misr));
-- 
1.7.9.5
