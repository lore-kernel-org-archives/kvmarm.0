From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v2 6/6] KVM: arm/arm64: vgic: Allow configuration of interrupt
 groups
Date: Wed,  4 Jul 2018 11:38:20 +0200
Message-ID: <1530697100-22419-7-git-send-email-christoffer.dall@arm.com>
References: <1530697100-22419-1-git-send-email-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0225249FA8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Jul 2018 05:27:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A2J-y+A0teuG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Jul 2018 05:26:46 -0400 (EDT)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04hn0214.outbound.protection.outlook.com [104.47.14.214])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53F374A0ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Jul 2018 05:26:26 -0400 (EDT)
In-Reply-To: <1530697100-22419-1-git-send-email-christoffer.dall@arm.com>
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

Implement the required MMIO accessors for GICv2 and GICv3 for the
IGROUPR distributor and redistributor registers.

This can allow guests to change behavior compared to running on previous
versions of KVM, but only to align with the architecture and hardware
implementations.

This also allows userspace to configure the groups for interrupts.  Note
that this potentially results in GICv2 guests not receiving interrupts
after migration if migrating from an older kernel that exposes GICv2
interrupts as group 1.

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
I implemented (but stashed) a version of this which predicated the
behavior based on the value of GICD_IIDR revision field, falling back to
ignoring writes and resetting GICv2 groups to 0 if the guest wrote a
revision less than 2.  However, current QEMU implementations simply
don't write the GICD_IIDR, so this doesn't help at all without changing
QEMU anyhow.

The only actual fix I can see here to work around the problem in the
kernel is to require an opt-in to allow restoring groups from userspace,
but that's a lot of logic to support cross-kernel version migration.

Question: Do we expect that cross-kernel version migration is a critical
feature that people really expect to work, and do we actually have
examples of catering to this in the kernel elsewhere?  (Also, how would
then that relate to the whole 'adding a new sysreg breaks migration'
situation?)

 virt/kvm/arm/vgic/vgic-init.c    |  2 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  4 +++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 11 +++++++++--
 virt/kvm/arm/vgic/vgic-mmio.c    | 38 ++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    |  6 ++++++
 5 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index a7c19cd..c0c0b88 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -313,7 +313,7 @@ int vgic_init(struct kvm *kvm)

        vgic_debug_init(kvm);

-       dist->implementation_rev = 1;
+       dist->implementation_rev = 2;
        dist->initialized = true;

 out:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index db646f1..a7f09b5 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -26,6 +26,8 @@
  * The Revision field in the IIDR have the following meanings:
  *
  * Revision 1: Report GICv2 interrupts as group 0 instead of group 1
+ * Revision 2: Interrupt groups are guest-configurable and signaled using
+ *            their configured groups.
  */

 static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
@@ -371,7 +373,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
                vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
-               vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 1,
+               vgic_mmio_read_group, vgic_mmio_write_group, NULL, NULL, 1,
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
                vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index ebe10a0..49df2a1 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -59,6 +59,13 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
        return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
 }

+/*
+ * The Revision field in the IIDR have the following meanings:
+ *
+ * Revision 2: Interrupt groups are guest-configurable and signaled using
+ *            their configured groups.
+ */
+
 static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
                                            gpa_t addr, unsigned int len)
 {
@@ -454,7 +461,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
                vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
-               vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
+               vgic_mmio_read_group, vgic_mmio_write_group, NULL, NULL, 1,
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
                vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
@@ -527,7 +534,7 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {

 static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
        REGISTER_DESC_WITH_LENGTH(GICR_IGROUPR0,
-               vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
+               vgic_mmio_read_group, vgic_mmio_write_group, 4,
                VGIC_ACCESS_32bit),
        REGISTER_DESC_WITH_LENGTH(GICR_ISENABLER0,
                vgic_mmio_read_enable, vgic_mmio_write_senable, 4,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index ff9655c..ae31bd0 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -40,6 +40,44 @@ void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
        /* Ignore */
 }

+unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu,
+                                  gpa_t addr, unsigned int len)
+{
+       u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+       u32 value = 0;
+       int i;
+
+       /* Loop over all IRQs affected by this read */
+       for (i = 0; i < len * 8; i++) {
+               struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+               if (irq->group)
+                       value |= BIT(i);
+
+               vgic_put_irq(vcpu->kvm, irq);
+       }
+
+       return value;
+}
+
+void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
+                          unsigned int len, unsigned long val)
+{
+       u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
+       int i;
+       unsigned long flags;
+
+       for (i = 0; i < len * 8; i++) {
+               struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+               spin_lock_irqsave(&irq->irq_lock, flags);
+               irq->group = !!(val & BIT(i));
+               vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+
+               vgic_put_irq(vcpu->kvm, irq);
+       }
+}
+
 /*
  * Read accesses to both GICD_ICENABLER and GICD_ISENABLER return the value
  * of the enabled bit, so there is only one function for both here.
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 5693f6df..1079862 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -134,6 +134,12 @@ unsigned long vgic_mmio_read_rao(struct kvm_vcpu *vcpu,
 void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
                        unsigned int len, unsigned long val);

+unsigned long vgic_mmio_read_group(struct kvm_vcpu *vcpu, gpa_t addr,
+                                  unsigned int len);
+
+void vgic_mmio_write_group(struct kvm_vcpu *vcpu, gpa_t addr,
+                          unsigned int len, unsigned long val);
+
 unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
                                    gpa_t addr, unsigned int len);

--
2.7.4

IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
