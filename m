From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 13/37] KVM: arm/arm64: vgic: Keep track of implementation
 revision
Date: Mon, 13 Aug 2018 15:57:31 +0100
Message-ID: <20180813145755.16566-14-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E3074A21D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g1iWbQXvsE7W for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 10:59:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F39A4A1D8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 10:59:31 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

As we are about to tweak implementation aspects of the VGIC emulation,
while still preserving some level of backwards compatibility support,
add a field to keep track of the implementation revision field which is
reported to the VM and to userspace.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h           | 3 +++
 virt/kvm/arm/vgic/vgic-init.c    | 1 +
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 6 ++++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 6 ++++--
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index cfdd2484cc42..7e64c463ab4d 100644
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
index b71417913741..8b6fc45c42fe 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -298,6 +298,7 @@ int vgic_init(struct kvm *kvm)
 
 	vgic_debug_init(kvm);
 
+	dist->implementation_rev = 0;
 	dist->initialized = true;
 
 out:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index af44e569373a..f0c5351805b6 100644
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
index c03f42409b98..ebe10a015bfb 100644
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
2.18.0
