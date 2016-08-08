From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2] KVM: arm64: ITS: move ITS registration into first VCPU run
Date: Mon,  8 Aug 2016 16:45:43 +0100
Message-ID: <20160808154543.23463-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently we register an ITS device upon userland issuing the CTLR_INIT
ioctl to mark initialization of the ITS as done.
This deviates from the initialization sequence of the existing GIC
devices and does not play well with the way QEMU handles things.
To be more in line with what we are used to, register the ITS(es) just
before the first VCPU is about to run, so in the map_resources() call.
This involves iterating through the list of KVM devices and map each
ITS that we find.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v1 .. v2:
- remove not yet upstreamed locking
- remove pointless de-registration on rollback

 virt/kvm/arm/vgic/vgic-its.c | 43 +++++++++++++++++++++++++++++++++----------
 virt/kvm/arm/vgic/vgic-v3.c  |  8 ++++++++
 virt/kvm/arm/vgic/vgic.h     |  6 ++++++
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 07411cf..7180994 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1288,13 +1288,13 @@ void vgic_enable_lpis(struct kvm_vcpu *vcpu)
 		its_sync_lpi_pending_table(vcpu);
 }
 
-static int vgic_its_init_its(struct kvm *kvm, struct vgic_its *its)
+static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
 {
 	struct vgic_io_device *iodev = &its->iodev;
 	int ret;
 
-	if (its->initialized)
-		return 0;
+	if (!its->initialized)
+		return -EBUSY;
 
 	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base))
 		return -ENXIO;
@@ -1311,9 +1311,6 @@ static int vgic_its_init_its(struct kvm *kvm, struct vgic_its *its)
 				      KVM_VGIC_V3_ITS_SIZE, &iodev->dev);
 	mutex_unlock(&kvm->slots_lock);
 
-	if (!ret)
-		its->initialized = true;
-
 	return ret;
 }
 
@@ -1435,9 +1432,6 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 		if (type != KVM_VGIC_ITS_ADDR_TYPE)
 			return -ENODEV;
 
-		if (its->initialized)
-			return -EBUSY;
-
 		if (copy_from_user(&addr, uaddr, sizeof(addr)))
 			return -EFAULT;
 
@@ -1453,7 +1447,9 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
-			return vgic_its_init_its(dev->kvm, its);
+			its->initialized = true;
+
+			return 0;
 		}
 		break;
 	}
@@ -1498,3 +1494,30 @@ int kvm_vgic_register_its_device(void)
 	return kvm_register_device_ops(&kvm_arm_vgic_its_ops,
 				       KVM_DEV_TYPE_ARM_VGIC_ITS);
 }
+
+/*
+ * Registers all ITSes with the kvm_io_bus framework.
+ * To follow the existing VGIC initialization sequence, this has to be
+ * done as late as possible, just before the first VCPU runs.
+ */
+int vgic_register_its_iodevs(struct kvm *kvm)
+{
+	struct kvm_device *dev;
+	int ret = 0;
+
+	list_for_each_entry(dev, &kvm->devices, vm_node) {
+		if (dev->ops != &kvm_arm_vgic_its_ops)
+			continue;
+
+		ret = vgic_register_its_iodev(kvm, dev->private);
+		if (ret)
+			return ret;
+		/*
+		 * We don't need to care about tearing down previously
+		 * registered ITSes, as the kvm_io_bus framework removes
+		 * them for us if the VM gets destroyed.
+		 */
+	}
+
+	return ret;
+}
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 0506543..9f0dae3 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -289,6 +289,14 @@ int vgic_v3_map_resources(struct kvm *kvm)
 		goto out;
 	}
 
+	if (vgic_has_its(kvm)) {
+		ret = vgic_register_its_iodevs(kvm);
+		if (ret) {
+			kvm_err("Unable to register VGIC ITS MMIO regions\n");
+			goto out;
+		}
+	}
+
 	dist->ready = true;
 
 out:
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 1d8e21d..6c4625c 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -84,6 +84,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
+int vgic_register_its_iodevs(struct kvm *kvm);
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
@@ -140,6 +141,11 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 	return -ENODEV;
 }
 
+static inline int vgic_register_its_iodevs(struct kvm *kvm)
+{
+	return -ENODEV;
+}
+
 static inline bool vgic_has_its(struct kvm *kvm)
 {
 	return false;
-- 
2.9.0

