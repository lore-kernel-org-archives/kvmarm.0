From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 51/85] KVM: arm/arm64: Handle VGICv3 save/restore from the
 main VGIC code on VHE
Date: Wed, 28 Mar 2018 13:52:20 +0100
Message-ID: <20180328125254.31380-52-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AC6C49FD6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:53:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gnhxlb1uSJ8C for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:53:18 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 166704029E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:48:28 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Just like we can program the GICv2 hypervisor control interface directly
from the core vgic code, we can do the same for the GICv3 hypervisor
control interface on VHE systems.

We do this by simply calling the save/restore functions when we have VHE
and we can then get rid of the save/restore function calls from the VHE
world switch function.

One caveat is that we now write GICv3 system register state before the
potential early exit path in the run loop, and because we sync back
state in the early exit path, we have to ensure that we read a
consistent GIC state from the sync path, even though we have never
actually run the guest with the newly written GIC state.  We solve this
by inserting an ISB in the early exit path.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 13 ++++++-------
 virt/kvm/arm/arm.c          |  1 +
 virt/kvm/arm/vgic/vgic.c    | 21 +++++++++++++++++++--
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 31badf6e91e8..86abbee40d3f 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -192,13 +192,15 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 	write_sysreg(0, vttbr_el2);
 }
 
-static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
+/* Save VGICv3 state on non-VHE systems */
+static void __hyp_text __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		__vgic_v3_save_state(vcpu);
 }
 
-static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
+/* Restore VGICv3 state on non_VEH systems */
+static void __hyp_text __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		__vgic_v3_restore_state(vcpu);
@@ -400,8 +402,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__activate_traps(vcpu);
 	__activate_vm(vcpu->kvm);
 
-	__vgic_restore_state(vcpu);
-
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
@@ -415,7 +415,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	fp_enabled = fpsimd_enabled_vhe();
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
-	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
 
@@ -451,7 +450,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__activate_traps(vcpu);
 	__activate_vm(kern_hyp_va(vcpu->kvm));
 
-	__vgic_restore_state(vcpu);
+	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps(vcpu);
 
 	/*
@@ -484,7 +483,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
-	__vgic_save_state(vcpu);
+	__hyp_vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
 	__deactivate_vm(vcpu);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 09dbee56ed8f..dba629c5f8ac 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -717,6 +717,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
+			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
 			if (static_branch_unlikely(&userspace_irqchip_in_use))
 				kvm_timer_sync_hwstate(vcpu);
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 12e2a28f437e..eaab4a616ecf 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -19,6 +19,7 @@
 #include <linux/list_sort.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <asm/kvm_hyp.h>
 
 #include "vgic.h"
 
@@ -749,10 +750,22 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		vgic_clear_lr(vcpu, count);
 }
 
+static inline bool can_access_vgic_from_kernel(void)
+{
+	/*
+	 * GICv2 can always be accessed from the kernel because it is
+	 * memory-mapped, and VHE systems can access GICv3 EL2 system
+	 * registers.
+	 */
+	return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) || has_vhe();
+}
+
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 {
 	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_save_state(vcpu);
+	else
+		__vgic_v3_save_state(vcpu);
 }
 
 /* Sync back the hardware VGIC state into our emulation after a guest's run. */
@@ -760,7 +773,8 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
-	vgic_save_state(vcpu);
+	if (can_access_vgic_from_kernel())
+		vgic_save_state(vcpu);
 
 	WARN_ON(vgic_v4_sync_hwstate(vcpu));
 
@@ -777,6 +791,8 @@ static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_restore_state(vcpu);
+	else
+		__vgic_v3_restore_state(vcpu);
 }
 
 /* Flush our emulation state into the GIC hardware before entering the guest. */
@@ -803,7 +819,8 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
 
 out:
-	vgic_restore_state(vcpu);
+	if (can_access_vgic_from_kernel())
+		vgic_restore_state(vcpu);
 }
 
 void kvm_vgic_load(struct kvm_vcpu *vcpu)
-- 
2.14.2
