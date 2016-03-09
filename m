From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 91/95] arm64: KVM: vgic-v3: Avoid accessing ICH registers
Date: Wed,  9 Mar 2016 07:31:25 +0000
Message-ID: <1457508689-19672-92-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41B6449BD5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:36:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OQO7nHCDJmwq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:36:05 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7263C49B77
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:36:04 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Just like on GICv2, we're a bit hammer-happy with GICv3, and access
them more often than we should.

Adopt a policy similar to what we do for GICv2, only save/restoring
the minimal set of registers. As we don't access the registers
linearly anymore (we may skip some), the convoluted accessors become
slightly simpler, and we can drop the ugly indexing macro that
tended to confuse the reviewers.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 293 ++++++++++++++++++++++++----------------
 include/kvm/arm_vgic.h          |   6 -
 virt/kvm/arm/vgic-v3.c          |   4 +-
 3 files changed, 182 insertions(+), 121 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 0035b2d..e596945 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -37,12 +37,104 @@
 		asm volatile("msr_s " __stringify(r) ", %0" : : "r" (__val));\
 	} while (0)
 
-/* vcpu is already in the HYP VA space */
+static u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
+{
+	switch (lr & 0xf) {
+	case 0:
+		return read_gicreg(ICH_LR0_EL2);
+	case 1:
+		return read_gicreg(ICH_LR1_EL2);
+	case 2:
+		return read_gicreg(ICH_LR2_EL2);
+	case 3:
+		return read_gicreg(ICH_LR3_EL2);
+	case 4:
+		return read_gicreg(ICH_LR4_EL2);
+	case 5:
+		return read_gicreg(ICH_LR5_EL2);
+	case 6:
+		return read_gicreg(ICH_LR6_EL2);
+	case 7:
+		return read_gicreg(ICH_LR7_EL2);
+	case 8:
+		return read_gicreg(ICH_LR8_EL2);
+	case 9:
+		return read_gicreg(ICH_LR9_EL2);
+	case 10:
+		return read_gicreg(ICH_LR10_EL2);
+	case 11:
+		return read_gicreg(ICH_LR11_EL2);
+	case 12:
+		return read_gicreg(ICH_LR12_EL2);
+	case 13:
+		return read_gicreg(ICH_LR13_EL2);
+	case 14:
+		return read_gicreg(ICH_LR14_EL2);
+	case 15:
+		return read_gicreg(ICH_LR15_EL2);
+	}
+
+	unreachable();
+}
+
+static void __hyp_text __gic_v3_set_lr(u64 val, int lr)
+{
+	switch (lr & 0xf) {
+	case 0:
+		write_gicreg(val, ICH_LR0_EL2);
+		break;
+	case 1:
+		write_gicreg(val, ICH_LR1_EL2);
+		break;
+	case 2:
+		write_gicreg(val, ICH_LR2_EL2);
+		break;
+	case 3:
+		write_gicreg(val, ICH_LR3_EL2);
+		break;
+	case 4:
+		write_gicreg(val, ICH_LR4_EL2);
+		break;
+	case 5:
+		write_gicreg(val, ICH_LR5_EL2);
+		break;
+	case 6:
+		write_gicreg(val, ICH_LR6_EL2);
+		break;
+	case 7:
+		write_gicreg(val, ICH_LR7_EL2);
+		break;
+	case 8:
+		write_gicreg(val, ICH_LR8_EL2);
+		break;
+	case 9:
+		write_gicreg(val, ICH_LR9_EL2);
+		break;
+	case 10:
+		write_gicreg(val, ICH_LR10_EL2);
+		break;
+	case 11:
+		write_gicreg(val, ICH_LR11_EL2);
+		break;
+	case 12:
+		write_gicreg(val, ICH_LR12_EL2);
+		break;
+	case 13:
+		write_gicreg(val, ICH_LR13_EL2);
+		break;
+	case 14:
+		write_gicreg(val, ICH_LR14_EL2);
+		break;
+	case 15:
+		write_gicreg(val, ICH_LR15_EL2);
+		break;
+	}
+}
+
 void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 	u64 val;
