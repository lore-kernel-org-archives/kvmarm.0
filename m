From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 05/27] KVM: arm/arm64: vITS: Add MSI translation helpers
Date: Mon, 13 Nov 2017 10:17:30 +0100
Message-ID: <20171113091752.10663-6-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4514D49DAE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:15:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6WklQm3G2LZ8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:15:51 -0500 (EST)
Received: from mail-wr0-f193.google.com (mail-wr0-f193.google.com
 [209.85.128.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0DA349DA4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:15:50 -0500 (EST)
Received: by mail-wr0-f193.google.com with SMTP id l22so13754897wrc.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:18:01 -0800 (PST)
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The whole MSI injection process is fairly monolithic. An MSI write
gets turned into an injected LPI in one swift go. But this is actually
a more fine-grained process:

- First, a virtual ITS gets selected using the doorbell address
- Then the DevID/EventID pair gets translated into an LPI
- Finally the LPI is injected

Since the GICv4 code needs the first two steps in order to match
an IRQ routing entry to an LPI, let's expose them as helpers,
and refactor the existing code to use them

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 95 +++++++++++++++++++++++++-------------------
 virt/kvm/arm/vgic/vgic.h     |  4 ++
 2 files changed, 58 insertions(+), 41 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 40791c121710..1de4e68ef1b6 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -505,19 +505,11 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 	return 0;
 }
 
-/*
- * Find the target VCPU and the LPI number for a given devid/eventid pair
- * and make this IRQ pending, possibly injecting it.
- * Must be called with the its_lock mutex held.
- * Returns 0 on success, a positive error value for any ITS mapping
- * related errors and negative error values for generic errors.
- */
-static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
-				u32 devid, u32 eventid)
+int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
+			 u32 devid, u32 eventid, struct vgic_irq **irq)
 {
 	struct kvm_vcpu *vcpu;
 	struct its_ite *ite;
-	unsigned long flags;
 
 	if (!its->enabled)
 		return -EBUSY;
@@ -533,26 +525,61 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 	if (!vcpu->arch.vgic_cpu.lpis_enabled)
 		return -EBUSY;
 
-	spin_lock_irqsave(&ite->irq->irq_lock, flags);
-	ite->irq->pending_latch = true;
-	vgic_queue_irq_unlock(kvm, ite->irq, flags);
-
+	*irq = ite->irq;
 	return 0;
 }
 
-static struct vgic_io_device *vgic_get_its_iodev(struct kvm_io_device *dev)
+struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi)
 {
+	u64 address;
+	struct kvm_io_device *kvm_io_dev;
 	struct vgic_io_device *iodev;
 
-	if (dev->ops != &kvm_io_gic_ops)
-		return NULL;
+	if (!vgic_has_its(kvm))
+		return ERR_PTR(-ENODEV);
 
-	iodev = container_of(dev, struct vgic_io_device, dev);
+	if (!(msi->flags & KVM_MSI_VALID_DEVID))
+		return ERR_PTR(-EINVAL);
+
+	address = (u64)msi->address_hi << 32 | msi->address_lo;
+
+	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
+	if (!kvm_io_dev)
+		return ERR_PTR(-EINVAL);
 
+	if (kvm_io_dev->ops != &kvm_io_gic_ops)
+		return ERR_PTR(-EINVAL);
+
+	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
 	if (iodev->iodev_type != IODEV_ITS)
-		return NULL;
+		return ERR_PTR(-EINVAL);
+
+	return iodev->its;
+}
+
+/*
+ * Find the target VCPU and the LPI number for a given devid/eventid pair
+ * and make this IRQ pending, possibly injecting it.
+ * Must be called with the its_lock mutex held.
+ * Returns 0 on success, a positive error value for any ITS mapping
+ * related errors and negative error values for generic errors.
+ */
+static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
+				u32 devid, u32 eventid)
+{
+	struct vgic_irq *irq = NULL;
+	unsigned long flags;
+	int err;
+
+	err = vgic_its_resolve_lpi(kvm, its, devid, eventid, &irq);
+	if (err)
+		return err;
 
-	return iodev;
+	spin_lock_irqsave(&irq->irq_lock, flags);
+	irq->pending_latch = true;
+	vgic_queue_irq_unlock(kvm, irq, flags);
+
+	return 0;
 }
 
 /*
@@ -563,30 +590,16 @@ static struct vgic_io_device *vgic_get_its_iodev(struct kvm_io_device *dev)
  */
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
 {
-	u64 address;
-	struct kvm_io_device *kvm_io_dev;
-	struct vgic_io_device *iodev;
+	struct vgic_its *its;
 	int ret;
 
-	if (!vgic_has_its(kvm))
-		return -ENODEV;
-
-	if (!(msi->flags & KVM_MSI_VALID_DEVID))
-		return -EINVAL;
-
-	address = (u64)msi->address_hi << 32 | msi->address_lo;
+	its = vgic_msi_to_its(kvm, msi);
+	if (IS_ERR(its))
+		return PTR_ERR(its);
 
-	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
-	if (!kvm_io_dev)
-		return -EINVAL;
-
-	iodev = vgic_get_its_iodev(kvm_io_dev);
-	if (!iodev)
-		return -EINVAL;
-
-	mutex_lock(&iodev->its->its_lock);
-	ret = vgic_its_trigger_msi(kvm, iodev->its, msi->devid, msi->data);
-	mutex_unlock(&iodev->its->its_lock);
+	mutex_lock(&its->its_lock);
+	ret = vgic_its_trigger_msi(kvm, its, msi->devid, msi->data);
+	mutex_unlock(&its->its_lock);
 
 	if (ret < 0)
 		return ret;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 4f8aecb07ae6..0ac85045c0c7 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -237,4 +237,8 @@ static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 	}
 }
 
+int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
+			 u32 devid, u32 eventid, struct vgic_irq **irq);
+struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
+
 #endif
-- 
2.14.2
