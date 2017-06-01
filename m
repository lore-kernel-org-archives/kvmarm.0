From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 05/25] KVM: arm64: vgic-v3: Add ICV_BPR1_EL1 handler
Date: Thu,  1 Jun 2017 11:20:57 +0100
Message-ID: <20170601102117.17750-6-marc.zyngier@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170601102117.17750-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a handler for reading/writing the guest's view of the ICC_BPR1_EL1
register, which is located in the ICH_VMCR_EL2.BPR1 field.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 51 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 943bf11252d9..6254eaf72a77 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -375,6 +375,51 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
 
 #ifdef CONFIG_ARM64
 
+static unsigned int __hyp_text __vgic_v3_get_bpr0(u32 vmcr)
+{
+	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
+}
+
+static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
+{
+	unsigned int bpr;
+
+	if (vmcr & ICH_VMCR_CBPR_MASK) {
+		bpr = __vgic_v3_get_bpr0(vmcr);
+		if (bpr < 7)
+			bpr++;
+	} else {
+		bpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
+	}
+
+	return bpr;
+}
+
+static void __hyp_text __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
+}
+
+static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	u64 val = vcpu_get_reg(vcpu, rt);
+	u8 bpr_min = 8 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
+
+	if (vmcr & ICH_VMCR_CBPR_MASK)
+		return;
+
+	/* Enforce BPR limiting */
+	if (val < bpr_min)
+		val = bpr_min;
+
+	val <<= ICH_VMCR_BPR1_SHIFT;
+	val &= ICH_VMCR_BPR1_MASK;
+	vmcr &= ~ICH_VMCR_BPR1_MASK;
+	vmcr |= val;
+
+	__vgic_v3_write_vmcr(vmcr);
+}
+
 int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	int rt;
@@ -397,6 +442,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
 
 	switch (sysreg) {
+	case SYS_ICC_BPR1_EL1:
+		if (is_read)
+			fn = __vgic_v3_read_bpr1;
+		else
+			fn = __vgic_v3_write_bpr1;
+		break;
 	default:
 		return 0;
 	}
-- 
2.11.0