-	u32 max_lr_idx, nr_pri_bits;
 
 	/*
 	 * Make sure stores to the GIC via the memory mapped interface
@@ -51,68 +143,58 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 	dsb(st);
 
 	cpu_if->vgic_vmcr  = read_gicreg(ICH_VMCR_EL2);
-	cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
-	cpu_if->vgic_eisr  = read_gicreg(ICH_EISR_EL2);
-	cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
 
-	write_gicreg(0, ICH_HCR_EL2);
-	val = read_gicreg(ICH_VTR_EL2);
-	max_lr_idx = vtr_to_max_lr_idx(val);
-	nr_pri_bits = vtr_to_nr_pri_bits(val);
+	if (vcpu->arch.vgic_cpu.live_lrs) {
+		int i;
+		u32 max_lr_idx, nr_pri_bits;
 
-	switch (max_lr_idx) {
-	case 15:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(15)] = read_gicreg(ICH_LR15_EL2);
-	case 14:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(14)] = read_gicreg(ICH_LR14_EL2);
-	case 13:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(13)] = read_gicreg(ICH_LR13_EL2);
-	case 12:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(12)] = read_gicreg(ICH_LR12_EL2);
-	case 11:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(11)] = read_gicreg(ICH_LR11_EL2);
-	case 10:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(10)] = read_gicreg(ICH_LR10_EL2);
-	case 9:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(9)] = read_gicreg(ICH_LR9_EL2);
-	case 8:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(8)] = read_gicreg(ICH_LR8_EL2);
-	case 7:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(7)] = read_gicreg(ICH_LR7_EL2);
-	case 6:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(6)] = read_gicreg(ICH_LR6_EL2);
-	case 5:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(5)] = read_gicreg(ICH_LR5_EL2);
-	case 4:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(4)] = read_gicreg(ICH_LR4_EL2);
-	case 3:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(3)] = read_gicreg(ICH_LR3_EL2);
-	case 2:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(2)] = read_gicreg(ICH_LR2_EL2);
-	case 1:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(1)] = read_gicreg(ICH_LR1_EL2);
-	case 0:
-		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(0)] = read_gicreg(ICH_LR0_EL2);
-	}
+		cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
+		cpu_if->vgic_eisr  = read_gicreg(ICH_EISR_EL2);
+		cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
 
-	switch (nr_pri_bits) {
-	case 7:
-		cpu_if->vgic_ap0r[3] = read_gicreg(ICH_AP0R3_EL2);
-		cpu_if->vgic_ap0r[2] = read_gicreg(ICH_AP0R2_EL2);
-	case 6:
-		cpu_if->vgic_ap0r[1] = read_gicreg(ICH_AP0R1_EL2);
-	default:
-		cpu_if->vgic_ap0r[0] = read_gicreg(ICH_AP0R0_EL2);
-	}
+		write_gicreg(0, ICH_HCR_EL2);
+		val = read_gicreg(ICH_VTR_EL2);
+		max_lr_idx = vtr_to_max_lr_idx(val);
+		nr_pri_bits = vtr_to_nr_pri_bits(val);
 
-	switch (nr_pri_bits) {
-	case 7:
-		cpu_if->vgic_ap1r[3] = read_gicreg(ICH_AP1R3_EL2);
-		cpu_if->vgic_ap1r[2] = read_gicreg(ICH_AP1R2_EL2);
-	case 6:
-		cpu_if->vgic_ap1r[1] = read_gicreg(ICH_AP1R1_EL2);
-	default:
-		cpu_if->vgic_ap1r[0] = read_gicreg(ICH_AP1R0_EL2);
+		for (i = 0; i <= max_lr_idx; i++) {
+			if (vcpu->arch.vgic_cpu.live_lrs & (1UL << i))
+				cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
+		}
+
+		switch (nr_pri_bits) {
+		case 7:
+			cpu_if->vgic_ap0r[3] = read_gicreg(ICH_AP0R3_EL2);
+			cpu_if->vgic_ap0r[2] = read_gicreg(ICH_AP0R2_EL2);
+		case 6:
+			cpu_if->vgic_ap0r[1] = read_gicreg(ICH_AP0R1_EL2);
+		default:
+			cpu_if->vgic_ap0r[0] = read_gicreg(ICH_AP0R0_EL2);
+		}
+
+		switch (nr_pri_bits) {
+		case 7:
+			cpu_if->vgic_ap1r[3] = read_gicreg(ICH_AP1R3_EL2);
+			cpu_if->vgic_ap1r[2] = read_gicreg(ICH_AP1R2_EL2);
+		case 6:
+			cpu_if->vgic_ap1r[1] = read_gicreg(ICH_AP1R1_EL2);
+		default:
+			cpu_if->vgic_ap1r[0] = read_gicreg(ICH_AP1R0_EL2);
+		}
+
+		vcpu->arch.vgic_cpu.live_lrs = 0;
+	} else {
+		cpu_if->vgic_misr  = 0;
+		cpu_if->vgic_eisr  = 0;
+		cpu_if->vgic_elrsr = 0xffff;
+		cpu_if->vgic_ap0r[0] = 0;
+		cpu_if->vgic_ap0r[1] = 0;
+		cpu_if->vgic_ap0r[2] = 0;
+		cpu_if->vgic_ap0r[3] = 0;
+		cpu_if->vgic_ap1r[0] = 0;
+		cpu_if->vgic_ap1r[1] = 0;
+		cpu_if->vgic_ap1r[2] = 0;
+		cpu_if->vgic_ap1r[3] = 0;
 	}
 
 	val = read_gicreg(ICC_SRE_EL2);
@@ -126,6 +208,8 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 	u64 val;
 	u32 max_lr_idx, nr_pri_bits;
+	u16 live_lrs = 0;
+	int i;
 
 	/*
 	 * VFIQEn is RES1 if ICC_SRE_EL1.SRE is 1. This causes a
@@ -138,66 +222,48 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	write_gicreg(cpu_if->vgic_sre, ICC_SRE_EL1);
 	isb();
 
-	write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
-	write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
-
 	val = read_gicreg(ICH_VTR_EL2);
 	max_lr_idx = vtr_to_max_lr_idx(val);
 	nr_pri_bits = vtr_to_nr_pri_bits(val);
 
-	switch (nr_pri_bits) {
-	case 7:
-		 write_gicreg(cpu_if->vgic_ap0r[3], ICH_AP0R3_EL2);
-		 write_gicreg(cpu_if->vgic_ap0r[2], ICH_AP0R2_EL2);
-	case 6:
-		 write_gicreg(cpu_if->vgic_ap0r[1], ICH_AP0R1_EL2);
-	default:
-		 write_gicreg(cpu_if->vgic_ap0r[0], ICH_AP0R0_EL2);
+	for (i = 0; i <= max_lr_idx; i++) {
+		if (cpu_if->vgic_lr[i] & ICH_LR_STATE)
+			live_lrs |= (1 << i);
 	}
 
-	switch (nr_pri_bits) {
-	case 7:
-		 write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
-		 write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
-	case 6:
-		 write_gicreg(cpu_if->vgic_ap1r[1], ICH_AP1R1_EL2);
-	default:
-		 write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
-	}
+	write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
 
-	switch (max_lr_idx) {
-	case 15:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(15)], ICH_LR15_EL2);
-	case 14:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(14)], ICH_LR14_EL2);
-	case 13:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(13)], ICH_LR13_EL2);
-	case 12:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(12)], ICH_LR12_EL2);
-	case 11:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(11)], ICH_LR11_EL2);
-	case 10:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(10)], ICH_LR10_EL2);
-	case 9:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(9)], ICH_LR9_EL2);
-	case 8:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(8)], ICH_LR8_EL2);
-	case 7:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(7)], ICH_LR7_EL2);
-	case 6:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(6)], ICH_LR6_EL2);
-	case 5:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(5)], ICH_LR5_EL2);
-	case 4:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(4)], ICH_LR4_EL2);
-	case 3:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(3)], ICH_LR3_EL2);
-	case 2:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(2)], ICH_LR2_EL2);
-	case 1:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(1)], ICH_LR1_EL2);
-	case 0:
-		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(0)], ICH_LR0_EL2);
+	if (live_lrs) {
+		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
+
+		switch (nr_pri_bits) {
+		case 7:
+			write_gicreg(cpu_if->vgic_ap0r[3], ICH_AP0R3_EL2);
+			write_gicreg(cpu_if->vgic_ap0r[2], ICH_AP0R2_EL2);
+		case 6:
+			write_gicreg(cpu_if->vgic_ap0r[1], ICH_AP0R1_EL2);
+		default:
+			write_gicreg(cpu_if->vgic_ap0r[0], ICH_AP0R0_EL2);
+		}
+
+		switch (nr_pri_bits) {
+		case 7:
+			write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
+			write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
+		case 6:
+			write_gicreg(cpu_if->vgic_ap1r[1], ICH_AP1R1_EL2);
+		default:
+			write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
+		}
+
+		for (i = 0; i <= max_lr_idx; i++) {
+			val = 0;
+
+			if (live_lrs & (1 << i))
+				val = cpu_if->vgic_lr[i];
+
+			__gic_v3_set_lr(val, i);
+		}
 	}
 
 	/*
@@ -207,6 +273,7 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	 */
 	isb();
 	dsb(sy);
