From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] KVM: arm64: add active register handling to GICv3 emulation
 as well
Date: Thu, 23 Apr 2015 20:01:53 +0100
Message-ID: <1429815713-13684-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93A384E5C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 14:53:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qqQpBcescEBj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2015 14:53:42 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BE904E59D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2015 14:53:41 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Commit 47a98b15ba7c ("arm/arm64: KVM: support for un-queuing active
IRQs") introduced handling of the GICD_I[SC]ACTIVER registers,
but only for the GICv2 emulation. For the sake of completeness and
as this is a pre-requisite for save/restore of the GICv3 distributor
state, we should also emulate their handling in the distributor and
redistributor frames of an emulated GICv3.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic-v3-emul.c |   54 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 50 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index e9c3a7a..2b369de 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -173,6 +173,32 @@ static bool handle_mmio_clear_pending_reg_dist(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static bool handle_mmio_set_active_reg_dist(struct kvm_vcpu *vcpu,
+					    struct kvm_exit_mmio *mmio,
+					    phys_addr_t offset)
+{
+	if (likely(offset >= VGIC_NR_PRIVATE_IRQS / 8))
+		return vgic_handle_set_active_reg(vcpu->kvm, mmio, offset,
+						   vcpu->vcpu_id);
+
+	vgic_reg_access(mmio, NULL, offset,
+			ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
+	return false;
+}
+
+static bool handle_mmio_clear_active_reg_dist(struct kvm_vcpu *vcpu,
+					      struct kvm_exit_mmio *mmio,
+					      phys_addr_t offset)
+{
+	if (likely(offset >= VGIC_NR_PRIVATE_IRQS / 8))
+		return vgic_handle_clear_active_reg(vcpu->kvm, mmio, offset,
+						    vcpu->vcpu_id);
+
+	vgic_reg_access(mmio, NULL, offset,
+			ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
+	return false;
+}
+
 static bool handle_mmio_priority_reg_dist(struct kvm_vcpu *vcpu,
 					  struct kvm_exit_mmio *mmio,
 					  phys_addr_t offset)
@@ -428,13 +454,13 @@ static const struct vgic_io_range vgic_v3_dist_ranges[] = {
 		.base		= GICD_ISACTIVER,
 		.len		= 0x80,
 		.bits_per_irq	= 1,
-		.handle_mmio	= handle_mmio_raz_wi,
+		.handle_mmio	= handle_mmio_set_active_reg_dist,
 	},
 	{
 		.base		= GICD_ICACTIVER,
 		.len		= 0x80,
 		.bits_per_irq	= 1,
-		.handle_mmio	= handle_mmio_raz_wi,
+		.handle_mmio	= handle_mmio_clear_active_reg_dist,
 	},
 	{
 		.base		= GICD_IPRIORITYR,
@@ -561,6 +587,26 @@ static bool handle_mmio_clear_enable_reg_redist(struct kvm_vcpu *vcpu,
 				      ACCESS_WRITE_CLEARBIT);
 }
 
+static bool handle_mmio_set_active_reg_redist(struct kvm_vcpu *vcpu,
+					      struct kvm_exit_mmio *mmio,
+					      phys_addr_t offset)
+{
+	struct kvm_vcpu *redist_vcpu = mmio->private;
+
+	return vgic_handle_set_active_reg(vcpu->kvm, mmio, offset,
+					  redist_vcpu->vcpu_id);
+}
+
+static bool handle_mmio_clear_active_reg_redist(struct kvm_vcpu *vcpu,
+						struct kvm_exit_mmio *mmio,
+						phys_addr_t offset)
+{
+	struct kvm_vcpu *redist_vcpu = mmio->private;
+
+	return vgic_handle_clear_active_reg(vcpu->kvm, mmio, offset,
+					     redist_vcpu->vcpu_id);
+}
+
 static bool handle_mmio_set_pending_reg_redist(struct kvm_vcpu *vcpu,
 					       struct kvm_exit_mmio *mmio,
 					       phys_addr_t offset)
@@ -674,13 +720,13 @@ static const struct vgic_io_range vgic_redist_ranges[] = {
 		.base		= SGI_base(GICR_ISACTIVER0),
 		.len		= 0x04,
 		.bits_per_irq	= 1,
-		.handle_mmio	= handle_mmio_raz_wi,
+		.handle_mmio	= handle_mmio_set_active_reg_redist,
 	},
 	{
 		.base		= SGI_base(GICR_ICACTIVER0),
 		.len		= 0x04,
 		.bits_per_irq	= 1,
-		.handle_mmio	= handle_mmio_raz_wi,
+		.handle_mmio	= handle_mmio_clear_active_reg_redist,
 	},
 	{
 		.base		= SGI_base(GICR_IPRIORITYR0),
-- 
1.7.9.5
