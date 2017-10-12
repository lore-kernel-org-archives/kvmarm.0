From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 37/37] KVM: arm/arm64: Avoid VGICv3 save/restore on VHE with
 no IRQs
Date: Thu, 12 Oct 2017 12:41:41 +0200
Message-ID: <20171012104141.26902-38-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E9A449D96
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VLKtv8ABh4Fg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:50 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28A7E49D3E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:50 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id u138so11928898wmu.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:42:34 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We can finally get completely rid of any calls to the VGICv3
save/restore functions when the AP lists are empty on VHE systems.  This
requires carefully factoring out trap configuration from saving and
restoring state, and carefully choosing what to do on the VHE and
non-VHE path.

One of the challenges is that we cannot save/restore the VMCR lazily
because we can only write the VMCR when ICC_SRE_EL1.SRE is cleared when
emulating a GICv2-on-GICv3, since otherwise all Group-0 interrupts end
up being delivered as FIQ.

To solve this problem, and still provide fast performance in the fast
path of exiting a VM when no interrupts are pending (which also
optimized the latency for actually delivering virtual interrupts coming
from physical interrupts), we orchestrate a dance of only doing the
activate/deactivate traps in vgic load/put for VHE systems (which can
have ICC_SRE_EL1.SRE cleared when running in the host), and doing the
configuration on every round-trip on non-VHE systems.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_hyp.h   |   2 +
 arch/arm/kvm/hyp/switch.c        |   8 ++-
 arch/arm64/include/asm/kvm_hyp.h |   2 +
 arch/arm64/kvm/hyp/switch.c      |   8 ++-
 virt/kvm/arm/hyp/vgic-v3-sr.c    | 116 +++++++++++++++++++++++++--------------
 virt/kvm/arm/vgic/vgic-v3.c      |   6 ++
 virt/kvm/arm/vgic/vgic.c         |   7 +--
 7 files changed, 101 insertions(+), 48 deletions(-)

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index b3dd4f4..d01676e 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -109,6 +109,8 @@ void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
 
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
+void __vgic_v3_activate_traps(struct kvm_vcpu *vcpu);
+void __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu);
 void __vgic_v3_save_aprs(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 0d834f8..6b487c2 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -89,14 +89,18 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(vcpu);
+		__vgic_v3_deactivate_traps(vcpu);
+	}
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
+		__vgic_v3_activate_traps(vcpu);
 		__vgic_v3_restore_state(vcpu);
+	}
 }
 
 static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 62872ce..1c21a70 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -125,6 +125,8 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
+void __vgic_v3_activate_traps(struct kvm_vcpu *vcpu);
+void __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu);
 void __vgic_v3_save_aprs(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 0cdf6ae..42e6d56 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -184,14 +184,18 @@ static inline void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 
 static void __hyp_text __vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(vcpu);
+		__vgic_v3_deactivate_traps(vcpu);
+	}
 }
 
 static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
+		__vgic_v3_activate_traps(vcpu);
 		__vgic_v3_restore_state(vcpu);
+	}
 }
 
 static bool __hyp_text __true_value(void)
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index ed5da75..34d71d2 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -208,15 +208,15 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
-	u64 val;
 
 	/*
 	 * Make sure stores to the GIC via the memory mapped interface
-	 * are now visible to the system register interface.
+	 * are now visible to the system register interface when reading the
+	 * LRs, and when reading back the VMCR on non-VHE systems.
 	 */
-	if (!cpu_if->vgic_sre) {
-		dsb(st);
-		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
+	if (used_lrs || !has_vhe()) {
+		if (!cpu_if->vgic_sre)
+			dsb(st);
 	}
 
 	if (used_lrs) {
@@ -225,7 +225,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 
 		elrsr = read_gicreg(ICH_ELSR_EL2);
 
-		write_gicreg(0, ICH_HCR_EL2);
+		write_gicreg(cpu_if->vgic_hcr & ~ICH_HCR_EN, ICH_HCR_EL2);
 
 		for (i = 0; i < used_lrs; i++) {
 			if (elrsr & (1 << i))
@@ -235,18 +235,6 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 
 			__gic_v3_set_lr(0, i);
 		}
-	} else {
-		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
-			write_gicreg(0, ICH_HCR_EL2);
-	}
-
-	val = read_gicreg(ICC_SRE_EL2);
-	write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
-
-	if (!cpu_if->vgic_sre) {
-		/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
-		isb();
-		write_gicreg(1, ICC_SRE_EL1);
 	}
 }
 
@@ -256,6 +244,31 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 	int i;
 
