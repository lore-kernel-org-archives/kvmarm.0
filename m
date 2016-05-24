From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 55/59] KVM: arm/arm64: vgic-new: Add vgic_v2/v3_enable
Date: Tue, 24 May 2016 11:09:49 +0200
Message-ID: <1464080993-10884-56-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

Enable the VGIC operation by properly initialising the registers
in the hypervisor GIC interface.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v2.c | 11 ++++++++++-
 virt/kvm/arm/vgic/vgic-v3.c | 23 ++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 1fe031b..8ad42c2 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -206,9 +206,18 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 			GICH_VMCR_PRIMASK_SHIFT;
 }
 
-/* not yet implemented */
 void vgic_v2_enable(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * By forcing VMCR to zero, the GIC will restore the binary
+	 * points to their reset values. Anything else resets to zero
+	 * anyway.
+	 */
+	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = 0;
+	vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr = ~0;
+
+	/* Get the show on the road... */
+	vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr = GICH_HCR_EN;
 }
 
 /* check for overlapping regions and for regions crossing the end of memory */
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 637ff2b..336a461 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -186,9 +186,30 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
 }
 
-/* not yet implemented */
 void vgic_v3_enable(struct kvm_vcpu *vcpu)
 {
+	struct vgic_v3_cpu_if *vgic_v3 = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	/*
+	 * By forcing VMCR to zero, the GIC will restore the binary
+	 * points to their reset values. Anything else resets to zero
+	 * anyway.
+	 */
+	vgic_v3->vgic_vmcr = 0;
+	vgic_v3->vgic_elrsr = ~0;
+
+	/*
+	 * If we are emulating a GICv3, we do it in an non-GICv2-compatible
+	 * way, so we force SRE to 1 to demonstrate this to the guest.
+	 * This goes with the spec allowing the value to be RAO/WI.
+	 */
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+		vgic_v3->vgic_sre = ICC_SRE_EL1_SRE;
+	else
+		vgic_v3->vgic_sre = 0;
+
+	/* Get the show on the road... */
+	vgic_v3->vgic_hcr = ICH_HCR_EN;
 }
 
 /* check for overlapping regions and for regions crossing the end of memory */
-- 
2.1.2.330.g565301e.dirty

