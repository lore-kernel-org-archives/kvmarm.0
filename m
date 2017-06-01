From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 02/25] KVM: arm/arm64: vgic-v3: Add accessors for the ICH_APxRn_EL2 registers
Date: Thu,  1 Jun 2017 11:20:54 +0100
Message-ID: <20170601102117.17750-3-marc.zyngier@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170601102117.17750-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

As we're about to access the Active Priority registers a lot more,
let's define accessors that take the register number as a parameter.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 116 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 100 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 32c3295929b0..990d9d1e85d0 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -118,6 +118,90 @@ static void __hyp_text __gic_v3_set_lr(u64 val, int lr)
 	}
 }
 
+static void __hyp_text __vgic_v3_write_ap0rn(u32 val, int n)
+{
+	switch (n) {
+	case 0:
+		write_gicreg(val, ICH_AP0R0_EL2);
+		break;
+	case 1:
+		write_gicreg(val, ICH_AP0R1_EL2);
+		break;
+	case 2:
+		write_gicreg(val, ICH_AP0R2_EL2);
+		break;
+	case 3:
+		write_gicreg(val, ICH_AP0R3_EL2);
+		break;
+	}
+}
+
+static void __hyp_text __vgic_v3_write_ap1rn(u32 val, int n)
+{
+	switch (n) {
+	case 0:
+		write_gicreg(val, ICH_AP1R0_EL2);
+		break;
+	case 1:
+		write_gicreg(val, ICH_AP1R1_EL2);
+		break;
+	case 2:
+		write_gicreg(val, ICH_AP1R2_EL2);
+		break;
+	case 3:
+		write_gicreg(val, ICH_AP1R3_EL2);
+		break;
+	}
+}
+
+static u32 __hyp_text __vgic_v3_read_ap0rn(int n)
+{
+	u32 val;
+
+	switch (n) {
+	case 0:
+		val = read_gicreg(ICH_AP0R0_EL2);
+		break;
+	case 1:
+		val = read_gicreg(ICH_AP0R1_EL2);
+		break;
+	case 2:
+		val = read_gicreg(ICH_AP0R2_EL2);
+		break;
+	case 3:
+		val = read_gicreg(ICH_AP0R3_EL2);
+		break;
+	default:
+		unreachable();
+	}
+
+	return val;
+}
+
+static u32 __hyp_text __vgic_v3_read_ap1rn(int n)
+{
+	u32 val;
+
+	switch (n) {
+	case 0:
+		val = read_gicreg(ICH_AP1R0_EL2);
+		break;
+	case 1:
+		val = read_gicreg(ICH_AP1R1_EL2);
+		break;
+	case 2:
+		val = read_gicreg(ICH_AP1R2_EL2);
+		break;
+	case 3:
+		val = read_gicreg(ICH_AP1R3_EL2);
+		break;
+	default:
+		unreachable();
+	}
+
+	return val;
+}
+
 void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
@@ -154,22 +238,22 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 
 		switch (nr_pre_bits) {
 		case 7:
-			cpu_if->vgic_ap0r[3] = read_gicreg(ICH_AP0R3_EL2);
-			cpu_if->vgic_ap0r[2] = read_gicreg(ICH_AP0R2_EL2);
+			cpu_if->vgic_ap0r[3] = __vgic_v3_read_ap0rn(3);
+			cpu_if->vgic_ap0r[2] = __vgic_v3_read_ap0rn(2);
 		case 6:
-			cpu_if->vgic_ap0r[1] = read_gicreg(ICH_AP0R1_EL2);
+			cpu_if->vgic_ap0r[1] = __vgic_v3_read_ap0rn(1);
 		default:
-			cpu_if->vgic_ap0r[0] = read_gicreg(ICH_AP0R0_EL2);
+			cpu_if->vgic_ap0r[0] = __vgic_v3_read_ap0rn(0);
 		}
 
 		switch (nr_pre_bits) {
 		case 7:
-			cpu_if->vgic_ap1r[3] = read_gicreg(ICH_AP1R3_EL2);
-			cpu_if->vgic_ap1r[2] = read_gicreg(ICH_AP1R2_EL2);
+			cpu_if->vgic_ap1r[3] = __vgic_v3_read_ap1rn(3);
+			cpu_if->vgic_ap1r[2] = __vgic_v3_read_ap1rn(2);
 		case 6:
-			cpu_if->vgic_ap1r[1] = read_gicreg(ICH_AP1R1_EL2);
+			cpu_if->vgic_ap1r[1] = __vgic_v3_read_ap1rn(1);
 		default:
-			cpu_if->vgic_ap1r[0] = read_gicreg(ICH_AP1R0_EL2);
+			cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
 		}
 	} else {
 		cpu_if->vgic_elrsr = 0xffff;
@@ -224,22 +308,22 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 
 		switch (nr_pre_bits) {
 		case 7:
-			write_gicreg(cpu_if->vgic_ap0r[3], ICH_AP0R3_EL2);
-			write_gicreg(cpu_if->vgic_ap0r[2], ICH_AP0R2_EL2);
+			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[3], 3);
+			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[2], 2);
 		case 6:
-			write_gicreg(cpu_if->vgic_ap0r[1], ICH_AP0R1_EL2);
+			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[1], 1);
 		default:
-			write_gicreg(cpu_if->vgic_ap0r[0], ICH_AP0R0_EL2);
+			__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[0], 0);
 		}
 
 		switch (nr_pre_bits) {
 		case 7:
-			write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
-			write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
+			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[3], 3);
+			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[2], 2);
 		case 6:
-			write_gicreg(cpu_if->vgic_ap1r[1], ICH_AP1R1_EL2);
+			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[1], 1);
 		default:
-			write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
+			__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[0], 0);
 		}
 
 		for (i = 0; i < used_lrs; i++)
-- 
2.11.0
