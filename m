From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 53/85] KVM: arm/arm64: Avoid VGICv3 save/restore on VHE with
 no IRQs
Date: Wed, 28 Mar 2018 13:52:22 +0100
Message-ID: <20180328125254.31380-54-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2250049FAC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:55:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3WXAc1CJKyx0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:54:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 752BF4A0A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:48:36 -0400 (EDT)
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
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_hyp.h   |   2 +
 arch/arm/kvm/hyp/switch.c        |   8 ++-
 arch/arm64/include/asm/kvm_hyp.h |   2 +
 arch/arm64/kvm/hyp/switch.c      |   8 ++-
 virt/kvm/arm/hyp/vgic-v3-sr.c    | 120 +++++++++++++++++++++++++--------------
 virt/kvm/arm/vgic/vgic-v3.c      |   6 ++
 virt/kvm/arm/vgic/vgic.c         |   9 ++-
 7 files changed, 103 insertions(+), 52 deletions(-)

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index 530a3c1cfe6f..e93a0cac9add 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -110,6 +110,8 @@ void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
 
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
+void __vgic_v3_activate_traps(struct kvm_vcpu *vcpu);
+void __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu);
 void __vgic_v3_save_aprs(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 882b9b9e0077..acf1c37fa49c 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -90,14 +90,18 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 
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
index 6f3929b2fcf7..384c34397619 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -124,6 +124,8 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
+void __vgic_v3_activate_traps(struct kvm_vcpu *vcpu);
+void __vgic_v3_deactivate_traps(struct kvm_vcpu *vcpu);
 void __vgic_v3_save_aprs(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 86abbee40d3f..07b572173265 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -195,15 +195,19 @@ static void __hyp_text __deactivate_vm(struct kvm_vcpu *vcpu)
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_text __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(vcpu);
+		__vgic_v3_deactivate_traps(vcpu);
+	}
 }
 
 /* Restore VGICv3 state on non_VEH systems */
 static void __hyp_text __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
+		__vgic_v3_activate_traps(vcpu);
 		__vgic_v3_restore_state(vcpu);
+	}
 }
 
 static bool __hyp_text __true_value(void)
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 437d7af08683..b13cbd41dbc3 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -209,15 +209,15 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
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
@@ -226,7 +226,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 
 		elrsr = read_gicreg(ICH_ELSR_EL2);
 
-		write_gicreg(0, ICH_HCR_EL2);
+		write_gicreg(cpu_if->vgic_hcr & ~ICH_HCR_EN, ICH_HCR_EL2);
 
 		for (i = 0; i < used_lrs; i++) {
 			if (elrsr & (1 << i))
@@ -236,19 +236,6 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 
 			__gic_v3_set_lr(0, i);
 		}
-	} else {
-		if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
-		    cpu_if->its_vpe.its_vm)
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
 
@@ -258,6 +245,31 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
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
@@ -265,47 +277,69 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
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
-		 * injected. Same thing if GICv4 is used, as VLPI
-		 * delivery is gated by ICH_HCR_EL2.En.
-		 */
-		if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
-		    cpu_if->its_vpe.its_vm)
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
 	 */
+	write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
+		     ICC_SRE_EL2);
+
+	/*
+	 * If we need to trap system registers, we must write
+	 * ICH_HCR_EL2 anyway, even if no interrupts are being
+	 * injected,
+	 */
+	if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
+	    cpu_if->its_vpe.its_vm)
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
+	if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
+	    cpu_if->its_vpe.its_vm)
+		write_gicreg(0, ICH_HCR_EL2);
 }
 
 void __hyp_text __vgic_v3_save_aprs(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 4bafcd1e6bb8..4200657694f0 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -590,6 +590,9 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
 
 	kvm_call_hyp(__vgic_v3_restore_aprs, vcpu);
+
+	if (has_vhe())
+		__vgic_v3_activate_traps(vcpu);
 }
 
 void vgic_v3_put(struct kvm_vcpu *vcpu)
@@ -600,4 +603,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 		cpu_if->vgic_vmcr = kvm_call_hyp(__vgic_v3_read_vmcr);
 
 	kvm_call_hyp(__vgic_v3_save_aprs, vcpu);
+
+	if (has_vhe())
+		__vgic_v3_deactivate_traps(vcpu);
 }
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index eaab4a616ecf..4c4b011685b4 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -773,15 +773,15 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
-	if (can_access_vgic_from_kernel())
-		vgic_save_state(vcpu);
-
 	WARN_ON(vgic_v4_sync_hwstate(vcpu));
 
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
 
+	if (can_access_vgic_from_kernel())
+		vgic_save_state(vcpu);
+
 	if (vgic_cpu->used_lrs)
 		vgic_fold_lr_state(vcpu);
 	vgic_prune_ap_list(vcpu);
@@ -810,7 +810,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * this.
 	 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
-		goto out;
+		return;
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
@@ -818,7 +818,6 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	vgic_flush_lr_state(vcpu);
 	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
 
-out:
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
 }
-- 
2.14.2