+	vcpu->arch.vgic_cpu.live_lrs = live_lrs;
 
 	/*
 	 * Prevent the guest from touching the GIC system registers if
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index f473fd6..281caf8 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -279,12 +279,6 @@ struct vgic_v2_cpu_if {
 	u32		vgic_lr[VGIC_V2_MAX_LRS];
 };
 
-/*
- * LRs are stored in reverse order in memory. make sure we index them
- * correctly.
- */
-#define VGIC_V3_LR_INDEX(lr)		(VGIC_V3_MAX_LRS - 1 - lr)
-
 struct vgic_v3_cpu_if {
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 	u32		vgic_hcr;
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 453eafd..11b5ff6 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -42,7 +42,7 @@ static u32 ich_vtr_el2;
 static struct vgic_lr vgic_v3_get_lr(const struct kvm_vcpu *vcpu, int lr)
 {
 	struct vgic_lr lr_desc;
-	u64 val = vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[VGIC_V3_LR_INDEX(lr)];
+	u64 val = vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr];
 
 	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
 		lr_desc.irq = val & ICH_LR_VIRTUALID_MASK;
@@ -106,7 +106,7 @@ static void vgic_v3_set_lr(struct kvm_vcpu *vcpu, int lr,
 		lr_val |= ((u64)lr_desc.hwirq) << ICH_LR_PHYS_ID_SHIFT;
 	}
 
-	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[VGIC_V3_LR_INDEX(lr)] = lr_val;
+	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr] = lr_val;
 
 	if (!(lr_desc.state & LR_STATE_MASK))
 		vcpu->arch.vgic_cpu.vgic_v3.vgic_elrsr |= (1U << lr);
-- 
2.1.4
