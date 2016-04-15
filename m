From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 18/45] KVM: arm/arm64: vgic-new: Add ACTIVE registers handlers
Date: Fri, 15 Apr 2016 18:11:29 +0100
Message-ID: <1460740316-8755-19-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Changelog RFC..v1:
- handling queueing in write handler
- remove IRQ lock from read handler
---
 virt/kvm/arm/vgic/vgic_mmio.c | 143 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 141 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index 8e1e051..3c3dbce 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -294,6 +294,145 @@ static int vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int vgic_mmio_read_active(struct kvm_vcpu *vcpu,
+				 struct kvm_io_device *dev,
+				 gpa_t addr, int len, void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	u32 intid = (addr & 0x7f) * 8;
+	u32 value = 0;
+	int i;
+
+	if (iodev->redist_vcpu)
+		vcpu = iodev->redist_vcpu;
+
+	/* Loop over all IRQs affected by this read */
+	for (i = 0; i < len * 8; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		if (irq->active)
+			value |= (1U << i);
+	}
+
+	write_mask32(value, addr & 3, len, val);
+	return 0;
+}
+
+static int vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
+				   struct kvm_io_device *dev,
+				   gpa_t addr, int len, const void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	u32 intid = (addr & 0x7f) * 8;
+	int i;
+
+	if (iodev->redist_vcpu)
+		vcpu = iodev->redist_vcpu;
+
+	for_each_set_bit(i, val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+
+		irq->active = false;
+
+		/*
+		 * Christoffer wrote:
+		 * The question is what to do if the vcpu for this irq is
+		 * running and the LR there has the active bit set, then we'll
+		 * overwrite this change when we fold the LR state back into
+		 * the vgic_irq struct.
+		 *
+		 * Since I expect this to be extremely rare, one option is to
+		 * force irq->vcpu to exit (if non-null) and then do you
+		 * thing here after you've confirm it has exited while holding
+		 * some lock preventing it from re-entering again.
+		 * Slightly crazy.
+		 *
+		 * The alternative is to put a big fat comment nothing that
+		 * this is non-supported bad race, and wait until someone
+		 * submits a bug report relating to this...
+		 */
+
+		spin_unlock(&irq->irq_lock);
+	}
+	return 0;
+}
+
+static int vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
+				   struct kvm_io_device *dev,
+				   gpa_t addr, int len, const void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	u32 intid = (addr & 0x7f) * 8;
+	int i;
+
+	if (iodev->redist_vcpu)
+		vcpu = iodev->redist_vcpu;
+
+	for_each_set_bit(i, val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+
+		/* As this is a special case, we can't use the
+		 * vgic_queue_irq_unlock() function to put this on a VCPU.
+		 * So deal with this here explicitly unless the IRQs was
+		 * already active, it was on a VCPU before or there is no
+		 * target VCPU assigned at the moment.
+		 */
+		if (irq->active || irq->vcpu || !irq->target_vcpu) {
+			irq->active = true;
+
+			spin_unlock(&irq->irq_lock);
+			continue;
+		}
+
+		spin_unlock(&irq->irq_lock);
+retry:
+		vcpu = irq->target_vcpu;
+
+		spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
+		spin_lock(&irq->irq_lock);
+
+		/*
+		 * Recheck after dropping the IRQ lock to see if we should
+		 * still care about queueing it.
+		 */
+		if (irq->active || irq->vcpu) {
+			irq->active = true;
+
+			spin_unlock(&irq->irq_lock);
+			spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+
+			continue;
+		}
+
+		/* Did the target VCPU change while we had the lock dropped? */
+		if (vcpu != irq->target_vcpu) {
+			spin_unlock(&irq->irq_lock);
+			spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+
+			goto retry;
+		}
+
+		/* Now queue the IRQ to the VCPU's ap_list. */
+		list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
+		irq->vcpu = vcpu;
+
+		irq->active = true;
+
+		spin_unlock(&irq->irq_lock);
+		spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+
+		kvm_vcpu_kick(vcpu);
+	}
+	return 0;
+}
+
 static int vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
 				   struct kvm_io_device *dev,
 				   gpa_t addr, int len, void *val)
@@ -352,9 +491,9 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
+		vgic_mmio_read_active, vgic_mmio_write_sactive, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
+		vgic_mmio_read_active, vgic_mmio_write_cactive, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, 8),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
-- 
2.7.3

