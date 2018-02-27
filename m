From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v5 38/40] KVM: arm/arm64: Handle VGICv3 save/restore from the
 main VGIC code on VHE
Date: Tue, 27 Feb 2018 12:34:27 +0100
Message-ID: <20180227113429.637-39-cdall@kernel.org>
References: <20180227113429.637-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180227113429.637-1-cdall@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
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
---

Notes:
    Changes since v4:
     - Added can_access_vgic_from_kernel() primitive to make the
       save/restore flow from the main vgic code slightly easier to
       understand.
     - Also added a __hyp prefix to the non-VHE world-switch
       save/restore functions for GICv3 to avoid confusion with the
       save/restore functions in the main VGIC code.
    
    Changes since v2:
     - Added ISB in the early exit path in the run loop as explained
       in the commit message.

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
