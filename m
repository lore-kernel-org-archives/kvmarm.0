From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 36/52] KVM: arm/arm64: vITS: Add MSI translation helpers
Date: Wed, 28 Jun 2017 16:03:55 +0100
Message-ID: <20170628150411.15846-37-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 485A349C23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kXZga3nPfkZK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCD4949C08
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:29 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

The whole MSI injection process is fairly monolithic. An MSI write
gets turned into an injected LPI in one swift go. But this is actually
a more fine-grained process:

- First, a virtual ITS gets selected using the doorbell address
- Then the DevID/EventID pair gets translated into an LPI
- Finally the LPI is injected

Since the GICv4 code needs the first two steps in order to match
an IRQ routing entry to an LPI, let's expose them as helpers,
and refactor the existing code to use them

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 93 +++++++++++++++++++++++++-------------------
 virt/kvm/arm/vgic/vgic.h     |  4 ++
 2 files changed, 57 insertions(+), 40 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 2dff288b3a66..5fbcf9ea8886 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -504,15 +504,8 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
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
@@ -531,26 +524,60 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 	if (!vcpu->arch.vgic_cpu.lpis_enabled)
 		return -EBUSY;
 
-	spin_lock(&ite->irq->irq_lock);
-	ite->irq->pending_latch = true;
-	vgic_queue_irq_unlock(kvm, ite->irq);
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
 
-	return iodev;
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
+	int err;
+
+	err = vgic_its_resolve_lpi(kvm, its, devid, eventid, &irq);
+	if (err)
+		return err;
+
+	spin_lock(&irq->irq_lock);
+	irq->pending_latch = true;
+	vgic_queue_irq_unlock(kvm, irq);
+
+	return 0;
 }
 
 /*
@@ -561,30 +588,16 @@ static struct vgic_io_device *vgic_get_its_iodev(struct kvm_io_device *dev)
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
-
-	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
-	if (!kvm_io_dev)
-		return -EINVAL;
+	its = vgic_msi_to_its(kvm, msi);
+	if (IS_ERR(its))
+		return PTR_ERR(its);
 
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
index da254ae29aec..3002b72d938b 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -225,4 +225,8 @@ int vgic_debug_destroy(struct kvm *kvm);
 bool lock_all_vcpus(struct kvm *kvm);
 void unlock_all_vcpus(struct kvm *kvm);
 
+int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
+			 u32 devid, u32 eventid, struct vgic_irq **irq);
+struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
+
 #endif
-- 
2.11.0
