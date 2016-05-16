From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 53/56] KVM: arm/arm64: vgic-new: Add vgic_v2/v3_enable
Date: Mon, 16 May 2016 10:53:41 +0100
Message-ID: <1463392481-26583-54-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5DD349C03
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:52:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hks0oojlM-Jh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:52:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB89249B81
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:52:25 -0400 (EDT)
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
2.8.2
