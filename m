From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 13/25] arm64: KVM: remove remaining reference to vgic_sr_vectors
Date: Thu, 20 Aug 2015 17:28:51 +0100
Message-ID: <1440088143-4722-14-git-send-email-marc.zyngier@arm.com>
References: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Vladimir Murzin <Vladimir.Murzin@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Mario Smarduch <m.smarduch@samsung.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <Vladimir.Murzin@arm.com>

Since commit 8a14849 (arm64: KVM: Switch vgic save/restore to
alternative_insn) vgic_sr_vectors is not used anymore, so remove
remaining leftovers and kill the structure.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 5 -----
 arch/arm64/kernel/asm-offsets.c   | 2 --
 2 files changed, 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 409217f..415938d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -246,11 +246,6 @@ static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
 		     hyp_stack_ptr, vector_ptr);
 }
 
-struct vgic_sr_vectors {
-	void	*save_vgic;
-	void	*restore_vgic;
-};
-
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index d886308..8d89cf8 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -132,8 +132,6 @@ int main(void)
   DEFINE(KVM_TIMER_ENABLED,	offsetof(struct kvm, arch.timer.enabled));
   DEFINE(VCPU_KVM,		offsetof(struct kvm_vcpu, kvm));
   DEFINE(VCPU_VGIC_CPU,		offsetof(struct kvm_vcpu, arch.vgic_cpu));
-  DEFINE(VGIC_SAVE_FN,		offsetof(struct vgic_sr_vectors, save_vgic));
-  DEFINE(VGIC_RESTORE_FN,	offsetof(struct vgic_sr_vectors, restore_vgic));
   DEFINE(VGIC_V2_CPU_HCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_hcr));
   DEFINE(VGIC_V2_CPU_VMCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_vmcr));
   DEFINE(VGIC_V2_CPU_MISR,	offsetof(struct vgic_cpu, vgic_v2.vgic_misr));
-- 
2.1.4

