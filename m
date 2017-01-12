From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 09/13] KVM: arm64: ITS: KVM_DEV_ARM_VGIC_GRP_ITS_TABLES group
Date: Thu, 12 Jan 2017 16:56:49 +0100
Message-ID: <1484236613-24633-10-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, Prasun.Kapoor@cavium.com, pbonzini@redhat.com, dgilbert@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Introduce a new group aiming at saving/restoring the ITS
tables to/from the guest memory.

We hold the its lock during the save and restore to prevent
any command from being executed. This also garantees the LPI
list is not going to change and no MSI injection can happen
during the operation.

At this stage the functionality is not yet implemented. Only
the skeleton is put in place.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

At the end of the restore I trigger a map_resources. This aims
at accomodating the virtio-net-pci guest use case. On restore I
can see the virtio-net-pci device sends MSI before the first
VCPU run. The fact we are not able to handle MSIs at that stage
stalls the virtio-net-pci device. We may fix this issue at QEMU
level instead.
---
 arch/arm/include/uapi/asm/kvm.h   |   1 +
 arch/arm64/include/uapi/asm/kvm.h |   1 +
 virt/kvm/arm/vgic/vgic-its.c      | 120 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index f6a167c..84fdfb0 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -193,6 +193,7 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO 7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS	8
+#define KVM_DEV_ARM_VGIC_GRP_ITS_TABLES	9
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 8850e9b..31e1137 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -213,6 +213,7 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO 7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
+#define KVM_DEV_ARM_VGIC_GRP_ITS_TABLES 9
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 32429fd..aeb9d08 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1548,6 +1548,117 @@ int vgic_its_attr_regs_access(struct kvm_device *dev,
 	return 0;
 }
 
+/**
+ * vgic_its_flush_pending_tables - Flush the pending tables into guest RAM
+ */
+static int vgic_its_flush_pending_tables(struct kvm *kvm,
+					 struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_restore_pending_tables - Restore the pending tables from guest
+ * RAM to internal data structs
+ */
+static int vgic_its_restore_pending_tables(struct kvm *kvm,
+					   struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_flush_device_tables - flush the device table and all ITT
+ * into guest RAM
+ */
+static int vgic_its_flush_device_tables(struct kvm *kvm, struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_restore_device_tables - restore the device table and all ITT
+ * from guest RAM to internal data structs
+ */
+static int vgic_its_restore_device_tables(struct kvm *kvm,
+					  struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_flush_collection_table - flush the collection table into
+ * guest RAM
+ */
+static int vgic_its_flush_collection_table(struct kvm *kvm,
+					   struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_restore_collection_table - reads the collection table
+ * in guest memory and restores the ITS internal state. Requires the
+ * BASER registers to be restored before.
+ */
+static int vgic_its_restore_collection_table(struct kvm *kvm,
+					     struct vgic_its *its)
+{
+	return -ENXIO;
+}
+
+/**
+ * vgic_its_table_flush - Flush all the tables into guest RAM
+ */
+static int vgic_its_table_flush(struct kvm *kvm,  struct vgic_its *its)
+{
+	int ret;
+
+	mutex_lock(&its->its_lock);
+
+	ret = vgic_its_flush_pending_tables(kvm, its);
+	if (ret)
+		goto out;
+	ret = vgic_its_flush_device_tables(kvm, its);
+	if (ret)
+		goto out;
+
+	ret = vgic_its_flush_collection_table(kvm, its);
+out:
+	mutex_unlock(&its->its_lock);
+	return ret;
+}
+
+/**
+ * vgic_its_table_restore - Restore all tables from guest RAM to internal
+ * data structs
+ */
+static int vgic_its_table_restore(struct kvm *kvm,  struct vgic_its *its)
+{
+	int ret;
+
+	mutex_lock(&its->its_lock);
+	ret = vgic_its_restore_collection_table(kvm, its);
+	if (ret)
+		goto out;
+
+	ret = vgic_its_restore_device_tables(kvm, its);
+	if (ret)
+		goto out;
+
+	ret = vgic_its_restore_pending_tables(kvm, its);
+out:
+	mutex_unlock(&its->its_lock);
+
+	/**
+	 *  HACK: In real use case we observe MSI injection before
+	 *  the first CPU run. This is likely to stall virtio-net-pci
+	 *  This may need a fix at user-space level instead
+	 */
+	ret = kvm_vgic_map_resources(kvm);
+	return ret;
+}
+
 static int vgic_its_has_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
@@ -1566,6 +1677,8 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_ITS_REGS:
 		return vgic_its_has_attr_regs(dev, attr);
+	case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
+		return 0;
 	}
 	return -ENXIO;
 }
@@ -1614,6 +1727,8 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 
 		return vgic_its_attr_regs_access(dev, attr, &reg, true);
 	}
+	case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
+		return vgic_its_table_restore(dev->kvm, its);
 	}
 	return -ENXIO;
 }
@@ -1621,9 +1736,10 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 static int vgic_its_get_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
+	struct vgic_its *its = dev->private;
+
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
-		struct vgic_its *its = dev->private;
 		u64 addr = its->vgic_its_base;
 		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
 		unsigned long type = (unsigned long)attr->attr;
@@ -1644,6 +1760,8 @@ static int vgic_its_get_attr(struct kvm_device *dev,
 		if (ret)
 			return ret;
 		return put_user(reg, uaddr);
+	case KVM_DEV_ARM_VGIC_GRP_ITS_TABLES:
+		return vgic_its_table_flush(dev->kvm, its);
 	}
 	default:
 		return -ENXIO;
-- 
2.5.5

