From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v4 02/10] KVM: arm/arm64: vgic: Keep track of implementation
 revision
Date: Mon, 16 Jul 2018 15:06:19 +0200
Message-ID: <1531746387-7033-3-git-send-email-christoffer.dall@arm.com>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86D164A172
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 08:53:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NZ1pMzUGmihO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Jul 2018 08:53:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A084A11E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Jul 2018 08:53:41 -0400 (EDT)
In-Reply-To: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to tweak implementation aspects of the VGIC emulation,
while still preserving some level of backwards compatibility support,
add a field to keep track of the implementation revision field which is
reported to the VM and to userspace.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 include/kvm/arm_vgic.h           | 3 +++
 virt/kvm/arm/vgic/vgic-init.c    | 1 +
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 6 ++++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 6 ++++--
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index cfdd248..7e64c46 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -217,6 +217,9 @@ struct vgic_dist {
 	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
 	u32			vgic_model;
 
+	/* Implementation revision as reported in the GICD_IIDR */
+	u32			implementation_rev;
+
 	/* Do injected MSIs require an additional device ID? */
 	bool			msis_require_devid;
 
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index b714179..8b6fc45 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -298,6 +298,7 @@ int vgic_init(struct kvm *kvm)
 
 	vgic_debug_init(kvm);
 
+	dist->implementation_rev = 0;
 	dist->initialized = true;
 
 out:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index af44e569..f0c5351 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -25,19 +25,21 @@
 static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
 {
+	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
 	u32 value;
 
 	switch (addr & 0x0c) {
 	case GIC_DIST_CTRL:
-		value = vcpu->kvm->arch.vgic.enabled ? GICD_ENABLE : 0;
+		value = vgic->enabled ? GICD_ENABLE : 0;
 		break;
 	case GIC_DIST_CTR:
-		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+		value = vgic->nr_spis + VGIC_NR_PRIVATE_IRQS;
 		value = (value >> 5) - 1;
 		value |= (atomic_read(&vcpu->kvm->online_vcpus) - 1) << 5;
 		break;
 	case GIC_DIST_IIDR:
 		value = (PRODUCT_ID_KVM << GICD_IIDR_PRODUCT_ID_SHIFT) |
+			(vgic->implementation_rev << GICD_IIDR_REVISION_SHIFT) |
 			(IMPLEMENTER_ARM << GICD_IIDR_IMPLEMENTER_SHIFT);
 		break;
 	default:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index c03f424..ebe10a0 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -62,16 +62,17 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
 static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
 {
+	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
 	u32 value = 0;
 
 	switch (addr & 0x0c) {
 	case GICD_CTLR:
-		if (vcpu->kvm->arch.vgic.enabled)
+		if (vgic->enabled)
 			value |= GICD_CTLR_ENABLE_SS_G1;
 		value |= GICD_CTLR_ARE_NS | GICD_CTLR_DS;
 		break;
 	case GICD_TYPER:
-		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+		value = vgic->nr_spis + VGIC_NR_PRIVATE_IRQS;
 		value = (value >> 5) - 1;
 		if (vgic_has_its(vcpu->kvm)) {
 			value |= (INTERRUPT_ID_BITS_ITS - 1) << 19;
@@ -82,6 +83,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 		break;
 	case GICD_IIDR:
 		value = (PRODUCT_ID_KVM << GICD_IIDR_PRODUCT_ID_SHIFT) |
+			(vgic->implementation_rev << GICD_IIDR_REVISION_SHIFT) |
 			(IMPLEMENTER_ARM << GICD_IIDR_IMPLEMENTER_SHIFT);
 		break;
 	default:
-- 
2.7.4