+	if (used_lrs) {
+		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
+
+		for (i = 0; i < used_lrs; i++)
+			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
+	}
+
+	/*
+	 * Ensure that writes to the LRs, and on non-VHE systems ensure that
+	 * the write to the VMCR in __vgic_v3_activate_traps(), will have
+	 * reached the (re)distributors. This ensure the guest will read the
+	 * correct values from the memory-mapped interface.
+	 */
+	if (used_lrs || !has_vhe()) {
+		if (!cpu_if->vgic_sre) {
+			isb();
+			dsb(sy);
+		}
+	}
+}
+
+void __hyp_text __vgic_v3_activate_traps(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+
 	/*
 	 * VFIQEn is RES1 if ICC_SRE_EL1.SRE is 1. This causes a
 	 * Group0 interrupt (as generated in GICv2 mode) to be
@@ -263,45 +276,68 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	 * consequences. So we must make sure that ICC_SRE_EL1 has
 	 * been actually programmed with the value we want before
 	 * starting to mess with the rest of the GIC, and VMCR_EL2 in
-	 * particular.
+	 * particular.  This logic must be called before
+	 * __vgic_v3_restore_state().
 	 */
 	if (!cpu_if->vgic_sre) {
 		write_gicreg(0, ICC_SRE_EL1);
 		isb();
 		write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
-	}
 
-	if (used_lrs) {
-		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 
-		for (i = 0; i < used_lrs; i++)
-			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
-	} else {
-		/*
-		 * If we need to trap system registers, we must write
-		 * ICH_HCR_EL2 anyway, even if no interrupts are being
-		 * injected,
-		 */
-		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
-			write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
+		if (has_vhe()) {
+			/*
+			 * Ensure that the write to the VMCR will have reached
+			 * the (re)distributors. This ensure the guest will
+			 * read the correct values from the memory-mapped
+			 * interface.
+			 */
+			isb();
+			dsb(sy);
+		}
 	}
 
 	/*
-	 * Ensures that the above will have reached the
-	 * (re)distributors. This ensure the guest will read the
-	 * correct values from the memory-mapped interface.
+	 * Prevent the guest from touching the GIC system registers if
+	 * SRE isn't enabled for GICv3 emulation.
+	 */
+	write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
+		     ICC_SRE_EL2);
+
+	/*
+	 * If we need to trap system registers, we must write
+	 * ICH_HCR_EL2 anyway, even if no interrupts are being
+	 * injected,
 	 */
+	if (static_branch_unlikely(&vgic_v3_cpuif_trap))
+		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
+}
+
+void __hyp_text __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	u64 val;
+
 	if (!cpu_if->vgic_sre) {
+		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
+	}
+
+
+	val = read_gicreg(ICC_SRE_EL2);
+	write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
+
+	if (!cpu_if->vgic_sre) {
+		/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
 		isb();
-		dsb(sy);
+		write_gicreg(1, ICC_SRE_EL1);
 	}
 
 	/*
-	 * Prevent the guest from touching the GIC system registers if
-	 * SRE isn't enabled for GICv3 emulation.
+	 * If we were trapping system registers, we enabled the VGIC even if
+	 * no interrupts were being injected, and we disable it again here.
 	 */
-	write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
-		     ICC_SRE_EL2);
+	if (static_branch_unlikely(&vgic_v3_cpuif_trap))
+		write_gicreg(0, ICH_HCR_EL2);
 }
 
 void __hyp_text __vgic_v3_save_aprs(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index df3a222..964c647 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -547,6 +547,9 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
 
 	kvm_call_hyp(__vgic_v3_restore_aprs, vcpu);
+
+	if (has_vhe())
+		__vgic_v3_activate_traps(vcpu);
 }
 
 void vgic_v3_put(struct kvm_vcpu *vcpu)
@@ -557,4 +560,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 		cpu_if->vgic_vmcr = kvm_call_hyp(__vgic_v3_read_vmcr);
 
 	kvm_call_hyp(__vgic_v3_save_aprs, vcpu);
+
+	if (has_vhe())
+		__vgic_v3_deactivate_traps(vcpu);
 }
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index f0072f7..3b8d092 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -698,12 +698,12 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
-	vgic_save_state(vcpu);
-
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
 
+	vgic_save_state(vcpu);
+
 	if (vgic_cpu->used_lrs)
 		vgic_fold_lr_state(vcpu);
 	vgic_prune_ap_list(vcpu);
@@ -730,7 +730,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * this.
 	 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
-		goto out;
+		return;
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
@@ -738,7 +738,6 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	vgic_flush_lr_state(vcpu);
 	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
 
-out:
 	vgic_restore_state(vcpu);
 }
 
-- 
2.9.0
