From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/12] KVM: arm64: add active register handling to GICv3 emulation as well
Date: Fri, 19 Jun 2015 13:53:06 +0100
Message-ID: <1434718396-13110-3-git-send-email-marc.zyngier@arm.com>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Firo Yang <firogm@gmail.com>, Tiejun Chen <tiejun.chen@intel.com>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Commit 47a98b15ba7c ("arm/arm64: KVM: support for un-queuing active
IRQs") introduced handling of the GICD_I[SC]ACTIVER registers,
but only for the GICv2 emulation. For the sake of completeness and
as this is a pre-requisite for save/restore of the GICv3 distributor
state, we should also emulate their handling in the distributor and
redistributor frames of an emulated GICv3.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic-v3-emul.c | 54 +++++++++++++++++++++++++++++++++++++++++----
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
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe kvm" in
