From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 28/57] KVM: arm/arm64: vgic-new: Add ACTIVE registers
 handlers
Date: Thu, 19 May 2016 19:08:07 +0100
Message-ID: <1463681316-23039-29-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7474B49B9C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:05:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J5lCNifZYHQs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2016 14:05:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE0E049B80
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:05:34 -0400 (EDT)
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
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
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The active register handlers are shared between the v2 and v3
emulation, so their implementation goes into vgic-mmio.c, to be
easily referenced from the v3 emulation as well later.
Since activation/deactivation of an interrupt may happen entirely
in the guest without it ever exiting, we need some extra logic to
properly track the active state.
For clearing the active state, we basically have to halt the guest to
make sure this is properly propagated into the respective VCPUs.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog RFC..v1:
- handling queueing in write handler
- remove IRQ lock from read handler

Changelog v1 .. v2:
- adapt to new MMIO framework

Changelog v3 .. v4:
- specify accessor width
- use IRQ number accessor macro
- drop elaborate write_sactive handler and use new vgic_queue_irq_unlock()
- properly emulate clear active by halting the guest (Christoffer)
- replace extract_bytes() with simple return

Changelog v4 .. v5:
- remove irq->vcpu condition from set-active early bail-out check
- fix commit message

 virt/kvm/arm/vgic/vgic-mmio-v2.c |  4 +-
 virt/kvm/arm/vgic/vgic-mmio.c    | 81 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    | 10 +++++
 3 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index c13a708..12e101b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -84,10 +84,10 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		vgic_mmio_read_active, vgic_mmio_write_sactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		vgic_mmio_read_active, vgic_mmio_write_cactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index d8dc8f6..79a4622 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -155,6 +155,87 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 	}
 }
 
+unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	u32 value = 0;
+	int i;
+
+	/* Loop over all IRQs affected by this read */
+	for (i = 0; i < len * 8; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		if (irq->active)
+			value |= (1U << i);
+	}
+
+	return value;
+}
+
+void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
+			     gpa_t addr, unsigned int len,
+			     unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+
+	kvm_arm_halt_guest(vcpu->kvm);
+	for_each_set_bit(i, &val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+		/*
+		 * If this virtual IRQ was written into a list register, we
+		 * have to make sure the CPU that runs the VCPU thread has
+		 * synced back LR state to the struct vgic_irq.  We can only
+		 * know this for sure, when either this irq is not assigned to
+		 * anyone's AP list anymore, or the VCPU thread is not
+		 * running on any CPUs.
+		 *
+		 * In the opposite case, we know the VCPU thread may be on its
+		 * way back from the guest and still has to sync back this
+		 * IRQ, so we release and re-acquire the spin_lock to let the
+		 * other thread sync back the IRQ.
+		 */
+		while (irq->vcpu && /* IRQ may have state in an LR somewhere */
+		       irq->vcpu->cpu != -1) /* VCPU thread is running */
+			cond_resched_lock(&irq->irq_lock);
+
+		irq->active = false;
+		spin_unlock(&irq->irq_lock);
+	}
+	kvm_arm_resume_guest(vcpu->kvm);
+}
+
+void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
+			     gpa_t addr, unsigned int len,
+			     unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+	int i;
+
+	for_each_set_bit(i, &val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+
+		/*
+		 * If the IRQ was already active or there is no target VCPU
+		 * assigned at the moment, then just proceed.
+		 */
+		if (irq->active || !irq->target_vcpu) {
+			irq->active = true;
+
+			spin_unlock(&irq->irq_lock);
+			continue;
+		}
+
+		irq->active = true;
+		vgic_queue_irq_unlock(vcpu->kvm, irq);
+	}
+}
+
 static int match_region(const void *key, const void *elt)
 {
 	const unsigned int offset = (unsigned long)key;
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index b18120d..90146c7 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -118,6 +118,16 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val);
 
+unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len);
+
+void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
+			     gpa_t addr, unsigned int len,
+			     unsigned long val);
+
+void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
+			     gpa_t addr, unsigned int len,
+			     unsigned long val);
 
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
-- 
2.8.2
