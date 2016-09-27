From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 15/50] arm64: KVM: vgic-v2: Add GICV access from HYP
Date: Tue, 27 Sep 2016 20:05:23 +0200
Message-ID: <20160927180558.14699-16-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Now that we have the necessary infrastructure to handle MMIO accesses
in HYP, perform the GICV access on behalf of the guest. This requires
checking that the access is strictly 32bit, properly aligned, and
falls within the expected range.

When all condition are satisfied, we perform the access and tell
the rest of the HYP code that the instruction has been correctly
emulated.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h        |  3 +++
 virt/kvm/arm/hyp/vgic-v2-sr.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8eb1501..bb46c03 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -50,6 +50,9 @@ struct vgic_global {
 	/* Physical address of vgic virtual cpu interface */
 	phys_addr_t		vcpu_base;
 
+	/* GICV mapping */
+	void __iomem		*vcpu_base_va;
+
 	/* virtual control interface mapping */
 	void __iomem		*vctrl_base;
 
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index 3e2a62e..a052f20 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -19,6 +19,7 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/kvm_host.h>
 
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
 static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
@@ -171,6 +172,44 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_ARM64
 bool __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
+	struct vgic_dist *vgic = &kvm->arch.vgic;
+	phys_addr_t fault_ipa;
+	void __iomem *addr;
+	int rd;
+
+	/* Build the full address */
+	fault_ipa  = kvm_vcpu_get_fault_ipa(vcpu);
+	fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
+
+	/* If not for GICV, move on */
+	if (fault_ipa <  vgic->vgic_cpu_base ||
+	    fault_ipa >= (vgic->vgic_cpu_base + KVM_VGIC_V2_CPU_SIZE))
 		return false;
+
+	/* Reject anything but a 32bit access */
+	if (kvm_vcpu_dabt_get_as(vcpu) != sizeof(u32))
+		return false;
+
+	/* Not aligned? Don't bother */
+	if (fault_ipa & 3)
+		return false;
+
+	rd = kvm_vcpu_dabt_get_rd(vcpu);
+	addr  = kern_hyp_va((kern_hyp_va(&kvm_vgic_global_state))->vcpu_base_va);
+	addr += fault_ipa - vgic->vgic_cpu_base;
+
+	if (kvm_vcpu_dabt_iswrite(vcpu)) {
+		u32 data = vcpu_data_guest_to_host(vcpu,
+						   vcpu_get_reg(vcpu, rd),
+						   sizeof(u32));
+		writel_relaxed(data, addr);
+	} else {
+		u32 data = readl_relaxed(addr);
+		vcpu_set_reg(vcpu, rd, vcpu_data_host_to_guest(vcpu, data,
+							       sizeof(u32)));
+	}
+
+	return true;
 }
 #endif
-- 
2.9.0

