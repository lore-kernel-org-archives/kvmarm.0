From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 27/59] KVM: arm/arm64: vgic-new: Add ENABLE registers handlers
Date: Tue, 24 May 2016 11:09:21 +0200
Message-ID: <1464080993-10884-28-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EB7D49BA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r7JxCB2C+fYw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:55 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A114F49BFF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:50 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id a136so62256534wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:23 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

As the enable register handlers are shared between the v2 and v3
emulation, their implementation goes into vgic-mmio.c, to be easily
referenced from the v3 emulation as well later.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  4 +--
 virt/kvm/arm/vgic/vgic-mmio.c    | 56 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    | 11 ++++++++
 3 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index d812c93..d5355b5 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -72,10 +72,10 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_rao, vgic_mmio_write_wi, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		vgic_mmio_read_enable, vgic_mmio_write_senable, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 1a97765..32ed8db 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -39,6 +39,62 @@ void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
 	/* Ignore */
 }
 
+/*
+ * Read accesses to both GICD_ICENABLER and GICD_ISENABLER return the value
+ * of the enabled bit, so there is only one function for both here.
+ */
+unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
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
+		if (irq->enabled)
+			value |= (1U << i);
+	}
+
+	return value;
+}
+
+void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
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
+		irq->enabled = true;
+		vgic_queue_irq_unlock(vcpu->kvm, irq);
+	}
+}
+
+void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
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
+		irq->enabled = false;
+
+		spin_unlock(&irq->irq_lock);
+	}
+}
+
 static int match_region(const void *key, const void *elt)
 {
 	const unsigned int offset = (unsigned long)key;
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 5b928d4..57e19fe 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -96,6 +96,17 @@ unsigned long vgic_mmio_read_rao(struct kvm_vcpu *vcpu,
 void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
 			unsigned int len, unsigned long val);
 
+unsigned long vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len);
+
+void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
+			     gpa_t addr, unsigned int len,
+			     unsigned long val);
+
+void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
+			     gpa_t addr, unsigned int len,
+			     unsigned long val);
+
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
 #endif
-- 
2.1.2.330.g565301e.dirty
